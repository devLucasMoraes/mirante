import { describe, expect, test } from "vitest";

import {
  companyLogoSchema,
  companyNameSchema,
  LOGO_MAX_ENCODED_LENGTH,
  updateCompanySettingsSchema,
} from "./company-settings.schemas";

const LOGO_PNG =
  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=";

describe("companyNameSchema", () => {
  test("aceita nomes válidos e faz trim", () => {
    expect(companyNameSchema.parse("  Gráfica Horizonte  ")).toBe(
      "Gráfica Horizonte",
    );
  });

  test("rejeita nome vazio", () => {
    expect(() => companyNameSchema.parse("   ")).toThrow();
  });
});

describe("companyLogoSchema", () => {
  test("aceita data URL de PNG", () => {
    expect(companyLogoSchema.parse(LOGO_PNG)).toBe(LOGO_PNG);
  });

  test("aceita data URL de SVG", () => {
    const svg =
      "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjwvc3ZnPg==";
    expect(companyLogoSchema.parse(svg)).toBe(svg);
  });

  test("rejeita mime diferente de png/jpeg/webp/svg", () => {
    expect(() =>
      companyLogoSchema.parse("data:image/gif;base64,R0lGODlhAQABAAAAACw="),
    ).toThrow();
  });

  test("rejeita imagem acima do limite", () => {
    const oversized = `data:image/png;base64,${"A".repeat(
      LOGO_MAX_ENCODED_LENGTH,
    )}`;
    expect(() => companyLogoSchema.parse(oversized)).toThrow();
  });
});

describe("updateCompanySettingsSchema", () => {
  test("aceita atualizar somente o nome", () => {
    expect(updateCompanySettingsSchema.parse({ nome: "Nova" })).toEqual({
      nome: "Nova",
    });
  });

  test("aceita limpar a logo com null", () => {
    expect(updateCompanySettingsSchema.parse({ logo: null })).toEqual({
      logo: null,
    });
  });

  test("rejeita payload vazio", () => {
    expect(() => updateCompanySettingsSchema.parse({})).toThrow();
  });
});