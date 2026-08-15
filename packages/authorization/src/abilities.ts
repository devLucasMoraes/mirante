import {
  type CreateAbility,
  createMongoAbility,
  type MongoAbility,
} from "@casl/ability";
import { z } from "zod";

import { reciboEntregaSubject } from "./subjects/recibo-entrega.ts";
import { userSubject } from "./subjects/user.ts";

export const appAbilities = z.union([
  userSubject,
  reciboEntregaSubject,
  z.tuple([z.literal("manage"), z.literal("all")]),
  z.tuple([z.literal("read"), z.literal("WingraphexOp")]),
]);

export type AppAbilities = z.infer<typeof appAbilities>;

export type AppAbility = MongoAbility<AppAbilities>;

export const createAppAbility = createMongoAbility as CreateAbility<AppAbility>;