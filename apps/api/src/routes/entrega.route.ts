import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

import { authenticate } from "../hooks/authenticate.hook.ts";
import { requireAbility } from "../lib/authorization.ts";
import {
  createReciboSchema,
  opParamSchema,
  reciboEntregaResponseSchema,
  reciboIdParamSchema,
} from "../schemas/index.ts";
import {
  createRecibo,
  deleteRecibo,
  historicoPorOp,
} from "../services/index.ts";

export async function entregaRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/",
    {
      preHandler: requireAbility("create", "ReciboEntrega"),
      schema: {
        body: createReciboSchema,
        response: { 201: reciboEntregaResponseSchema },
      },
    },
    async (request, reply) => {
      const recibo = await createRecibo(fastify, request.user, request.body);
      return reply.status(201).send(recibo);
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/op/:opId",
    {
      preHandler: requireAbility("read", "ReciboEntrega"),
      schema: {
        params: opParamSchema,
        response: { 200: z.array(reciboEntregaResponseSchema) },
      },
    },
    async (request) => historicoPorOp(fastify, request.params.opId),
  );

  fastify.withTypeProvider<ZodTypeProvider>().delete(
    "/:id",
    {
      preHandler: requireAbility("delete", "ReciboEntrega"),
      schema: {
        params: reciboIdParamSchema,
      },
    },
    async (request, reply) => {
      await deleteRecibo(fastify, request.user, request.params.id);
      return reply.status(204).send();
    },
  );
}