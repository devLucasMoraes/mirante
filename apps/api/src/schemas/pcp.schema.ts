import { z } from "zod";

export const empresaPcpSchema = z.enum(["1", "2"]);
export type EmpresaPcp = z.infer<typeof empresaPcpSchema>;

export const empresaQuerySchema = z.object({
  empresa: empresaPcpSchema.default("1"),
});

export type EmpresaQuery = z.infer<typeof empresaQuerySchema>;

export const objectIdParamSchema = z.object({
  id: z.string().regex(/^[a-f\d]{24}$/i, "Identificador inválido."),
});

export const pcpSetorNomeSchema = z
  .string()
  .trim()
  .min(1, "Informe o nome do setor.")
  .max(60, "O nome do setor deve ter no máximo 60 caracteres.");

export const criarSetorSchema = z.object({
  nome: pcpSetorNomeSchema,
});

export type CriarSetorPayload = z.infer<typeof criarSetorSchema>;

export const renomearSetorSchema = z.object({
  nome: pcpSetorNomeSchema,
});

export type RenomearSetorPayload = z.infer<typeof renomearSetorSchema>;

export const reordenarSetoresSchema = z.object({
  ids: z
    .array(z.string().regex(/^[a-f\d]{24}$/i, "Identificador inválido."))
    .min(2, "Informe ao menos dois setores."),
});

export type ReordenarSetoresPayload = z.infer<typeof reordenarSetoresSchema>;

export const vincularSetorSchema = z.object({
  setorId: z
    .string()
    .regex(/^[a-f\d]{24}$/i, "Identificador inválido.")
    .nullable(),
});

export type VincularSetorPayload = z.infer<typeof vincularSetorSchema>;

export const equipamentoCodigoParamSchema = z.object({
  codigo: z.coerce.number().int().positive(),
});

export const pcpSetorResponseSchema = z.object({
  id: z.string(),
  nome: z.string(),
  ordem: z.number().int().nonnegative(),
});

export type PcpSetorResponse = z.infer<typeof pcpSetorResponseSchema>;

export const equipamentoComSetorSchema = z.object({
  codigo: z.number().int().positive(),
  nome: z.string(),
  setorId: z.string().nullable(),
});

export type EquipamentoComSetor = z.infer<typeof equipamentoComSetorSchema>;