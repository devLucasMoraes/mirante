import type { ReactNode } from "react";
import { useEffect } from "react";

import { useCompanySettingsQuery } from "./company-settings.queries";
import { useCompanySettingsStore } from "./company-settings.store";

const FAVICON_SELECTOR = 'link[rel="icon"]';
const META_DESCRIPTION_SELECTOR = 'meta[name="description"]';
const DEFAULT_FAVICON = "/favicon.svg";
const PAGE_TITLE_SUFFIX = " — Consultas rápidas e inteligentes";

function applyDocumentBranding(companyName: string, logo: string | null): void {
  document.title = `${companyName}${PAGE_TITLE_SUFFIX}`;

  const favicon = document.head.querySelector<HTMLLinkElement>(
    FAVICON_SELECTOR,
  );
  if (favicon !== null) {
    favicon.href = logo ?? DEFAULT_FAVICON;
  }

  const description = document.head.querySelector<HTMLMetaElement>(
    META_DESCRIPTION_SELECTOR,
  );
  if (description !== null) {
    description.content = `${companyName} — consultas rápidas e inteligentes sobre o ERP da gráfica, com uma interface moderna.`;
  }
}

export function BrandingProvider({ children }: { children?: ReactNode }) {
  const { data } = useCompanySettingsQuery();
  const setBranding = useCompanySettingsStore((state) => state.setBranding);

  useEffect(() => {
    if (data === undefined) {
      return;
    }
    setBranding({ companyName: data.nome, logo: data.logo });
    applyDocumentBranding(data.nome, data.logo);
  }, [data, setBranding]);

  return <>{children}</>;
}