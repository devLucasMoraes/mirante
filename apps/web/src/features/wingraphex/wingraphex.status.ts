import type { WingraphexOp } from "./wingraphex.schemas";

export type FaturamentoStatus =
  | "A FATURAR"
  | "FATURADO_PARCIALMENTE"
  | "FATURADA";

export function getFaturamentoStatus(op: WingraphexOp): {
  label: string;
  status: FaturamentoStatus;
} {
  const valorFaturado = op.faturamento.valor_faturado;

  if (valorFaturado >= op.valor_servico - 0.01) {
    return { label: "Faturada", status: "FATURADA" };
  }

  if (valorFaturado > 0) {
    return { label: "Faturado parcialmente", status: "FATURADO_PARCIALMENTE" };
  }

  if (op.status === "TSF_FATURADA") {
    return { label: "Faturada", status: "FATURADA" };
  }

  return { label: "A faturar", status: "A FATURAR" };
}