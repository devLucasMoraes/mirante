import { z } from "zod";

export const pcpSetorSubjectSchema = z.object({
  __typename: z.literal("PcpSetor").default("PcpSetor"),
  id: z.string(),
  nome: z.string(),
  ordem: z.number().int().nonnegative(),
});

export const pcpSetorSubject = z.tuple([
  z.union([
    z.literal("manage"),
    z.literal("read"),
    z.literal("create"),
    z.literal("update"),
    z.literal("delete"),
  ]),
  z.union([z.literal("PcpSetor"), pcpSetorSubjectSchema]),
]);