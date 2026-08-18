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
import { CompanySettingsModel, UserModel } from "../models/index.ts";
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

async function loginAs(
  username: string,
  password = TEST_PASSWORD,
): Promise<string> {
  const response = await app.inject(loginPayload(username, password));
  expect(response.statusCode).toBe(200);
  return response.cookies
    .map((cookie) => `${cookie.name}=${cookie.value}`)
    .join("; ");
}

const LOGO_PNG =
  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=";

const LOGO_SVG =
  "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjwvc3ZnPg==";

describe("rotas de configurações da empresa", () => {
  beforeAll(async () => {
    const { pool } = createFakeWingraphexPool();
    app = await createApp({
      mongoUri: getTestMongoUri("companySettings"),
      wingraphex: pool,
      logger: false,
    });
    await app.ready();
  });

  beforeEach(async () => {
    await Promise.all([
      UserModel.deleteMany({}),
      CompanySettingsModel.deleteMany({}),
    ]);
  });

  afterAll(async () => {
    await app.close();
  });

  test("GET retorna os padrões sem autenticação", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/api/settings",
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: "default",
      nome: "Mirante",
      logo: null,
    });
  });

  test("PATCH exige autenticação", async () => {
    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      payload: { nome: "Nova Empresa" },
    });

    expect(response.statusCode).toBe(401);
  });

  test("não-admin não pode atualizar", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { nome: "Nova Empresa" },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json()).toMatchObject({ message: "Acesso restrito." });
  });

  test("admin atualiza nome e logo", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { nome: "Gráfica Horizonte", logo: LOGO_PNG },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: "default",
      nome: "Gráfica Horizonte",
      logo: LOGO_PNG,
    });

    const fetched = await app.inject({ method: "GET", url: "/api/settings" });
    expect(fetched.json()).toMatchObject({
      nome: "Gráfica Horizonte",
      logo: LOGO_PNG,
    });
  });

  test("admin atualiza a logo em SVG", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { logo: LOGO_SVG },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({ logo: LOGO_SVG });
  });

  test("admin limpa a logo", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { logo: LOGO_PNG },
    });
    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { logo: null },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({ logo: null });
  });

  test("rejeita logo em formato inválido", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: { logo: "data:image/gif;base64,R0lGODlhAQABAAAAACw=" },
    });

    expect(response.statusCode).toBe(400);
  });

  test("rejeita payload vazio", async () => {
    const admin = await createTestUser({ role: "admin" });
    const cookie = await loginAs(admin.user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/settings",
      headers: { cookie },
      payload: {},
    });

    expect(response.statusCode).toBe(400);
  });
});