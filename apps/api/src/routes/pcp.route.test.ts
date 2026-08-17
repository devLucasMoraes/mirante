import type { FastifyInstance } from "fastify";
import {
  afterAll,
  beforeAll,
  beforeEach,
  describe,
  expect,
  test,
} from "vitest";

import { createApp } from "../app.ts";
import {
  PcpEquipamentoSetorModel,
  PcpSetorModel,
  UserModel,
} from "../models/index.ts";
import { getTestMongoUri } from "../test/db.ts";
import { createTestUser, TEST_PASSWORD } from "../test/factories.ts";
import { createFakeWingraphexPool } from "../test/pool.ts";

let app: FastifyInstance;
let query: ReturnType<typeof createFakeWingraphexPool>["query"];
let remoteAddressIndex = 0;

const equipamentoRows = [
  { CODIGO: "5", DESCRICAO: "SM 52" },
  { CODIGO: "21", DESCRICAO: "SM 102" },
  { CODIGO: "44", DESCRICAO: "GUILHOTINA 80" },
];

function loginPayload(username: string, password: string) {
  remoteAddressIndex += 1;
  return {
    method: "POST" as const,
    url: "/api/auth/login",
    payload: { username, password },
    remoteAddress: `10.${remoteAddressIndex}.1`,
  };
}

async function loginAs(username: string, password = TEST_PASSWORD): Promise<string> {
  const response = await app.inject(loginPayload(username, password));
  expect(response.statusCode).toBe(200);
  return response.cookies
    .map((cookie) => `${cookie.name}=${cookie.value}`)
    .join("; ");
}

