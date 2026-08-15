import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

import { authenticate } from "../hooks/authenticate.hook.ts";
import { requireAbility } from "../lib/authorization.ts";
import {
  queryClientesQuerySchema,
  queryOpsQuerySchema,
  wingraphexClienteSchema,
  wingraphexOpsResponseSchema,
} from "../schemas/index.ts";
import {
  queryClientes,
  queryOpsByDescription,
  sumQuantidadePorOps,
} from "../services/index.ts";

export async function wingraphexRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/ops",
    {
      preHandler: requireAbility("read", "WingraphexOp"),
      schema: {
        querystring: queryOpsQuerySchema,
        response: { 200: wingraphexOpsResponseSchema },
      },
    },
    async (request) => {
      const response = await queryOpsByDescription(fastify, request.query);
      if (response.itens.length > 0) {
        const opIds = response.itens.map((item) => item.op);
        const entreguePorOp = await sumQuantidadePorOps(opIds);
        for (const item of response.itens) {
          item.entregue = entreguePorOp.get(item.op) ?? 0;
        }
      }
      return response;
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/clientes",
    {
      preHandler: requireAbility("read", "WingraphexOp"),
      schema: {
        querystring: queryClientesQuerySchema,
        response: { 200: z.array(wingraphexClienteSchema) },
      },
    },
    async (request) => queryClientes(fastify, request.query),
  );
}