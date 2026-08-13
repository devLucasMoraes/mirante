import { z } from "zod";

const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Formato esperado: YYYY-MM-DD");

export const queryOpsQuerySchema = z
  .object({
    descricao: z.string().trim().min(1, "Informe um termo de descrição."),
    clienteId: z.coerce.number().int().positive().optional(),
    dataInicio: dateStringSchema.optional(),
    dataFim: dateStringSchema.optional(),
    limite: z.coerce.number().int().min(1).max(1000).default(100),
  })
  .refine(
    (query) =>
      query.dataInicio === undefined ||
      query.dataFim === undefined ||
      query.dataInicio <= query.dataFim,
    { path: ["dataFim"], message: "dataFim deve ser maior ou igual a dataInicio." },
  );

export type QueryOpsQuery = z.infer<typeof queryOpsQuerySchema>;

export const wingraphexOpSchema = z.object({
  op: z.number(),
  cliente: z.string().nullable(),
  qtd_total: z.coerce.number(),
  saldo_qtd: z.coerce.number(),
  valor_total: z.coerce.number(),
  saldo_producao: z.coerce.number(),
  valor_pago: z.coerce.number(),
  saldo_receber: z.coerce.number(),
  data_emissao: z.string(),
  status: z.string(),
  pcp_processos: z.coerce.number(),
  pcp_finalizados: z.coerce.number(),
});

export type WingraphexOp = z.infer<typeof wingraphexOpSchema>;