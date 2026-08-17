import { z } from "zod";

const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Formato esperado: YYYY-MM-DD");

export const queryOpsQuerySchema = z
  .object({
    descricao: z.string().trim().optional(),
    clienteId: z.coerce.number().int().positive().optional(),
    dataInicio: dateStringSchema.optional(),
    dataFim: dateStringSchema.optional(),
    pagina: z.coerce.number().int().min(1).default(1),
    limite: z.coerce.number().int().min(1).max(1000).default(100),
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

export type QueryOpsQuery = z.infer<typeof queryOpsQuerySchema>;

export const queryClientesQuerySchema = z.object({
  term: z.string().trim().optional(),
  limite: z.coerce.number().int().min(1).max(200).default(50),
});

export type QueryClientesQuery = z.infer<typeof queryClientesQuerySchema>;

export const wingraphexClienteSchema = z.object({
  id: z.coerce.number().int().positive(),
  nome: z.string(),
  fantasia: z.string(),
});

export type WingraphexCliente = z.infer<typeof wingraphexClienteSchema>;

export const notaFaturamentoSchema = z.object({
  serie: z.string().nullable(),
  numero: z.string(),
  data: z.string().nullable(),
  valor: z.coerce.number(),
  quantidade: z.coerce.number(),
});

export type NotaFaturamento = z.infer<typeof notaFaturamentoSchema>;

export const wingraphexOpSchema = z.object({
  op: z.number(),
  cliente: z.string().nullable(),
  descricao: z.string(),
  qtd_total: z.coerce.number(),
  entregue: z.coerce.number().default(0),
  valor_servico: z.coerce.number(),
  data_emissao: z.string(),
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
    setores: z
      .array(
        z.object({
          id: z.string(),
          nome: z.string(),
          ordem: z.number().int().nonnegative(),
          processos: z.coerce.number(),
          finalizados: z.coerce.number(),
          finalizado: z.boolean(),
        }),
      )
      .default([]),
  }),
});

export type WingraphexOp = z.infer<typeof wingraphexOpSchema>;

export const wingraphexOpsResponseSchema = z.object({
  itens: z.array(wingraphexOpSchema),
  total: z.number().int().nonnegative(),
  pagina: z.number().int().positive(),
  totalPaginas: z.number().int().nonnegative(),
});

export type WingraphexOpsResponse = z.infer<typeof wingraphexOpsResponseSchema>;