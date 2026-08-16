import {
  queryOptions,
  useMutation,
  useQuery,
  useQueryClient,
} from "@tanstack/react-query";

import {
  createRecibo,
  deleteRecibo,
  reciboPorOp,
} from "@/api/entrega.api";
import { wingraphexKeys } from "@/features/wingraphex/wingraphex.query-keys";

import { entregaKeys } from "./entrega.query-keys";
import type { CreateReciboPayload } from "./entrega.schemas";

export function reciboPorOpQueryOptions(opId: number) {
  return queryOptions({
    queryKey: entregaKeys.op(opId),
    queryFn: () => reciboPorOp(opId),
    enabled: opId > 0,
    staleTime: 5_000,
  });
}

export function useReciboPorOpQuery(opId: number) {
  return useQuery(reciboPorOpQueryOptions(opId));
}

function refreshEntregasApp(queryClient: ReturnType<typeof useQueryClient>) {
  void queryClient.invalidateQueries({ queryKey: entregaKeys.all });
  void queryClient.invalidateQueries({ queryKey: wingraphexKeys.all });
}

export function useCreateReciboMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateReciboPayload) => createRecibo(payload),
    onSuccess: () => refreshEntregasApp(queryClient),
  });
}

export function useDeleteReciboMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => deleteRecibo(id),
    onSuccess: () => refreshEntregasApp(queryClient),
  });
}