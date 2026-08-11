import { Toaster as Sonner } from "sonner";

import { getResolvedTheme } from "@/features/theme/theme.provider";
import { useThemeStore } from "@/features/theme/theme.store";

export function Toaster() {
  const theme = useThemeStore((state) => state.theme);

  return (
    <Sonner
      theme={getResolvedTheme(theme)}
      position="top-right"
      richColors
      toastOptions={{
        classNames: {
          toast:
            "!border-border !bg-popover !text-popover-foreground !shadow-lg",
        },
      }}
    />
  );
}