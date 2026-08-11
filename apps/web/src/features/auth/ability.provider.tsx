import { type ReactNode,useMemo } from "react";

import { AbilityProvider } from "@casl/react";

import {
  createAppAbility,
  defineAbilityFor,
} from "@repo/authorization";

import { useAuthStore } from "@/features/auth/auth.store";

const emptyAbility = createAppAbility([]);

export function AppAbilityProvider({ children }: { children: ReactNode }) {
  const user = useAuthStore((state) => state.user);
  const ability = useMemo(
    () => (user ? defineAbilityFor(user) : emptyAbility),
    [user],
  );

  return <AbilityProvider value={ability}>{children}</AbilityProvider>;
}