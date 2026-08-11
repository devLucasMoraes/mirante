import fp from "fastify-plugin";
import type { FastifyInstance } from "fastify";
import { createAuthService } from "../services/auth.service.ts";
import type { AuthServiceOptions } from "../types/fastify.ts";

export const authPlugin = fp<AuthServiceOptions>(
  async function authPlugin(fastify: FastifyInstance, opts) {
    fastify.decorate("authService", createAuthService(fastify, opts));
  },
  { name: "auth-plugin" },
);
