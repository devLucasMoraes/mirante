import { z } from "zod";

export const empresaPcpSchema = z.enum(["1", "2"]);
export type EmpresaPcp = z.infer<typeof empresaPcpSchema>;

export const listarEquipamentosParamsSchema = z.object({
  empresa: empresaPcpSchema,
});

export type ListarEquipamentosParams = z.infer<
  typeof listarEquipamentosParamsSchema
>;

export const vincularEquipamentoParamsSchema = z.object({
  empresa: empresaPcpSchema,
});

export type VincularEquipamentoParams = z.infer<
  typeof vincularEquipamentoParamsSchema
>;

export const pcpSetorSchema = z.object({
  id: z.string(),
  nome: z.string(),
  ordem: z.number().int().nonnegative(),
});

export type PcpSetor = z.infer<typeof pcpSetorSchema>;

export const equipamentoComSetorSchema = z.object({
  codigo: z.number().int().positive(),
  nome: z.string(),
  setorId: z.string().nullable(),
});

export type EquipamentoComSetor = z.infer<typeof equipamentoComSetorSchema>;

const nomeSetorSchema = z
  .string()
  .trim()
  .min(1, "Informe o nome do setor")
  .max(60, "O nome do setor deve ter no máximo 60 caracteres");

export const criarSetorPayloadSchema = z.object({
  nome: nomeSetorSchema,
});

export type CriarSetorPayload = z.infer<typeof criarSetorPayloadSchema>;

export const renomearSetorPayloadSchema = z.object({
  nome: nomeSetorSchema,
});

export type RenomearSetorPayload = z.infer<typeof renomearSetorPayloadSchema>;