import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

import { authenticate } from "../hooks/authenticate.hook.ts";
import { requireAbility } from "../lib/authorization.ts";
import { queryOpsQuerySchema, wingraphexOpSchema } from "../schemas/index.ts";
import { queryOpsByDescription } from "../services/index.ts";

export async function wingraphexRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/ops",
    {
      preHandler: requireAbility("read", "WingraphexOp"),
      schema: {
        querystring: queryOpsQuerySchema,
        response: { 200: z.array(wingraphexOpSchema) },
      },
    },
    async (request) => queryOpsByDescription(fastify, request.query),
  );
}