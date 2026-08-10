import type { FastifyInstance } from "fastify";

export default async function healthRoutes(fastify: FastifyInstance) {
  fastify.get(
    "/health",
    {
      schema: {
        response: {
          200: {
            type: "object",
            properties: {
              status: { type: "string" },
              db: { type: "number" },
            },
          },
        },
      },
    },
    async () => ({
      status: "ok",
      db: fastify.mongoose.connection.readyState,
    }),
  );
}
