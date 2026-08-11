import type { FastifyReply, FastifyRequest } from "fastify";

import { config } from "../config.ts";

const TTL_MS = { s: 1_000, m: 60_000, h: 3_600_000, d: 86_400_000 } as const;

export function ttlToMs(ttl: string): number {
  const match = /^(\d+)([smhd])$/.exec(ttl.trim());
  if (match === null) {
    return 0;
  }
  const amount = Number(match[1]);
  const unit = match[2] as keyof typeof TTL_MS;
  return amount * TTL_MS[unit];
}

export type AuthCookiesOptions = {
  accessToken: string;
  refreshToken: string;
  accessTtl: string;
  refreshTtl: string;
};

export const COOKIE_NAMES = {
  access: "access_token",
  refresh: "refresh_token",
} as const;

export function getSignedCookie(
  request: FastifyRequest,
  name: string,
): string | undefined {
  const value = request.cookies[name];
  if (!value) {
    return undefined;
  }
  const unsigned = request.unsignCookie(value);
  return unsigned.valid ? unsigned.value : undefined;
}

export function setAuthCookies(reply: FastifyReply, opts: AuthCookiesOptions): void {
  const base = {
    httpOnly: true,
    secure: config.COOKIE_SECURE,
    sameSite: "strict",
    signed: true,
  } as const;

  reply.setCookie(COOKIE_NAMES.access, opts.accessToken, {
    ...base,
    path: "/api",
    maxAge: ttlToMs(opts.accessTtl) / 1_000,
  });
  reply.setCookie(COOKIE_NAMES.refresh, opts.refreshToken, {
    ...base,
    path: "/api/auth",
    maxAge: ttlToMs(opts.refreshTtl) / 1_000,
  });
}

export function clearAuthCookies(reply: FastifyReply): void {
  reply.clearCookie(COOKIE_NAMES.access, { path: "/api" });
  reply.clearCookie(COOKIE_NAMES.refresh, { path: "/api/auth" });
}
