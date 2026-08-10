import Fastify from "fastify";
import type { FastifyInstance } from "fastify";
import mongoosePlugin from "./plugins/mongoose.ts";
import healthRoutes from "./routes/health.ts";
import { mongoUri } from "./config.ts";

export async function createApp(): Promise<FastifyInstance> {
  const fastify = Fastify({ logger: true });

  await fastify.register(mongoosePlugin, { uri: mongoUri });
  await fastify.register(healthRoutes);

  return fastify;
}
