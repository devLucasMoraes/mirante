import type { ReactNode } from "react";

import { QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";

import { AppAbilityProvider } from "@/features/auth/ability.provider";
import { BrandingProvider } from "@/features/company-settings/company-settings.provider";
import { ThemeProvider } from "@/features/theme/theme.provider";

import { queryClient } from "./query-client";

export function AppProviders({ children }: { children: ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <BrandingProvider>
          <AppAbilityProvider>{children}</AppAbilityProvider>
        </BrandingProvider>
      </ThemeProvider>
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
