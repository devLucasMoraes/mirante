import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, test } from "vitest";

import { TooltipProvider } from "@repo/ui/components/tooltip";

import { PcpSteps } from "./pcp-steps";
import type { PcpSetorProgresso } from "./wingraphex.schemas";

const setores: PcpSetorProgresso[] = [
  {
    id: "setor-1",
    nome: "Impressão",
    ordem: 0,
    processos: 2,
    finalizados: 2,
    finalizado: true,
  },
  {
    id: "setor-2",
    nome: "Acabamento",
    ordem: 1,
    processos: 3,
    finalizados: 1,
    finalizado: false,
  },
];

function renderSteps(props: { setores: PcpSetorProgresso[] }) {
  return render(
    <TooltipProvider delayDuration={0}>
      <PcpSteps {...props} />
    </TooltipProvider>,
  );
}

describe("PcpSteps", () => {
  test("marca passo finalizado com cor de sucesso", () => {
    renderSteps({ setores });

    const passo = screen.getByLabelText("Impressão: 2/2 finalizados");
    expect(passo).toHaveClass("bg-emerald-500/15");
    expect(passo).toHaveClass("text-emerald-700");
    expect(passo).toHaveTextContent("Impressão");
  });

  test("marca passo pendente com cor neutra", () => {
    renderSteps({ setores });

    const passo = screen.getByLabelText("Acabamento: 1/3 finalizados");
    expect(passo).toHaveClass("bg-muted");
    expect(passo).toHaveClass("text-muted-foreground");
  });

  test("mostra contagem x/y no tooltip ao passar o mouse", async () => {
    const user = userEvent.setup();
    renderSteps({ setores });

    await user.hover(screen.getByLabelText("Acabamento: 1/3 finalizados"));
    expect(
      await screen.findByText("Acabamento: 1/3 finalizados"),
    ).toBeInTheDocument();
  });

  test("renderiza travessão quando não há setores", () => {
    renderSteps({ setores: [] });

    expect(screen.getByText("—")).toBeInTheDocument();
  });
});
