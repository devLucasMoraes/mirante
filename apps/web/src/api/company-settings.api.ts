import type {
  CompanySettings,
  UpdateCompanySettingsPayload,
} from "@/features/company-settings/company-settings.schemas";
import {
  companySettingsSchema,
  updateCompanySettingsSchema,
} from "@/features/company-settings/company-settings.schemas";

import { api } from "./client";

export async function getCompanySettings(): Promise<CompanySettings> {
  const { data } = await api.get<unknown>("/settings");
  return companySettingsSchema.parse(data);
}

export async function updateCompanySettings(
  payload: UpdateCompanySettingsPayload,
): Promise<CompanySettings> {
  const parsed = updateCompanySettingsSchema.parse(payload);
  const { data } = await api.patch<unknown>("/settings", parsed);
  return companySettingsSchema.parse(data);
}