import { z } from "zod";

export const LOGO_MAX_BYTES = 1_000_000;
export const LOGO_MAX_ENCODED_LENGTH = Math.ceil((LOGO_MAX_BYTES * 4) / 3) + 8;

export const companyNameSchema = z
  .string()
  .trim()
  .min(1, "Informe o nome da empresa.")
  .max(80, "O nome da empresa deve ter no máximo 80 caracteres.");

export const companyLogoSchema = z
  .string()
  .regex(
    /^data:image\/(?:png|jpeg|webp|svg\+xml);base64,/,
    "A logo deve ser uma imagem PNG, JPEG, WebP ou SVG.",
  )
  .max(LOGO_MAX_ENCODED_LENGTH, "A imagem deve ter no máximo 1 MB.");

export const companySettingsResponseSchema = z.object({
  id: z.string(),
  nome: z.string(),
  logo: z.string().nullable(),
});

export type CompanySettingsResponse = z.infer<
  typeof companySettingsResponseSchema
>;

export const updateCompanySettingsSchema = z
  .object({
    nome: companyNameSchema.optional(),
    logo: companyLogoSchema.nullable().optional(),
  })
  .refine(
    (payload) => payload.nome !== undefined || payload.logo !== undefined,
    { message: "Informe ao menos um campo para atualizar." },
  );

export type UpdateCompanySettingsPayload = z.infer<
  typeof updateCompanySettingsSchema
>;