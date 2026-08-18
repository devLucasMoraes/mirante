import { describe, expect, test } from "vitest";

import {
  DEFAULT_COMPANY_NAME,
  useCompanySettingsStore,
} from "./company-settings.store";

describe("useCompanySettingsStore", () => {
  test("começa com branding padrão (Mirante)", () => {
    expect(useCompanySettingsStore.getState().branding).toEqual({
      companyName: DEFAULT_COMPANY_NAME,
      logo: null,
    });
  });

  test("setBranding atualiza o branding", () => {
    useCompanySettingsStore.getState().setBranding({
      companyName: "Gráfica Horizonte",
      logo: "data:image/png;base64,Zm9v",
    });

    expect(useCompanySettingsStore.getState().branding).toEqual({
      companyName: "Gráfica Horizonte",
      logo: "data:image/png;base64,Zm9v",
    });
  });
});