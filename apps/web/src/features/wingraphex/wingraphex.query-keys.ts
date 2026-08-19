import type {
  EmpresaFilter,
  QueryOpsImpressaoParams,
  QueryOpsParams,
} from "./wingraphex.schemas";

export const wingraphexKeys = {
  all: ["wingraphex"] as const,
  ops: (params: QueryOpsParams) =>
    [...wingraphexKeys.all, "ops", params] as const,
  opsImpressao: (params: QueryOpsImpressaoParams) =>
    [...wingraphexKeys.all, "ops-impressao", params] as const,
  clientes: (params: { term: string; empresa: EmpresaFilter }) =>
    [...wingraphexKeys.all, "clientes", params] as const,
};
