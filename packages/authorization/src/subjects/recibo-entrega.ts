import { z } from "zod";

export const reciboEntregaSubjectSchema = z.object({
  __typename: z.literal("ReciboEntrega").default("ReciboEntrega"),
  usuario: z.object({
    id: z.string(),
  }),
});

export const reciboEntregaSubject = z.tuple([
  z.union([
    z.literal("manage"),
    z.literal("read"),
    z.literal("create"),
    z.literal("delete"),
  ]),
  z.union([z.literal("ReciboEntrega"), reciboEntregaSubjectSchema]),
]);