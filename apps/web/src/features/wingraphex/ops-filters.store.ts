import { create } from "zustand";
import { createJSONStorage, persist } from "zustand/middleware";

import {
  EMPTY_FILTERS,
  type OpFilters,
} from "@/features/wingraphex/ops-filters-sheet";

export const OPS_FILTERS_STORAGE_KEY = "mirante-ops-filters";

type OpsFiltersState = {
  searchInput: string;
  descricao: string;
  filters: OpFilters;
  pagina: number;
  irParaUltimaPagina: boolean;
  setSearchInput: (value: string) => void;
  applySearch: (term: string) => void;
  clearSearch: () => void;
  applyFilters: (filters: OpFilters) => void;
  removeCliente: () => void;
  removeEmpresa: () => void;
  removeData: () => void;
  clearFilters: () => void;
  setPagina: (page: number) => void;
  setIrParaUltimaPagina: (value: boolean) => void;
};

export const useOpsFiltersStore = create<OpsFiltersState>()(
  persist(
    (set) => ({
      searchInput: "",
      descricao: "",
      filters: EMPTY_FILTERS,
      pagina: 1,
      irParaUltimaPagina: false,

      setSearchInput: (searchInput) => set({ searchInput }),

      applySearch: (descricao) =>
        set((state) => ({
          descricao,
          pagina: 1,
          irParaUltimaPagina: state.filters.direcao === "asc",
        })),

      clearSearch: () =>
        set((state) => ({
          searchInput: "",
          descricao: "",
          pagina: 1,
          irParaUltimaPagina: state.filters.direcao === "asc",
        })),

      applyFilters: (filters) =>
        set({
          filters,
          pagina: 1,
          irParaUltimaPagina: filters.direcao === "asc",
        }),

      removeCliente: () =>
        set((state) => ({
          filters: {
            ...state.filters,
            clienteId: undefined,
            clienteNome: undefined,
            clienteFantasia: undefined,
          },
          pagina: 1,
          irParaUltimaPagina: state.filters.direcao === "asc",
        })),

      removeEmpresa: () =>
        set((state) => ({
          filters: { ...state.filters, empresa: "ambas" },
          pagina: 1,
          irParaUltimaPagina: state.filters.direcao === "asc",
        })),

      removeData: () =>
        set((state) => ({
          filters: {
            ...state.filters,
            dataInicio: "",
            dataFim: "",
          },
          pagina: 1,
          irParaUltimaPagina: state.filters.direcao === "asc",
        })),

      clearFilters: () =>
        set({
          filters: EMPTY_FILTERS,
          pagina: 1,
          irParaUltimaPagina: EMPTY_FILTERS.direcao === "asc",
        }),

      setPagina: (pagina) => set({ pagina }),

      setIrParaUltimaPagina: (irParaUltimaPagina) => set({ irParaUltimaPagina }),
    }),
    {
      name: OPS_FILTERS_STORAGE_KEY,
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        searchInput: state.searchInput,
        descricao: state.descricao,
        filters: state.filters,
        pagina: state.pagina,
      }),
      merge: (persisted, current) => {
        const state = persisted as Partial<OpsFiltersState> | undefined;
        return {
          ...current,
          ...state,
          filters: { ...EMPTY_FILTERS, ...(state?.filters ?? {}) },
        };
      },
    },
  ),
);