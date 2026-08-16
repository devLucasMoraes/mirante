import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeEach, describe, expect, test } from "vitest";

import { ThemeProvider } from "@/features/theme/theme.provider";
import {
  THEME_STORAGE_KEY,
  useThemeStore,
} from "@/features/theme/theme.store";

function ThemeFixture() {
  const theme = useThemeStore((state) => state.theme);
  return (
    <div>
      <span data-testid="tema-atual">{theme}</span>
      <button onClick={() => useThemeStore.getState().setTheme("dark")}>
        ativar escuro
      </button>
      <button onClick={() => useThemeStore.getState().setTheme("light")}>
        ativar claro
      </button>
    </div>
  );
}

beforeEach(() => {
  window.localStorage.clear();
  document.documentElement.classList.remove("dark");
  useThemeStore.setState({ theme: "system" });
});

describe("ThemeProvider", () => {
  test("aplica a classe dark no documentElement ao alternar para escuro", async () => {
    const user = userEvent.setup();
    render(
      <ThemeProvider>
        <ThemeFixture />
      </ThemeProvider>,
    );

    await user.click(screen.getByRole("button", { name: "ativar escuro" }));

    expect(document.documentElement).toHaveClass("dark");
    expect(screen.getByTestId("tema-atual")).toHaveTextContent("dark");

    const persisted = JSON.parse(
      localStorage.getItem(THEME_STORAGE_KEY) ?? "{}",
    ) as { state: { theme: string } };
    expect(persisted.state.theme).toBe("dark");
  });

  test("remove a classe dark ao alternar para claro", async () => {
    useThemeStore.setState({ theme: "dark" });
    document.documentElement.classList.add("dark");
    const user = userEvent.setup();
    render(
      <ThemeProvider>
        <ThemeFixture />
      </ThemeProvider>,
    );

    await user.click(screen.getByRole("button", { name: "ativar claro" }));

    expect(document.documentElement).not.toHaveClass("dark");
    expect(screen.getByTestId("tema-atual")).toHaveTextContent("light");
  });
});