import type { ReactNode } from "react";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { render, waitFor } from "@testing-library/react";
import { http, HttpResponse } from "msw";
import { beforeAll, describe, expect, test } from "vitest";

import { server } from "@/test/server";

import { BrandingProvider } from "./company-settings.provider";
import { useCompanySettingsStore } from "./company-settings.store";

const TITLE_SUFFIX = " — Consultas rápidas e inteligentes";
const LOGO = "data:image/png;base64,aGVsbG8=";

let iconLink: HTMLLinkElement;

beforeAll(() => {
  iconLink = Object.assign(document.createElement("link"), { rel: "icon" });
  document.head.appendChild(iconLink);
});

function providerWith(queryClient: QueryClient) {
  return function Providers({ children }: { children?: ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    );
  };
}

function renderProvider() {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });
  render(<BrandingProvider />, { wrapper: providerWith(queryClient) });
}

describe("BrandingProvider", () => {
  test("aplica o título e o favicon padrão", async () => {
    renderProvider();

    await waitFor(() =>
      expect(document.title).toBe(`Mirante${TITLE_SUFFIX}`),
    );
    expect(useCompanySettingsStore.getState().branding).toEqual({
      companyName: "Mirante",
      logo: null,
    });
    expect(iconLink).toHaveAttribute("href", "/favicon.svg");
  });

  test("aplica o branding personalizado no título, favicon e store", async () => {
    server.use(
      http.get("*/api/settings", () =>
        HttpResponse.json({
          id: "default",
          nome: "Gráfica Horizonte",
          logo: LOGO,
        }),
      ),
    );

    renderProvider();

    await waitFor(() =>
      expect(document.title).toBe(`Gráfica Horizonte${TITLE_SUFFIX}`),
    );
    expect(useCompanySettingsStore.getState().branding).toEqual({
      companyName: "Gráfica Horizonte",
      logo: LOGO,
    });
    expect(iconLink).toHaveAttribute("href", LOGO);
  });
});