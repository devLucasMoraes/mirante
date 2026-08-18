import { create } from "zustand";

export const DEFAULT_COMPANY_NAME = "Mirante";

export type Branding = {
  companyName: string;
  logo: string | null;
};

type CompanySettingsState = {
  branding: Branding;
  setBranding: (branding: Branding) => void;
};

export const useCompanySettingsStore = create<CompanySettingsState>()((set) => ({
  branding: { companyName: DEFAULT_COMPANY_NAME, logo: null },
  setBranding: (branding) => set({ branding }),
}));