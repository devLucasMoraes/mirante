import {
  queryOptions,
  useMutation,
  useQuery,
  useQueryClient,
} from "@tanstack/react-query";

import {
  criarSetor,
  excluirSetor,
  listarEquipamentos,
  listarSetores,
  renomearSetor,
  reordenarSetores,
  vincularEquipamento,
} from "@/api/pcp.api";

import { pcpKeys } from "./pcp.query-keys";

export const setoresQueryOptions = queryOptions({
  queryKey: pcpKeys.setores(),
  queryFn: listarSetores,
});

export function useSetoresQuery() {
  return useQuery(setoresQueryOptions);
}

export const equipamentosQueryOptions = queryOptions({
  queryKey: pcpKeys.equipamentos(),
  queryFn: listarEquipamentos,
});

export function useEquipamentosQuery() {
  return useQuery(equipamentosQueryOptions);
}

function refreshPcp(queryClient: ReturnType<typeof useQueryClient>) {
  void queryClient.invalidateQueries({ queryKey: pcpKeys.all });
}

export function useCriarSetorMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (nome: string) => criarSetor(nome),
    onSuccess: () => refreshPcp(queryClient),
  });
}

export function useRenomearSetorMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, nome }: { id: string; nome: string }) =>
      renomearSetor(id, nome),
    onSuccess: () => refreshPcp(queryClient),
  });
}

export function useReordenarSetoresMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (ids: string[]) => reordenarSetores(ids),
    onSuccess: () => refreshPcp(queryClient),
  });
}

export function useExcluirSetorMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => excluirSetor(id),
    onSuccess: () => refreshPcp(queryClient),
  });
}

export function useVincularEquipamentoMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ codigo, setorId }: { codigo: number; setorId: string | null }) =>
      vincularEquipamento(codigo, setorId),
    onSuccess: () => refreshPcp(queryClient),
  });
}