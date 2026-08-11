import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

export async function healthRoutes(fastify: FastifyInstance) {
  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/health",
    {
      schema: {
        response: {
          200: z.object({
            status: z.string(),
            db: z.number(),
          }),
        },
      },
    },
    async () => ({
      status: "ok",
      db: fastify.mongoose.connection.readyState,
    }),
  );
}
