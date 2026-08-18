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
  setSearchInput: (value: string) => void;
  applySearch: (term: string) => void;
  clearSearch: () => void;
  applyFilters: (filters: OpFilters) => void;
  removeCliente: () => void;
  removeEmpresa: () => void;
  removeData: () => void;
  clearFilters: () => void;
  setPagina: (page: number) => void;
};

export const useOpsFiltersStore = create<OpsFiltersState>()(
  persist(
    (set) => ({
      searchInput: "",
      descricao: "",
      filters: EMPTY_FILTERS,
      pagina: 1,

      setSearchInput: (searchInput) => set({ searchInput }),

      applySearch: (descricao) => set({ descricao, pagina: 1 }),

      clearSearch: () => set({ searchInput: "", descricao: "", pagina: 1 }),

      applyFilters: (filters) => set({ filters, pagina: 1 }),

      removeCliente: () =>
        set((state) => ({
          filters: {
            ...state.filters,
            clienteId: undefined,
            clienteNome: undefined,
            clienteFantasia: undefined,
          },
          pagina: 1,
        })),

      removeEmpresa: () =>
        set((state) => ({
          filters: { ...state.filters, empresa: "ambas" },
          pagina: 1,
        })),

      removeData: () =>
        set((state) => ({
          filters: {
            ...state.filters,
            dataInicio: "",
            dataFim: "",
          },
          pagina: 1,
        })),

      clearFilters: () => set({ filters: EMPTY_FILTERS, pagina: 1 }),

      setPagina: (pagina) => set({ pagina }),
    }),
    {
      name: OPS_FILTERS_STORAGE_KEY,
      storage: createJSONStorage(() => localStorage),
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