import type { FastifyRequest } from "fastify";

import {
  type AppAbilities,
  type AppAbility,
  defineAbilityFor,
  type User,
  userSchema,
} from "@repo/authorization";

import type { UserDTO } from "../models/user.model.ts";
import type { JwtUser } from "../types/fastify.ts";
import { AppError } from "./errors.ts";

export function getUserAbility(user: JwtUser): AppAbility {
  return defineAbilityFor(userSchema.parse({ ...user }));
}

export function toUserSubject(dto: UserDTO): User {
  return userSchema.parse(dto);
}

export function requireAbility<
  A extends AppAbilities[0],
  S extends AppAbilities[1],
>(action: A, subject: S) {
  return async (request: FastifyRequest): Promise<void> => {
    const ability = getUserAbility(request.user);
    if (ability.cannot(action as never, subject as never)) {
      throw new AppError(403, "Acesso restrito.");
    }
  };
}
