import { create } from "zustand";
import { createJSONStorage, persist } from "zustand/middleware";

export const OPS_SELECTION_STORAGE_KEY = "mirante-ops-selecionadas";

export type OpSelectionItem = {
  op: number;
  cliente: string | null;
  descricao: string;
  qtd_total: number;
  entregue: number;
};

type OpsSelectionState = {
  selecionadas: OpSelectionItem[];
  toggle: (item: OpSelectionItem) => void;
  clear: () => void;
};

export const useOpsSelectionStore = create<OpsSelectionState>()(
  persist(
    (set) => ({
      selecionadas: [],

      toggle: (item) =>
        set((state) => {
          const existe = state.selecionadas.some((s) => s.op === item.op);
          const selecionadas = existe
            ? state.selecionadas.filter((s) => s.op !== item.op)
            : [...state.selecionadas, item];
          return { selecionadas };
        }),

      clear: () => set({ selecionadas: [] }),
    }),
    {
      name: OPS_SELECTION_STORAGE_KEY,
      storage: createJSONStorage(() => localStorage),
    },
  ),
);