import type { ReactNode } from "react";

import { AppAbilityProvider } from "@/features/auth/ability.provider";
import { ThemeProvider } from "@/features/theme/theme.provider";

export function AppProviders({ children }: { children: ReactNode }) {
  return (
    <ThemeProvider>
      <AppAbilityProvider>{children}</AppAbilityProvider>
    </ThemeProvider>
  );
}
