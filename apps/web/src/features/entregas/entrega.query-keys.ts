export const entregaKeys = {
  all: ["entregas"] as const,
  op: (opId: number) => [...entregaKeys.all, "op", opId] as const,
};