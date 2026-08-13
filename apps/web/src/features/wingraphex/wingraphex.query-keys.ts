import type { QueryOpsParams } from "./wingraphex.schemas";

export const wingraphexKeys = {
  all: ["wingraphex"] as const,
  ops: (params: QueryOpsParams) =>
    [...wingraphexKeys.all, "ops", params] as const,
  clientes: (term: string) =>
    [...wingraphexKeys.all, "clientes", term] as const,
};
