import type { ReactNode } from "react";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { renderHook, waitFor } from "@testing-library/react";
import { describe, expect, test } from "vitest";

import {
  useCreateReciboMutation,
  useReciboPorOpQuery,
} from "@/features/entregas/entrega.queries";
import type { ReciboEntrega } from "@/features/entregas/entrega.schemas";

function providerWith(queryClient: QueryClient) {
  return function Providers({ children }: { children: ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
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

describe("useReciboPorOpQuery", () => {
  test("carrega os recibos da OP", async () => {
    const { result } = renderHook(() => useReciboPorOpQuery(5), {
      wrapper: providerWith(createQueryClient()),
    });

    await waitFor(() => expect(result.current.isSuccess).toBe(true));

    expect(result.current.data).toHaveLength(2);
    expect(result.current.data?.[0]?.itens[0]?.op).toBe(5);
  });

  test("não dispara requisição para op inválida", async () => {
    const { result } = renderHook(() => useReciboPorOpQuery(0), {
      wrapper: providerWith(createQueryClient()),
    });

    expect(result.current.fetchStatus).toBe("idle");
    expect(result.current.data).toBeUndefined();
  });
});

describe("useCreateReciboMutation", () => {
  test("cria um recibo e devolve a resposta", async () => {
    const { result } = renderHook(() => useCreateReciboMutation(), {
      wrapper: providerWith(createQueryClient()),
    });

    let created: ReciboEntrega | undefined;
    result.current.mutate(
      {
        dataEntrega: "2026-08-16",
        itens: [
          {
            op: 5,
            cliente: "Cliente X",
            descricao: "Cartão de visita",
            quantidade: 500,
          },
        ],
      },
      {
        onSuccess: (data) => {
          created = data;
        },
      },
    );

    await waitFor(() => expect(result.current.isSuccess).toBe(true));
    expect(created?.numero).toBe(3);
    expect(created?.itens[0]?.op).toBe(5);
  });
});