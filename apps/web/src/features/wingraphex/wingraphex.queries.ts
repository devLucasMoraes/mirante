import {
  keepPreviousData,
  queryOptions,
  useQuery,
} from "@tanstack/react-query";

import { queryClientes, queryOps } from "@/api/wingraphex.api";

import { wingraphexKeys } from "./wingraphex.query-keys";
import type {
  QueryClientesParams,
  QueryOpsImpressaoParams,
  QueryOpsParams,
  WingraphexOp,
} from "./wingraphex.schemas";

export const OPS_PER_PAGE = 15;

export const OPS_POR_FOLHA = 15;

const IMPRESSAO_PAGE_LIMITE = 100;

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
    empresa: params.empresa ?? "ambas",
    ordenarPor: params.ordenarPor ?? "emissao",
    direcao: params.direcao ?? "asc",
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

async function queryAllOps(
  params: QueryOpsImpressaoParams,
): Promise<WingraphexOp[]> {
  const base: QueryOpsParams = {
    ...params,
    pagina: 1,
    limite: IMPRESSAO_PAGE_LIMITE,
  };
  const primeira = await queryOps(base);
  const itens = [...primeira.itens];
  if (primeira.total <= itens.length) {
    return itens;
  }
  const totalPaginas = Math.ceil(primeira.total / IMPRESSAO_PAGE_LIMITE);
  const restantes = await Promise.all(
    Array.from({ length: totalPaginas - 1 }, (_, index) =>
      queryOps({ ...base, pagina: index + 2 }),
    ),
  );
  for (const pagina of restantes) {
    itens.push(...pagina.itens);
  }
  return itens;
}

export function opsImpressaoQueryOptions(
  params: QueryOpsImpressaoParams,
  enabled = true,
) {
  const normalized: QueryOpsImpressaoParams = {
    ...params,
    empresa: params.empresa ?? "ambas",
    ordenarPor: params.ordenarPor ?? "emissao",
    direcao: params.direcao ?? "asc",
  };
  return queryOptions({
    queryKey: wingraphexKeys.opsImpressao(normalized),
    queryFn: () => queryAllOps(normalized),
    enabled: hasOpsCriteria(normalized) && enabled,
  });
}

export function useOpsImpressaoQuery(
  params: QueryOpsImpressaoParams,
  enabled = true,
) {
  return useQuery(opsImpressaoQueryOptions(params, enabled));
}

export function clientesQueryOptions(params: QueryClientesParams) {
  const term = params.term?.trim() ?? "";
  const empresa = params.empresa ?? "ambas";
  return queryOptions({
    queryKey: wingraphexKeys.clientes({ term, empresa }),
    queryFn: () => queryClientes({ term, empresa }),
    enabled: term.length >= 2,
    staleTime: 60_000,
    placeholderData: keepPreviousData,
  });
}

export function useClientesQuery(params: QueryClientesParams) {
  return useQuery(clientesQueryOptions(params));
}
