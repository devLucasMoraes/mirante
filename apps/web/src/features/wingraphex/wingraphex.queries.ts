import {
  keepPreviousData,
  queryOptions,
  useQuery,
} from "@tanstack/react-query";

import { queryClientes, queryOps } from "@/api/wingraphex.api";

import { wingraphexKeys } from "./wingraphex.query-keys";
import type {
  QueryClientesParams,
  QueryOpsParams,
} from "./wingraphex.schemas";

export const OPS_PER_PAGE = 20;

function hasOpsCriteria(params: QueryOpsParams): boolean {
  return (
    (params.descricao?.trim().length ?? 0) > 0 ||
    params.clienteId !== undefined ||
    params.dataInicio !== undefined ||
    params.dataFim !== undefined
  );
}

export function opsQueryOptions(params: QueryOpsParams) {
  const normalized: QueryOpsParams = {
    ...params,
    pagina: params.pagina ?? 1,
    limite: OPS_PER_PAGE,
  };
  return queryOptions({
    queryKey: wingraphexKeys.ops(normalized),
    queryFn: () => queryOps(normalized),
    enabled: hasOpsCriteria(normalized),
  });
}

export function useOpsQuery(params: QueryOpsParams) {
  return useQuery(opsQueryOptions(params));
}

export function clientesQueryOptions(params: QueryClientesParams) {
  const term = params.term?.trim() ?? "";
  return queryOptions({
    queryKey: wingraphexKeys.clientes(term),
    queryFn: () => queryClientes({ term }),
    enabled: term.length >= 2,
    staleTime: 60_000,
    placeholderData: keepPreviousData,
  });
}

export function useClientesQuery(params: QueryClientesParams) {
  return useQuery(clientesQueryOptions(params));
}
