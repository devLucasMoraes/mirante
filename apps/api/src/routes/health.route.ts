import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

async function pingWingraphex(fastify: FastifyInstance): Promise<boolean> {
  const timeout = new Promise<boolean>((resolve) => {
    setTimeout(() => resolve(false), 1500).unref();
  });
  const probe = fastify.wingraphex
    .query("SELECT 1")
    .then(() => true)
    .catch(() => false);
  return Promise.race([probe, timeout]);
}

export async function healthRoutes(fastify: FastifyInstance) {
  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/health",
    {
      schema: {
        response: {
          200: z.object({
            status: z.string(),
            db: z.number(),
            wingraphex: z.boolean(),
          }),
        },
      },
    },
    async () => ({
      status: "ok",
      db: fastify.mongoose.connection.readyState,
      wingraphex: await pingWingraphex(fastify),
    }),
  );
}