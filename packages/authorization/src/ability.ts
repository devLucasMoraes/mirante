import {
  AbilityBuilder,
  type RawRuleOf,
} from "@casl/ability";
import { createAppAbility, type AppAbility } from "./abilities";
import type { User, UserRole } from "./schemas";

export function defineRulesFor(role: UserRole): RawRuleOf<AppAbility>[] {
  const builder = new AbilityBuilder(createAppAbility);

  if (role === "admin") {
    builder.can("manage", "all");
  } else {
    builder.can("read", "User");
  }

  return builder.rules;
}

export function defineAbilityFor(user: User): AppAbility {
  const builder = new AbilityBuilder(createAppAbility);

  if (user.role === "admin") {
    builder.can("manage", "all");
  } else {
    builder.can("read", "User");
    builder.can("update", "User", { id: user.id });
  }

  return builder.build({
    detectSubjectType: (subject) =>
      typeof subject === "string" ? subject : subject.__typename,
  });
}