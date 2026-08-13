import {
  AbilityBuilder,
  type RawRuleOf,
} from "@casl/ability";

import { type AppAbility,createAppAbility } from "./abilities.ts";
import type { User, UserRole } from "./schemas.ts";

export function defineRulesFor(role: UserRole): RawRuleOf<AppAbility>[] {
  const builder = new AbilityBuilder(createAppAbility);

  builder.can("read", "WingraphexOp");

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