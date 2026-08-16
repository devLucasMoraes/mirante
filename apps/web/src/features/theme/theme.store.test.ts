import { beforeEach, describe, expect, test } from "vitest";

import {
  applyThemeClass,
  getResolvedTheme,
} from "@/features/theme/theme.provider";
import { useThemeStore } from "@/features/theme/theme.store";

beforeEach(() => {
  document.documentElement.classList.remove("dark");
  useThemeStore.setState({ theme: "system" });
});

describe("theme.store", () => {
  test("começa em system e persiste a mudança", () => {
    expect(useThemeStore.getState().theme).toBe("system");

    useThemeStore.getState().setTheme("dark");

    expect(useThemeStore.getState().theme).toBe("dark");
    const persisted = JSON.parse(
      localStorage.getItem("mirante-theme") ?? "{}",
    ) as { state: { theme: string } };
    expect(persisted.state.theme).toBe("dark");
  });
});

describe("applyThemeClass", () => {
  test("aplica e remove a classe dark conforme o tema", () => {
    applyThemeClass("dark");
    expect(document.documentElement).toHaveClass("dark");

    applyThemeClass("light");
    expect(document.documentElement).not.toHaveClass("dark");
  });

  test("resolves temas explícitos, sem depender da media query", () => {
    expect(getResolvedTheme("light")).toBe("light");
    expect(getResolvedTheme("dark")).toBe("dark");
    expect(getResolvedTheme("system")).toBe("light");
  });
});