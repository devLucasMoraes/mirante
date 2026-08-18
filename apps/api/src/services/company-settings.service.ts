import {
  type CompanySettingsDTO,
  CompanySettingsModel,
  DEFAULT_COMPANY_NAME,
  toCompanySettingsDTO,
} from "../models/index.ts";
import type { UpdateCompanySettingsPayload } from "../schemas/index.ts";

const SETTINGS_ID = "default";

export async function getCompanySettings(): Promise<CompanySettingsDTO> {
  const doc = await CompanySettingsModel.findOneAndUpdate(
    { _id: SETTINGS_ID },
    { $setOnInsert: { nome: DEFAULT_COMPANY_NAME, logo: null } },
    { returnDocument: "after", upsert: true, setDefaultsOnInsert: true },
  )
    .lean()
    .exec();
  return toCompanySettingsDTO(doc);
}

export async function updateCompanySettings(
  payload: UpdateCompanySettingsPayload,
): Promise<CompanySettingsDTO> {
  const updates: Partial<Pick<CompanySettingsDTO, "nome" | "logo">> = {};
  const setOnInsert: { nome?: string } = {};
  if (payload.nome !== undefined) {
    updates.nome = payload.nome;
  } else {
    setOnInsert.nome = DEFAULT_COMPANY_NAME;
  }
  if (payload.logo !== undefined) {
    updates.logo = payload.logo;
  }

  const doc = await CompanySettingsModel.findOneAndUpdate(
    { _id: SETTINGS_ID },
    { $set: updates, $setOnInsert: setOnInsert },
    { returnDocument: "after", upsert: true, setDefaultsOnInsert: true },
  )
    .lean()
    .exec();
  return toCompanySettingsDTO(doc);
}