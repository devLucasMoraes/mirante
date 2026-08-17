export const pcpKeys = {
  all: ["pcp"] as const,
  setores: () => [...pcpKeys.all, "setores"] as const,
  equipamentos: () => [...pcpKeys.all, "equipamentos"] as const,
};