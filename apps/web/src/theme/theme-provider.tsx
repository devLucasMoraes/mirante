import { useEffect } from "react";
import type { ReactNode } from "react";
import { useThemeStore } from "./theme-store";
import type { Theme } from "./theme-store";

const DARK_MEDIA_QUERY = "(prefers-color-scheme: dark)";

export function getResolvedTheme(theme: Theme): "light" | "dark" {
  if (theme !== "system") {
    return theme;
  }
  return window.matchMedia(DARK_MEDIA_QUERY).matches ? "dark" : "light";
}

export function applyThemeClass(theme: Theme): void {
  document.documentElement.classList.toggle("dark", getResolvedTheme(theme) === "dark");
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const theme = useThemeStore((state) => state.theme);

  useEffect(() => {
    applyThemeClass(theme);
  }, [theme]);

  useEffect(() => {
    if (theme !== "system") {
      return;
    }
    const mediaQuery = window.matchMedia(DARK_MEDIA_QUERY);
    const handleChange = () => applyThemeClass("system");
    mediaQuery.addEventListener("change", handleChange);
    return () => mediaQuery.removeEventListener("change", handleChange);
  }, [theme]);

  return <>{children}</>;
}