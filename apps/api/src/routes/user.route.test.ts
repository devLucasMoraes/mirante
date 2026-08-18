import type { FastifyInstance } from "fastify";
import { Types } from "mongoose";
import {
  afterAll,
  beforeAll,
  beforeEach,
  describe,
  expect,
  test,
} from "vitest";

import { createApp } from "../app.ts";
import { RefreshTokenModel, UserModel } from "../models/index.ts";
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
  return response.cookies
    .map((cookie) => `${cookie.name}=${cookie.value}`)
    .join("; ");
}

describe("rotas de usuários", () => {
  beforeAll(async () => {
    const { pool } = createFakeWingraphexPool();
    app = await createApp({
      mongoUri: getTestMongoUri("user"),
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

  test("não-admin altera o próprio usuário (login)", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${String(user._id)}`,
      headers: { cookie },
      payload: { username: "novo.login" },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: String(user._id),
      username: "novo.login",
    });
  });

  test("não-admin não pode alterar o próprio nome", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${String(user._id)}`,
      headers: { cookie },
      payload: { name: "Nome Alterado" },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().message).toBe("Acesso restrito.");
  });

  test("não-admin não pode alterar usuário de outro", async () => {
    const { user } = await createTestUser();
    const { user: outro } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${String(outro._id)}`,
      headers: { cookie },
      payload: { username: "hacked.login" },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().message).toBe("Acesso restrito.");
  });

  test("alterar login para um já existente retorna 409", async () => {
    const { user } = await createTestUser();
    const { user: outro } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${String(user._id)}`,
      headers: { cookie },
      payload: { username: outro.username },
    });

    expect(response.statusCode).toBe(409);
    expect(response.json().message).toBe("Já existe um usuário com esse nome.");
  });

  test("alterar login de usuário inexistente retorna 404", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${new Types.ObjectId().toString()}`,
      headers: { cookie },
      payload: { username: "sem.registro" },
    });

    expect(response.statusCode).toBe(404);
    expect(response.json().message).toBe("Usuário não encontrado.");
  });

  test("alterar login com id inválido retorna 404", async () => {
    const { user } = await createTestUser();
    const cookie = await loginAs(user.username);

    const response = await app.inject({
      method: "PATCH",
      url: "/api/users/nao-e-um-objectid",
      headers: { cookie },
      payload: { username: "sem.registro" },
    });

    expect(response.statusCode).toBe(404);
    expect(response.json().message).toBe("Usuário não encontrado.");
  });

  test("admin pode alterar o nome de qualquer usuário", async () => {
    const { user: admin } = await createTestUser({ role: "admin" });
    const { user } = await createTestUser();
    const cookie = await loginAs(admin.username);

    const response = await app.inject({
      method: "PATCH",
      url: `/api/users/${String(user._id)}`,
      headers: { cookie },
      payload: { name: "Nome do Admin" },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      id: String(user._id),
      name: "Nome do Admin",
    });
  });
});
