import { z } from "zod";

import type {
  CriarSetorPayload,
  EmpresaPcp,
  EquipamentoComSetor,
  ListarEquipamentosParams,
  PcpSetor,
  RenomearSetorPayload,
  VincularEquipamentoParams,
} from "@/features/pcp/pcp.schemas";
import {
  criarSetorPayloadSchema,
  equipamentoComSetorSchema,
  listarEquipamentosParamsSchema,
  pcpSetorSchema,
  renomearSetorPayloadSchema,
  vincularEquipamentoParamsSchema,
} from "@/features/pcp/pcp.schemas";

import { api } from "./client";

function parseArray<T>(data: unknown, schema: z.ZodType<T>): T[] {
  if (!Array.isArray(data)) {
    throw new Error("Resposta inválida da API");
  }
  return data.map((item) => schema.parse(item));
}

export async function listarSetores(): Promise<PcpSetor[]> {
  const { data } = await api.get<unknown>("/pcp/setores");
  return parseArray(data, pcpSetorSchema);
}

export async function criarSetor(nome: string): Promise<PcpSetor> {
  const payload = criarSetorPayloadSchema.parse(
    { nome } satisfies CriarSetorPayload,
  );
  const { data } = await api.post<unknown>("/pcp/setores", payload);
  return pcpSetorSchema.parse(data);
}

export async function renomearSetor(id: string, nome: string): Promise<PcpSetor> {
  const payload = renomearSetorPayloadSchema.parse(
    { nome } satisfies RenomearSetorPayload,
  );
  const { data } = await api.patch<unknown>(`/pcp/setores/${id}`, payload);
  return pcpSetorSchema.parse(data);
}

export async function reordenarSetores(ids: string[]): Promise<void> {
  await api.patch("/pcp/setores/ordem", { ids });
}

export async function excluirSetor(id: string): Promise<void> {
  await api.delete(`/pcp/setores/${id}`);
}

export async function listarEquipamentos(
  empresa: EmpresaPcp,
): Promise<EquipamentoComSetor[]> {
  const params = listarEquipamentosParamsSchema.parse(
    { empresa } satisfies ListarEquipamentosParams,
  );
  const { data } = await api.get<unknown>("/pcp/equipamentos", { params });
  return parseArray(data, equipamentoComSetorSchema);
}

export async function vincularEquipamento(
  empresa: EmpresaPcp,
  codigo: number,
  setorId: string | null,
): Promise<void> {
  const params = vincularEquipamentoParamsSchema.parse(
    { empresa } satisfies VincularEquipamentoParams,
  );
  await api.patch(`/pcp/equipamentos/${codigo}/setor`, { setorId }, { params });
}