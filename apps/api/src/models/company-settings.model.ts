import type { HydratedDocument } from "mongoose";
import { model, Schema } from "mongoose";

export const DEFAULT_COMPANY_NAME = "Mirante";

export interface CompanySettingsFields {
  _id: string;
  nome: string;
  logo: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface CompanySettingsDTO {
  id: string;
  nome: string;
  logo: string | null;
}

export type CompanySettingsDoc = HydratedDocument<CompanySettingsFields>;

const companySettingsSchema = new Schema<CompanySettingsFields>(
  {
    _id: { type: String, required: true },
    nome: { type: String, required: true, trim: true },
    logo: { type: String, default: null },
  },
  { timestamps: true },
);

export const CompanySettingsModel = model<CompanySettingsFields>(
  "CompanySettings",
  companySettingsSchema,
);

export function toCompanySettingsDTO(
  doc: CompanySettingsFields,
): CompanySettingsDTO {
  return {
    id: doc._id,
    nome: doc.nome,
    logo: doc.logo,
  };
}