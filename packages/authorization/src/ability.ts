import {
  AbilityBuilder,
  type MongoQuery,
  type RawRuleOf,
} from "@casl/ability";
import { z } from "zod";

import { type AppAbility,createAppAbility } from "./abilities.ts";
import type { User, UserRole } from "./schemas.ts";
import { reciboEntregaSubjectSchema } from "./subjects/recibo-entrega.ts";

type ReciboAutorConditions = MongoQuery<
  z.infer<typeof reciboEntregaSubjectSchema>
>;

export function defineRulesFor(role: UserRole): RawRuleOf<AppAbility>[] {
  const builder = new AbilityBuilder(createAppAbility);

  builder.can("read", "WingraphexOp");
  builder.can(["read", "create"], "ReciboEntrega");

  if (role === "admin") {
    builder.can("manage", "all");
  } else {
    builder.can("update", "User", ["name", "password"]);
  }

  return builder.rules;
}

export function defineAbilityFor(user: User): AppAbility {
  const builder = new AbilityBuilder(createAppAbility);

  builder.can("read", "WingraphexOp");
  builder.can(["read", "create"], "ReciboEntrega");
  const condicaoAutor = {
    "usuario.id": user.id,
  } as unknown as ReciboAutorConditions;
  builder.can("delete", "ReciboEntrega", condicaoAutor);

  if (user.role === "admin") {
    builder.can("manage", "all");
  } else {
    builder.can("update", "User", ["name", "password"], { id: user.id });
  }

  return builder.build({
    detectSubjectType: (subject) =>
      typeof subject === "string" ? subject : subject.__typename,
  });
}