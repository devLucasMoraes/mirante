import { describe, expect, test } from "vitest";

import { defineAbilityFor } from "./ability.ts";
import type { User } from "./schemas.ts";

const baseUser: User = {
  __typename: "User",
  id: "user-1",
  username: "joao",
  name: "João",
  role: "user",
};

const admin: User = {
  __typename: "User",
  id: "admin-1",
  username: "admin",
  name: "Administrador",
  role: "admin",
};

describe("defineAbilityFor", () => {
  test("todas as roles podem ler operações do Wingraphex", () => {
    expect(defineAbilityFor(baseUser).can("read", "WingraphexOp")).toBe(true);
    expect(defineAbilityFor(admin).can("read", "WingraphexOp")).toBe(true);
  });

  test("admin gerencia qualquer assunto", () => {
    expect(defineAbilityFor(admin).can("manage", "all")).toBe(true);
  });

  test("não-admin não pode deletar recibo de terceiros", () => {
    const ability = defineAbilityFor(baseUser);
    const reciboDeTerceiro = {
      __typename: "ReciboEntrega",
      usuario: { id: "outro" },
    } as const;
    expect(ability.can("delete", reciboDeTerceiro)).toBe(false);
  });

  test("não-admin pode atualizar o próprio nome e senha, mas não o role", () => {
    const ability = defineAbilityFor(baseUser);
    expect(ability.can("update", "User", "name")).toBe(true);
    expect(ability.can("update", "User", "password")).toBe(true);
    expect(ability.can("update", "User", "role")).toBe(false);
  });
});