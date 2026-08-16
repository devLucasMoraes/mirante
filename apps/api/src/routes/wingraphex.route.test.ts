import type { FastifyInstance } from "fastify";
import { afterAll, beforeAll, beforeEach, describe, expect, test } from "vitest";

import { createApp } from "../app.ts";
import { getTestMongoUri } from "../test/db.ts";
import {
  createFakeClienteRow,
  createFakeOpRow,
  createTestUser,
  TEST_PASSWORD,
} from "../test/factories.ts";
import { createFakeWingraphexPool } from "../test/pool.ts";

let app: FastifyInstance;
let query: ReturnType<typeof createFakeWingraphexPool>["query"];
let remoteAddressIndex = 0;

describe("rotas do wingraphex", () => {
  beforeAll(async () => {
    const fake = createFakeWingraphexPool();
    query = fake.query;
    app = await createApp({
      mongoUri: getTestMongoUri("wingraphex"),
      wingraphex: fake.pool,
      logger: false,
    });
    await app.ready();

    await createTestUser({ username: "joao", name: "João" });
  });

  beforeEach(() => {
    query.mockReset();
    query.mockImplementation(async (sql: string) => {
      if (sql.includes("ORDER BY os.ORS_DATA")) {
        return [[opRow], []];
      }
      if (sql.includes("COUNT(*)")) {
        return [[{ total: "1" }], []];
      }
      if (sql.includes("FROM pessoa p")) {
        return [[clienteRow], []];
      }
      return [[], []];
    });
  });

  afterAll(async () => {
    await app.close();
  });

  const opRow = createFakeOpRow();
  const clienteRow = createFakeClienteRow();

  async function loginAs() {
    remoteAddressIndex += 1;
    const response = await app.inject({
      method: "POST",
      url: "/api/auth/login",
      payload: { username: "joao", password: TEST_PASSWORD },
      remoteAddress: `10.0.${remoteAddressIndex}.1`,
    });
    expect(response.statusCode).toBe(200);
    return response.cookies
      .map((cookie) => `${cookie.name}=${cookie.value}`)
      .join("; ");
  }

  test("consulta OPs por descrição", async () => {
    const cookie = await loginAs();
    const response = await app.inject({
      method: "GET",
      url: "/api/wingraphex/ops",
      headers: { cookie },
      query: { descricao: "cartao", pagina: "1", limite: "10" },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.itens).toHaveLength(1);
    expect(body.itens[0]).toMatchObject({
      op: Number(opRow.op),
      descricao: opRow.descricao,
      qtd_total: Number(opRow.qtd_total),
      valor_servico: Number(opRow.valor_servico),
      entregue: 0,
    });
    expect(body.total).toBe(1);
    expect(body.totalPaginas).toBe(1);
  });

  test("consulta clientes", async () => {
    const cookie = await loginAs();
    const response = await app.inject({
      method: "GET",
      url: "/api/wingraphex/clientes",
      headers: { cookie },
      query: { term: "cliente", limite: "5" },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual([
      {
        id: clienteRow.id,
        nome: clienteRow.nome,
        fantasia: clienteRow.fantasia,
      },
    ]);
  });

  test("exige um filtro na consulta de OPs", async () => {
    const cookie = await loginAs();
    const response = await app.inject({
      method: "GET",
      url: "/api/wingraphex/ops",
      headers: { cookie },
    });

    expect(response.statusCode).toBe(400);
  });

  test("bloqueia acesso sem autenticação", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/api/wingraphex/ops",
      query: { descricao: "cartao" },
    });

    expect(response.statusCode).toBe(401);
  });
});