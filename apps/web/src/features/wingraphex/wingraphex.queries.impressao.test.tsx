import type { ReactNode } from "react";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { renderHook, waitFor } from "@testing-library/react";
import { http, HttpResponse } from "msw";
import { describe, expect, test } from "vitest";

import { server } from "@/test/server";

import { useOpsImpressaoQuery } from "./wingraphex.queries";
import type { WingraphexOp } from "./wingraphex.schemas";
import { opFactory } from "./wingraphex.test-utils";

function providerWith(queryClient: QueryClient) {
  return function Providers({ children }: { children: ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    );
  };
}

function createQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });
}

function mockOpsEndpoint(ops: WingraphexOp[]) {
  server.use(
    http.get("*/api/wingraphex/ops", ({ request }) => {
      const url = new URL(request.url);
      const pagina = Number(url.searchParams.get("pagina") ?? "1");
      const limite = Number(url.searchParams.get("limite") ?? "15");
      const total = ops.length;
      const totalPaginas = Math.ceil(total / limite);
      const inicio = (pagina - 1) * limite;
      return HttpResponse.json({
        itens: ops.slice(inicio, inicio + limite),
        total,
        pagina,
        totalPaginas,
      });
    }),
  );
}

describe("useOpsImpressaoQuery", () => {
  test("mescla todas as páginas da consulta", async () => {
    const ops = Array.from({ length: 150 }, (_, index) =>
      opFactory({ op: index + 1 }),
    );
    mockOpsEndpoint(ops);

    const { result } = renderHook(
      () => useOpsImpressaoQuery({ descricao: "teste" }),
      { wrapper: providerWith(createQueryClient()) },
    );

    await waitFor(() => expect(result.current.isSuccess).toBe(true));

    expect(result.current.data).toHaveLength(150);
    expect(result.current.data?.[0]?.op).toBe(1);
    expect(result.current.data?.[149]?.op).toBe(150);
  });

  test("respeita o enable para não buscar com o diálogo fechado", async () => {
    const ops = Array.from({ length: 15 }, (_, index) =>
      opFactory({ op: index + 1 }),
    );
    mockOpsEndpoint(ops);

    const { result } = renderHook(
      () => useOpsImpressaoQuery({ descricao: "teste" }, false),
      { wrapper: providerWith(createQueryClient()) },
    );

    expect(result.current.fetchStatus).toBe("idle");
    expect(result.current.data).toBeUndefined();
  });

  test("não dispara requisição sem critério de busca", async () => {
    const { result } = renderHook(
      () => useOpsImpressaoQuery({}),
      { wrapper: providerWith(createQueryClient()) },
    );

    expect(result.current.fetchStatus).toBe("idle");
    expect(result.current.data).toBeUndefined();
  });
});