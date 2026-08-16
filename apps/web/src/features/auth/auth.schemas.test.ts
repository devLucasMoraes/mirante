import { describe, expect, test } from "vitest";

import { authResponseSchema, credentialsSchema } from "./auth.schemas";

describe("credentialsSchema", () => {
  test("aceita credenciais válidas", () => {
    const result = credentialsSchema.safeParse({
      username: "joao",
      password: "senha123",
    });
    expect(result.success).toBe(true);
  });

  test("rejeita usuário com menos de 3 caracteres", () => {
    const result = credentialsSchema.safeParse({
      username: "ab",
      password: "senha123",
    });
    expect(result.success).toBe(false);
  });

  test("rejeita senha com menos de 6 caracteres", () => {
    const result = credentialsSchema.safeParse({
      username: "joao",
      password: "123",
    });
    expect(result.success).toBe(false);
  });
});

describe("authResponseSchema", () => {
  test("aceita resposta de autenticação com usuário válido", () => {
    const result = authResponseSchema.safeParse({
      user: {
        __typename: "User",
        id: "user-1",
        username: "joao",
        name: "João",
        role: "user",
      },
    });
    expect(result.success).toBe(true);
  });
});