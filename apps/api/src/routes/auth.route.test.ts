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
  RefreshTokenModel,
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

describe("rotas de autenticação", () => {
  beforeAll(async () => {
    const { pool } = createFakeWingraphexPool();
    app = await createApp({
      mongoUri: getTestMongoUri("auth"),
      wingraphex: pool,
      logger: false,
    });
    await app.ready();
  });

  beforeEach(async () => {
    await Promise.all([
      UserModel.deleteMany({}),
      RefreshTokenModel.deleteMany({}),
    ]);
  });

  afterAll(async () => {
    await app.close();
  });

  test("login com credenciais válidas retorna usuário e define cookies", async () => {
    const { user } = await createTestUser();

    const response = await app.inject(
      loginPayload(user.username, TEST_PASSWORD),
    );

    expect(response.statusCode).toBe(200);
    expect(response.json().user).toMatchObject({
      username: user.username,
      name: user.name,
      role: "user",
    });

    const cookieNames = response.cookies.map((cookie) => cookie.name);
    expect(cookieNames).toContain("access_token");
    expect(cookieNames).toContain("refresh_token");
  });

  test("login com senha errada retorna 401", async () => {
    const { user } = await createTestUser();

    const response = await app.inject(
      loginPayload(user.username, "senha-errada"),
    );

    expect(response.statusCode).toBe(401);
    expect(response.json()).toMatchObject({ message: "Credenciais inválidas." });
  });

  test("refresh rotaciona tokens e mantém a sessão", async () => {
    const { user } = await createTestUser();
    const login = await app.inject(loginPayload(user.username, TEST_PASSWORD));
    remoteAddressIndex += 1;

    const cookieHeader = login.cookies
      .map((cookie) => `${cookie.name}=${cookie.value}`)
      .join("; ");
    const refreshBefore = login.cookies.find(
      (cookie) => cookie.name === "refresh_token",
    )?.value;

    const response = await app.inject({
      method: "POST",
      url: "/api/auth/refresh",
      headers: { cookie: cookieHeader },
      remoteAddress: `10.0.${remoteAddressIndex}.1`,
    });

    expect(response.statusCode).toBe(204);
    const refreshAfter = response.cookies.find(
      (cookie) => cookie.name === "refresh_token",
    )?.value;
    expect(refreshAfter).toBeDefined();
    expect(refreshAfter).not.toBe(refreshBefore);
  });

  test("refresh sem cookie retorna 401", async () => {
    remoteAddressIndex += 1;
    const response = await app.inject({
      method: "POST",
      url: "/api/auth/refresh",
      remoteAddress: `10.0.${remoteAddressIndex}.1`,
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().message).toBe("Refresh token ausente.");
  });

  test("logout revoga o refresh token e limpa cookies", async () => {
    const { user } = await createTestUser();
    const login = await app.inject(loginPayload(user.username, TEST_PASSWORD));
    remoteAddressIndex += 1;

    const cookieHeader = login.cookies
      .map((cookie) => `${cookie.name}=${cookie.value}`)
      .join("; ");

    const response = await app.inject({
      method: "POST",
      url: "/api/auth/logout",
      headers: { cookie: cookieHeader },
      remoteAddress: `10.0.${remoteAddressIndex}.1`,
    });

    expect(response.statusCode).toBe(204);

    const refreshCookie = response.cookies.find(
      (cookie) => cookie.name === "refresh_token",
    );
    expect(refreshCookie).toBeDefined();
    expect(refreshCookie?.value).toBe("");

    const stored = await RefreshTokenModel.findOne({}).exec();
    expect(stored?.revokedAt).not.toBeNull();
  });
});