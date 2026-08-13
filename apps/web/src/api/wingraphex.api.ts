import type {
  OpsResponse,
  QueryClientesParams,
  QueryOpsParams,
  WingraphexCliente,
} from "@/features/wingraphex/wingraphex.schemas";
import {
  clienteSchema,
  opsResponseSchema,
  queryClientesParamsSchema,
  queryOpsParamsSchema,
} from "@/features/wingraphex/wingraphex.schemas";

import { api } from "./client";

export async function queryOps(
  params: QueryOpsParams,
): Promise<OpsResponse> {
  const parsed = queryOpsParamsSchema.parse(params);
  const { data } = await api.get<unknown>("/wingraphex/ops", {
    params: parsed,
  });
  return opsResponseSchema.parse(data);
}

export async function queryClientes(
  params: QueryClientesParams,
): Promise<WingraphexCliente[]> {
  const parsed = queryClientesParamsSchema.parse(params);
  const { data } = await api.get<unknown>("/wingraphex/clientes", {
    params: parsed,
  });
  if (!Array.isArray(data)) {
    throw new Error("Resposta inválida da API");
  }
  return data.map((item) => clienteSchema.parse(item));
}