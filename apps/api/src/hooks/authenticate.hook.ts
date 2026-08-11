import type { FastifyRequest } from "fastify";

import { AppError } from "../lib/errors.ts";
import { COOKIE_NAMES, getSignedCookie } from "../services/cookie.service.ts";
import type { JwtUser } from "../types/fastify.ts";

export async function authenticate(request: FastifyRequest): Promise<void> {
  const token = getSignedCookie(request, COOKIE_NAMES.access);
  if (!token) {
    throw new AppError(401, "Não autorizado. Token ausente.");
  }
  try {
    const payload = request.server.jwt.verify<JwtUser>(token);
    request.user = payload;
  } catch {
    throw new AppError(401, "Não autorizado. Token inválido ou expirado.");
  }
}
