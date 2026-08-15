import type {
  CreateReciboPayload,
  ReciboEntrega,
} from "@/features/entregas/entrega.schemas";
import {
  createReciboPayloadSchema,
  reciboEntregaSchema,
} from "@/features/entregas/entrega.schemas";

import { api } from "./client";

export async function createRecibo(payload: CreateReciboPayload): Promise<ReciboEntrega> {
  const parsed = createReciboPayloadSchema.parse(payload);
  const { data } = await api.post<unknown>("/entregas", parsed);
  return reciboEntregaSchema.parse(data);
}

export async function reciboPorOp(opId: number): Promise<ReciboEntrega[]> {
  const { data } = await api.get<unknown>(`/entregas/op/${opId}`);
  if (!Array.isArray(data)) {
    throw new Error("Resposta inválida da API");
  }
  return data.map((item) => reciboEntregaSchema.parse(item));
}

export async function deleteRecibo(id: string): Promise<void> {
  await api.delete(`/entregas/${id}`);
}