describe("rotas de PCP", () => {
  beforeAll(async () => {
    const fake = createFakeWingraphexPool();
    query = fake.query;
    app = await createApp({
      mongoUri: getTestMongoUri("pcp"),
      wingraphex: fake.pool,
      logger: false,
    });
    await app.ready();
  });

  beforeEach(async () => {
    query.mockReset();
    query.mockImplementation(async (sql: string) => {
      if (sql.includes("FROM equipamento")) {
        return [equipamentoRows, []];
      }
      return [[], []];
    });
    await Promise.all([
      UserModel.deleteMany({}),
      PcpSetorModel.deleteMany({}),
      PcpEquipamentoSetorModel.deleteMany({}),
    ]);
  });

  afterAll(async () => {
    await app.close();
  });

  test("lista setores vazia para usuário autenticado", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "GET",
      url: "/api/pcp/setores",
      headers: { cookie },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual([]);
  });

  test("admin cria setor com ordem sequencial", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const first = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    expect(first.statusCode).toBe(201);
    expect(first.json()).toMatchObject({ nome: "Impressão", ordem: 0 });

    const second = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Acabamento" },
    });
    expect(second.statusCode).toBe(201);
    expect(second.json()).toMatchObject({ nome: "Acabamento", ordem: 1 });
  });

  test("criação de setor com nome duplicado retorna 409", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const duplicate = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "  Impressão  " },
    });

    expect(duplicate.statusCode).toBe(409);
  });

  test("não-admin não cria setor", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });

    expect(response.statusCode).toBe(403);
    expect(await PcpSetorModel.countDocuments({}).exec()).toBe(0);
  });

  test("admin renomeia setor", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const id = created.json().id as string;

    const response = await app.inject({
      method: "PATCH",
      url: `/api/pcp/setores/${id}`,
      headers: { cookie },
      payload: { nome: "Impressão Offset" },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id,
      nome: "Impressão Offset",
      ordem: 0,
    });
  });

  test("admin reordena setores", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const criar = async (nome: string): Promise<string> => {
      const response = await app.inject({
        method: "POST",
        url: "/api/pcp/setores",
        headers: { cookie },
        payload: { nome },
      });
      return response.json().id as string;
    };
    const a = await criar("Impressão");
    const b = await criar("Acabamento");
    const c = await criar("Pré-impressão");

    const reordered = await app.inject({
      method: "PATCH",
      url: "/api/pcp/setores/ordem",
      headers: { cookie },
      payload: { ids: [c, a, b] },
    });
    expect(reordered.statusCode).toBe(204);

    const list = await app.inject({
      method: "GET",
      url: "/api/pcp/setores",
      headers: { cookie },
    });
    expect(list.json().map((setor: { id: string }) => setor.id)).toEqual([
      c,
      a,
      b,
    ]);
  });

  test("reordenação com setor inexistente retorna 400", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const id = created.json().id as string;

    const response = await app.inject({
      method: "PATCH",
      url: "/api/pcp/setores/ordem",
      headers: { cookie },
      payload: {
        ids: [id, "000000000000000000000000"],
      },
    });

    expect(response.statusCode).toBe(400);
  });

  test("admin exclui setor e desvincula equipamentos", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const id = created.json().id as string;

    await app.inject({
      method: "PATCH",
      url: "/api/pcp/equipamentos/21/setor",
      headers: { cookie },
      payload: { setorId: id },
    });

    const deleted = await app.inject({
      method: "DELETE",
      url: `/api/pcp/setores/${id}`,
      headers: { cookie },
    });
    expect(deleted.statusCode).toBe(204);
    expect(await PcpSetorModel.findById(id).exec()).toBeNull();
    expect(await PcpEquipamentoSetorModel.countDocuments({}).exec()).toBe(0);
  });

  test("lista equipamentos do catálogo com setores", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const setorId = created.json().id as string;

    await app.inject({
      method: "PATCH",
      url: "/api/pcp/equipamentos/5/setor",
      headers: { cookie },
      payload: { setorId },
    });

    const response = await app.inject({
      method: "GET",
      url: "/api/pcp/equipamentos",
      headers: { cookie },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual([
      { codigo: 5, nome: "SM 52", setorId },
      { codigo: 21, nome: "SM 102", setorId: null },
      { codigo: 44, nome: "GUILHOTINA 80", setorId: null },
    ]);
    expect(query).toHaveBeenCalled();
    const sqlChamado = query.mock.calls.find(([sql]) =>
      String(sql).includes("FROM equipamento"),
    )?.[0] as string;
    expect(sqlChamado).toContain("DESATIVADO");
  });

  test("vínculo excluiu equipamentos desabilitados do catálogo", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "GET",
      url: "/api/pcp/equipamentos",
      headers: { cookie },
    });

    expect(response.statusCode).toBe(200);
    const codigos = response.json().map(
      (equipamento: { codigo: number }) => equipamento.codigo,
    );
    expect(codigos).not.toContain(99);
  });

  test("admin vincula e desvincula equipamento", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/pcp/setores",
      headers: { cookie },
      payload: { nome: "Impressão" },
    });
    const setorId = created.json().id as string;

    const vinculado = await app.inject({
      method: "PATCH",
      url: "/api/pcp/equipamentos/44/setor",
      headers: { cookie },
      payload: { setorId },
    });
    expect(vinculado.statusCode).toBe(204);
    expect(await PcpEquipamentoSetorModel.countDocuments({}).exec()).toBe(1);

    const desvinculado = await app.inject({
      method: "PATCH",
      url: "/api/pcp/equipamentos/44/setor",
      headers: { cookie },
      payload: { setorId: null },
    });
    expect(desvinculado.statusCode).toBe(204);
    expect(await PcpEquipamentoSetorModel.countDocuments({}).exec()).toBe(0);
  });

  test("vínculo com setor inexistente retorna 404", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/pcp/equipamentos/21/setor",
      headers: { cookie },
      payload: { setorId: "000000000000000000000000" },
    });

    expect(response.statusCode).toBe(404);
  });

  test("não-admin pode ler setores e equipamentos", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const setores = await app.inject({
      method: "GET",
      url: "/api/pcp/setores",
      headers: { cookie },
    });
    expect(setores.statusCode).toBe(200);

    const equipamentos = await app.inject({
      method: "GET",
      url: "/api/pcp/equipamentos",
      headers: { cookie },
    });
    expect(equipamentos.statusCode).toBe(200);
  });

  test("exige autenticação", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/api/pcp/setores",
    });
    expect(response.statusCode).toBe(401);
  });
});