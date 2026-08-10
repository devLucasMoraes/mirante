import Fastify from "fastify";
import type { FastifyInstance } from "fastify";
import cors from "@fastify/cors";
import helmet from "@fastify/helmet";
import rateLimit from "@fastify/rate-limit";
import cookie from "@fastify/cookie";
import jwt from "@fastify/jwt";
import mongoosePlugin from "./plugins/mongoose.ts";
import authPlugin from "./plugins/auth.ts";
import csrfPlugin from "./plugins/csrf.ts";
import healthRoutes from "./routes/health.ts";
import authRoutes from "./routes/auth.ts";
import usersRoutes from "./routes/users.ts";
import { config, mongoUri } from "./config.ts";
import { setErrorHandler } from "./errors.ts";

export async function createApp(): Promise<FastifyInstance> {
  const fastify = Fastify({ logger: true });

  await fastify.register(helmet);
  await fastify.register(cors, {
    origin: config.CORS_ORIGIN,
    credentials: true,
  });
  await fastify.register(rateLimit, { max: 100, timeWindow: "1 minute" });
  await fastify.register(cookie, { secret: config.COOKIE_SECRET });

  await fastify.register(mongoosePlugin, { uri: mongoUri });
  await fastify.register(jwt, { secret: config.JWT_ACCESS_SECRET });
  await fastify.register(authPlugin, {
    refreshSecret: config.JWT_REFRESH_SECRET,
    refreshTtl: config.REFRESH_TOKEN_TTL,
  });
  await fastify.register(csrfPlugin);

  await fastify.register(healthRoutes);
  await fastify.register(authRoutes, { prefix: "/api/auth" });
  await fastify.register(usersRoutes, { prefix: "/api" });

  setErrorHandler(fastify);

  return fastify;
}
