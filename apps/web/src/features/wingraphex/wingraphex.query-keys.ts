import type { EmpresaFilter, QueryOpsParams } from "./wingraphex.schemas";

export const wingraphexKeys = {
  all: ["wingraphex"] as const,
  ops: (params: QueryOpsParams) =>
    [...wingraphexKeys.all, "ops", params] as const,
  clientes: (params: { term: string; empresa: EmpresaFilter }) =>
    [...wingraphexKeys.all, "clientes", params] as const,
};
