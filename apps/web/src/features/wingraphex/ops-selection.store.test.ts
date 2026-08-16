import { beforeEach, describe, expect, test } from "vitest";

import type { OpSelectionItem } from "@/features/wingraphex/ops-selection.store";
import {
  OPS_SELECTION_STORAGE_KEY,
  useOpsSelectionStore,
} from "@/features/wingraphex/ops-selection.store";

function item(op: number, overrides: Partial<OpSelectionItem> = {}): OpSelectionItem {
  return {
    op,
    cliente: "Cliente X",
    descricao: "Cartaz 3mm",
    qtd_total: 100,
    entregue: 40,
    ...overrides,
  };
}

beforeEach(() => {
  localStorage.clear();
  useOpsSelectionStore.setState({ selecionadas: [] });
});

function persistedState() {
  return JSON.parse(
    localStorage.getItem(OPS_SELECTION_STORAGE_KEY) ?? "{}",
  ) as { state: { selecionadas: OpSelectionItem[] } };
}

describe("ops-selection.store", () => {
  test("começa vazio e persiste ao selecionar uma OP", () => {
    expect(useOpsSelectionStore.getState().selecionadas).toEqual([]);

    useOpsSelectionStore.getState().toggle(item(101));

    expect(useOpsSelectionStore.getState().selecionadas).toEqual([item(101)]);
    expect(persistedState().state.selecionadas).toEqual([item(101)]);
  });

  test("toggle remove uma OP já selecionada", () => {
    useOpsSelectionStore.getState().toggle(item(101));
    useOpsSelectionStore.getState().toggle(item(102));

    useOpsSelectionStore.getState().toggle(item(101));

    expect(useOpsSelectionStore.getState().selecionadas).toEqual([item(102)]);
    expect(persistedState().state.selecionadas).toEqual([item(102)]);
  });

  test("mantém múltiplas OPs selecionadas em ordem de seleção", () => {
    useOpsSelectionStore.getState().toggle(item(101));
    useOpsSelectionStore.getState().toggle(item(102));
    useOpsSelectionStore.getState().toggle(item(103));

    expect(
      useOpsSelectionStore.getState().selecionadas.map((s) => s.op),
    ).toEqual([101, 102, 103]);
  });

  test("clear esvazia a seleção e persiste", () => {
    useOpsSelectionStore.getState().toggle(item(101));
    useOpsSelectionStore.getState().toggle(item(102));

    useOpsSelectionStore.getState().clear();

    expect(useOpsSelectionStore.getState().selecionadas).toEqual([]);
    expect(persistedState().state.selecionadas).toEqual([]);
  });
});