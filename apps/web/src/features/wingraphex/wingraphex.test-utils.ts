import type { z } from "zod";

import type { WingraphexOp } from "./wingraphex.schemas";
import { wingraphexOpSchema } from "./wingraphex.schemas";

type OpInput = z.input<typeof wingraphexOpSchema>;

const OP_BASE: OpInput = {
  op: 1,
  empId: 1,
  cliente: "Cliente Teste",
  descricao: "Cartão de visita",
  qtd_total: 500,
  entregue: 0,
  valor_servico: 150,
  data_emissao: "2026-08-01",
  data_prevista: "2026-08-10",
  status: "TSF_AFATURAR",
  faturamento: { valor_faturado: 0, quantidade_faturada: 0, notas: [] },
  financeiro: { pago: 0, saldo: 0 },
  pcp: { processos: 0, finalizados: 0, setores: [] },
};

export function opFactory(overrides: Partial<OpInput> = {}): WingraphexOp {
  return wingraphexOpSchema.parse({ ...OP_BASE, ...overrides });
}