import { z } from "zod";

const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "Formato esperado: YYYY-MM-DD");

export const reciboEntregaItemSchema = z.object({
  op: z.coerce.number().int().positive(),
  cliente: z.string().nullable().optional(),
  descricao: z.string().trim().min(1, "Informe a descrição"),
  quantidade: z.coerce.number().positive("A quantidade deve ser maior que zero"),
});

export type ReciboEntregaItem = z.infer<typeof reciboEntregaItemSchema>;

export const createReciboPayloadSchema = z
  .object({
    dataEntrega: dateStringSchema,
    itens: z
      .array(
        reciboEntregaItemSchema.pick({
          op: true,
          cliente: true,
          descricao: true,
          quantidade: true,
        }),
      )
      .min(1, "Selecione ao menos uma OP"),
  })
  .superRefine((payload, ctx) => {
    const ops = payload.itens.map((item) => item.op);
    const duplicadas = ops.filter((op, index) => ops.indexOf(op) !== index);
    if (duplicadas.length > 0) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["itens"],
        message: `OP não pode ser repetida no mesmo recibo: ${[...new Set(duplicadas)].join(", ")}`,
      });
    }
  });

export type CreateReciboPayload = z.infer<typeof createReciboPayloadSchema>;

export const reciboEntregaSchema = z.object({
  __typename: z.literal("ReciboEntrega").default("ReciboEntrega"),
  id: z.string(),
  numero: z.number().int().positive(),
  dataEntrega: z.string(),
  usuario: z.object({
    id: z.string(),
    nome: z.string(),
  }),
  itens: z.array(reciboEntregaItemSchema),
  createdAt: z.string(),
});

export type ReciboEntrega = z.infer<typeof reciboEntregaSchema>;

export const historicoEntregaSchema = z.object({
  reciboId: z.string(),
  numero: z.number().int().positive(),
  dataEntrega: z.string(),
  usuarioNome: z.string(),
  descricao: z.string(),
  quantidade: z.coerce.number(),
  createdAt: z.string(),
});

export type HistoricoEntrega = z.infer<typeof historicoEntregaSchema>;