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
  CounterModel,
  ReciboEntregaModel,
  UserModel,
} from "../models/index.ts";
import { getTestMongoUri } from "../test/db.ts";
import { createTestUser, TEST_PASSWORD } from "../test/factories.ts";
import { createFakeWingraphexPool } from "../test/pool.ts";

let app: FastifyInstance;
let remoteAddressIndex = 0;

function loginPayload(username: string, password: string) {
  remoteAddressIndex += 1;
  return {
    method: "POST" as const,
    url: "/api/auth/login",
    payload: { username, password },
    remoteAddress: `10.0.${remoteAddressIndex}.1`,
  };
}

async function loginAs(username: string, password = TEST_PASSWORD): Promise<string> {
  const response = await app.inject(loginPayload(username, password));
  expect(response.statusCode).toBe(200);
  return response.cookies
    .map((cookie) => `${cookie.name}=${cookie.value}`)
    .join("; ");
}

function createReciboPayload(op = 5) {
  return {
    dataEntrega: "2026-08-16",
    itens: [
      {
        op,
        cliente: "Cliente X",
        descricao: "Cartão de visita",
        quantidade: 500,
      },
    ],
  };
}

describe("rotas de entregas", () => {
  beforeAll(async () => {
    const { pool } = createFakeWingraphexPool();
    app = await createApp({
      mongoUri: getTestMongoUri("entrega"),
      wingraphex: pool,
      logger: false,
    });
    await app.ready();
  });

  beforeEach(async () => {
    await Promise.all([
      UserModel.deleteMany({}),
      ReciboEntregaModel.deleteMany({}),
      CounterModel.deleteMany({}),
    ]);
  });

  afterAll(async () => {
    await app.close();
  });

  test("usuário autenticado cria recibo e recebe 201", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "POST",
      url: "/api/entregas",
      headers: { cookie },
      payload: createReciboPayload(),
    });

    expect(response.statusCode).toBe(201);
    expect(response.json()).toMatchObject({
      numero: 1,
      dataEntrega: "2026-08-16",
      usuario: { id: String(user._id), nome: user.name },
      itens: [{ op: 5, quantidade: 500, descricao: "Cartão de visita" }],
    });
  });

  test("busca o histórico de entregas da OP", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    await app.inject({
      method: "POST",
      url: "/api/entregas",
      headers: { cookie },
      payload: createReciboPayload(7),
    });

    const response = await app.inject({
      method: "GET",
      url: "/api/entregas/op/7",
      headers: { cookie },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toHaveLength(1);
    expect(response.json()[0].itens[0].op).toBe(7);
  });

  test("autor exclui o próprio recibo", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/entregas",
      headers: { cookie },
      payload: createReciboPayload(),
    });
    const reciboId = created.json().id as string;

    const deleted = await app.inject({
      method: "DELETE",
      url: `/api/entregas/${reciboId}`,
      headers: { cookie },
    });

    expect(deleted.statusCode).toBe(204);
    expect(await ReciboEntregaModel.countDocuments({}).exec()).toBe(0);
  });

  test("não-admin não pode excluir recibo de outro usuário", async () => {
    const author = await createTestUser();
    const authorCookie = await loginAs(author.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/entregas",
      headers: { cookie: authorCookie },
      payload: createReciboPayload(),
    });
    const reciboId = created.json().id as string;

    const maria = await createTestUser();
    const mariaCookie = await loginAs(maria.user.username);

    const deleted = await app.inject({
      method: "DELETE",
      url: `/api/entregas/${reciboId}`,
      headers: { cookie: mariaCookie },
    });

    expect(deleted.statusCode).toBe(403);
    expect(deleted.json()).toMatchObject({ message: "Acesso restrito." });
    expect(await ReciboEntregaModel.findById(reciboId).exec()).not.toBeNull();
  });

  test("admin pode excluir recibo de outro usuário", async () => {
    const author = await createTestUser();
    const authorCookie = await loginAs(author.user.username);
    const created = await app.inject({
      method: "POST",
      url: "/api/entregas",
      headers: { cookie: authorCookie },
      payload: createReciboPayload(),
    });
    const reciboId = created.json().id as string;

    const admin = await createTestUser({ role: "admin" });
    const adminCookie = await loginAs(admin.user.username);

    const deleted = await app.inject({
      method: "DELETE",
      url: `/api/entregas/${reciboId}`,
      headers: { cookie: adminCookie },
    });

    expect(deleted.statusCode).toBe(204);
    expect(await ReciboEntregaModel.findById(reciboId).exec()).toBeNull();
  });
});