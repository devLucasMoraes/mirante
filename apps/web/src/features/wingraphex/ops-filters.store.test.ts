import { beforeEach, describe, expect, test } from "vitest";

import {
  OPS_FILTERS_STORAGE_KEY,
  useOpsFiltersStore,
} from "@/features/wingraphex/ops-filters.store";

beforeEach(() => {
  localStorage.clear();
  useOpsFiltersStore.setState({
    searchInput: "",
    descricao: "",
    filters: { dataInicio: "", dataFim: "" },
    pagina: 1,
  });
});

function persistedState() {
  return JSON.parse(
    localStorage.getItem(OPS_FILTERS_STORAGE_KEY) ?? "{}",
  ) as { state: {
    searchInput: string;
    descricao: string;
    filters: {
      clienteId?: number;
      clienteNome?: string;
      dataInicio: string;
      dataFim: string;
    };
    pagina: number;
  } };
}

describe("ops-filters.store", () => {
  test("começa zerado e persiste a busca", () => {
    const state = useOpsFiltersStore.getState();
    expect(state.searchInput).toBe("");
    expect(state.descricao).toBe("");
    expect(state.filters).toEqual({ dataInicio: "", dataFim: "" });
    expect(state.pagina).toBe(1);

    useOpsFiltersStore.getState().setSearchInput("cartaz");
    useOpsFiltersStore.getState().applySearch("cartaz");

    expect(useOpsFiltersStore.getState().descricao).toBe("cartaz");
    expect(persistedState().state.descricao).toBe("cartaz");
  });

  test("applySearch volta para a primeira página", () => {
    useOpsFiltersStore.getState().setPagina(4);

    useOpsFiltersStore.getState().applySearch("folder");

    expect(useOpsFiltersStore.getState().pagina).toBe(1);
    expect(persistedState().state.pagina).toBe(1);
  });

  test("clearSearch limpa termo, busca e página", () => {
    useOpsFiltersStore.getState().setSearchInput("folder");
    useOpsFiltersStore.getState().applySearch("folder");
    useOpsFiltersStore.getState().setPagina(3);

    useOpsFiltersStore.getState().clearSearch();

    const state = useOpsFiltersStore.getState();
    expect(state.searchInput).toBe("");
    expect(state.descricao).toBe("");
    expect(state.pagina).toBe(1);
    const persisted = persistedState().state;
    expect(persisted.searchInput).toBe("");
    expect(persisted.descricao).toBe("");
    expect(persisted.pagina).toBe(1);
  });

  test("applyFilters persiste cliente e período e reseta a página", () => {
    useOpsFiltersStore.getState().setPagina(5);
    useOpsFiltersStore
      .getState()
      .applyFilters({
        clienteId: 7,
        clienteNome: "Gráfica Bella",
        dataInicio: "2026-01-01",
        dataFim: "2026-03-31",
      });

    const state = useOpsFiltersStore.getState();
    expect(state.filters).toMatchObject({
      clienteId: 7,
      clienteNome: "Gráfica Bella",
      dataInicio: "2026-01-01",
      dataFim: "2026-03-31",
    });
    expect(state.pagina).toBe(1);

    const persisted = persistedState().state;
    expect(persisted.filters.clienteId).toBe(7);
    expect(persisted.filters.dataInicio).toBe("2026-01-01");
    expect(persisted.filters.dataFim).toBe("2026-03-31");
  });

  test("setPagina persiste e applySearch mantém o filtro", () => {
    useOpsFiltersStore
      .getState()
      .applyFilters({ dataInicio: "2026-01-01", dataFim: "2026-01-31" });
    useOpsFiltersStore.getState().setPagina(2);

    useOpsFiltersStore.getState().applySearch("caixa");

    const state = useOpsFiltersStore.getState();
    expect(state.pagina).toBe(1);
    expect(state.descricao).toBe("caixa");
    expect(state.filters.dataInicio).toBe("2026-01-01");
  });

  test("removeCliente limpa os campos do cliente mantendo o período", () => {
    useOpsFiltersStore
      .getState()
      .applyFilters({
        clienteId: 7,
        clienteNome: "Gráfica Bella",
        clienteFantasia: "Bella",
        dataInicio: "2026-01-01",
        dataFim: "2026-03-31",
      });

    useOpsFiltersStore.getState().removeCliente();

    const state = useOpsFiltersStore.getState();
    expect(state.filters.clienteId).toBeUndefined();
    expect(state.filters.clienteNome).toBeUndefined();
    expect(state.filters.clienteFantasia).toBeUndefined();
    expect(state.filters.dataInicio).toBe("2026-01-01");
    expect(state.filters.dataFim).toBe("2026-03-31");
  });

  test("removeData limpa o período mantendo o cliente", () => {
    useOpsFiltersStore
      .getState()
      .applyFilters({
        clienteId: 7,
        clienteNome: "Gráfica Bella",
        dataInicio: "2026-01-01",
        dataFim: "2026-03-31",
      });

    useOpsFiltersStore.getState().removeData();

    const state = useOpsFiltersStore.getState();
    expect(state.filters.clienteId).toBe(7);
    expect(state.filters.dataInicio).toBe("");
    expect(state.filters.dataFim).toBe("");
  });

  test("clearFilters esvazia os filtros e reseta a página", () => {
    useOpsFiltersStore.getState().setPagina(3);
    useOpsFiltersStore
      .getState()
      .applyFilters({
        clienteId: 7,
        clienteNome: "Gráfica Bella",
        dataInicio: "2026-01-01",
        dataFim: "2026-03-31",
      });

    useOpsFiltersStore.getState().clearFilters();

    const state = useOpsFiltersStore.getState();
    expect(state.filters.clienteId).toBeUndefined();
    expect(state.filters.dataInicio).toBe("");
    expect(state.filters.dataFim).toBe("");
    expect(state.pagina).toBe(1);
  });
});