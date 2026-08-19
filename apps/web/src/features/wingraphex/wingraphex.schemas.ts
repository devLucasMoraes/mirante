import { z } from "zod";

const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Formato esperado: YYYY-MM-DD");

export const empresaSchema = z.enum(["ambas", "1", "2"]);
export type EmpresaFilter = z.infer<typeof empresaSchema>;

export const queryOpsParamsSchema = z
  .object({
    descricao: z.string().trim().optional(),
    empresa: empresaSchema.optional(),
    clienteId: z.number().int().positive().optional(),
    dataInicio: dateStringSchema.optional(),
    dataFim: dateStringSchema.optional(),
    ordenarPor: z.enum(["emissao", "prevista"]).optional(),
    direcao: z.enum(["asc", "desc"]).optional(),
    pagina: z.number().int().min(1).optional(),
    limite: z.number().int().min(1).max(100).optional(),
  })
  .superRefine((query, ctx) => {
    const hasDescricao = (query.descricao?.trim().length ?? 0) > 0;
    const hasCliente = query.clienteId !== undefined;
    const hasPeriodo =
      query.dataInicio !== undefined || query.dataFim !== undefined;
    if (!hasDescricao && !hasCliente && !hasPeriodo) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["descricao"],
        message:
          "Informe uma descrição ou aplique um filtro de cliente e/ou período.",
      });
    }
  })
  .superRefine((query, ctx) => {
    if (
      query.dataInicio !== undefined &&
      query.dataFim !== undefined &&
      query.dataInicio > query.dataFim
    ) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["dataFim"],
        message: "dataFim deve ser maior ou igual a dataInicio.",
      });
    }
  });

export type QueryOpsParams = z.infer<typeof queryOpsParamsSchema>;

export type QueryOpsImpressaoParams = Omit<
  QueryOpsParams,
  "pagina" | "limite"
>;

export const queryClientesParamsSchema = z.object({
  term: z.string().trim().optional(),
  empresa: empresaSchema.optional(),
});

export type QueryClientesParams = z.infer<typeof queryClientesParamsSchema>;

export const clienteSchema = z.object({
  id: z.coerce.number().int().positive(),
  nome: z.string(),
  fantasia: z.string(),
});

export type WingraphexCliente = z.infer<typeof clienteSchema>;

export const notaFaturamentoSchema = z.object({
  serie: z.string().nullable(),
  numero: z.string(),
  data: z.string().nullable(),
  valor: z.coerce.number(),
  quantidade: z.coerce.number(),
});

export type NotaFaturamento = z.infer<typeof notaFaturamentoSchema>;

export const pcpSetorProgressoSchema = z.object({
  id: z.string(),
  nome: z.string(),
  ordem: z.number().int().nonnegative(),
  processos: z.coerce.number(),
  finalizados: z.coerce.number(),
  finalizado: z.boolean(),
});

export type PcpSetorProgresso = z.infer<typeof pcpSetorProgressoSchema>;

export const wingraphexOpSchema = z.object({
  op: z.number(),
  empId: z.coerce.number().int().min(1).max(2),
  cliente: z.string().nullable(),
  descricao: z.string(),
  qtd_total: z.coerce.number(),
  entregue: z.coerce.number().default(0),
  valor_servico: z.coerce.number(),
  data_emissao: z.string(),
  data_prevista: z.string().nullable(),
  status: z.string(),
  faturamento: z.object({
    valor_faturado: z.coerce.number(),
    quantidade_faturada: z.coerce.number(),
    notas: z.array(notaFaturamentoSchema),
  }),
  financeiro: z.object({
    pago: z.coerce.number(),
    saldo: z.coerce.number(),
  }),
  pcp: z.object({
    processos: z.coerce.number(),
    finalizados: z.coerce.number(),
    setores: z.array(pcpSetorProgressoSchema).default([]),
  }),
});

export type WingraphexOp = z.infer<typeof wingraphexOpSchema>;

export const opsResponseSchema = z.object({
  itens: z.array(wingraphexOpSchema),
  total: z.number().int().nonnegative(),
  pagina: z.number().int().positive(),
  totalPaginas: z.number().int().nonnegative(),
});

export type OpsResponse = z.infer<typeof opsResponseSchema>;
