import type { EmpresaPcp } from "./pcp.schemas";

export const pcpKeys = {
  all: ["pcp"] as const,
  setores: () => [...pcpKeys.all, "setores"] as const,
  equipamentos: (empresa: EmpresaPcp) =>
    [...pcpKeys.all, "equipamentos", empresa] as const,
};