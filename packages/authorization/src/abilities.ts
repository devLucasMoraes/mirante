import {
  type CreateAbility,
  createMongoAbility,
  type MongoAbility,
} from "@casl/ability";
import { z } from "zod";

import { userSubject } from "./subjects/user.ts";

export const appAbilities = z.union([
  userSubject,
  z.tuple([z.literal("manage"), z.literal("all")]),
]);

export type AppAbilities = z.infer<typeof appAbilities>;

export type AppAbility = MongoAbility<AppAbilities>;

export const createAppAbility = createMongoAbility as CreateAbility<AppAbility>;