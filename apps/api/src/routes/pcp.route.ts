import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";

import { authenticate } from "../hooks/authenticate.hook.ts";
import { requireAbility } from "../lib/authorization.ts";
import {
  criarSetorSchema,
  empresaQuerySchema,
  equipamentoCodigoParamSchema,
  equipamentoComSetorSchema,
  objectIdParamSchema,
  pcpSetorResponseSchema,
  renomearSetorSchema,
  reordenarSetoresSchema,
  vincularSetorSchema,
} from "../schemas/index.ts";
import {
  criarSetor,
  excluirSetor,
  listarEquipamentosComSetor,
  listarSetores,
  renomearSetor,
  reordenarSetores,
  vincularEquipamento,
} from "../services/index.ts";

export async function pcpRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/setores",
    {
      preHandler: requireAbility("read", "PcpSetor"),
      schema: {
        response: { 200: z.array(pcpSetorResponseSchema) },
      },
    },
    async () => listarSetores(),
  );

  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/setores",
    {
      preHandler: requireAbility("create", "PcpSetor"),
      schema: {
        body: criarSetorSchema,
        response: { 201: pcpSetorResponseSchema },
      },
    },
    async (request, reply) => {
      const setor = await criarSetor(request.body.nome);
      return reply.status(201).send(setor);
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().patch(
    "/setores/ordem",
    {
      preHandler: requireAbility("update", "PcpSetor"),
      schema: {
        body: reordenarSetoresSchema,
      },
    },
    async (request, reply) => {
      await reordenarSetores(request.body.ids);
      return reply.status(204).send();
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().patch(
    "/setores/:id",
    {
      preHandler: requireAbility("update", "PcpSetor"),
      schema: {
        params: objectIdParamSchema,
        body: renomearSetorSchema,
        response: { 200: pcpSetorResponseSchema },
      },
    },
    async (request) =>
      renomearSetor(request.params.id, request.body.nome),
  );

  fastify.withTypeProvider<ZodTypeProvider>().delete(
    "/setores/:id",
    {
      preHandler: requireAbility("delete", "PcpSetor"),
      schema: {
        params: objectIdParamSchema,
      },
    },
    async (request, reply) => {
      await excluirSetor(request.params.id);
      return reply.status(204).send();
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/equipamentos",
    {
      preHandler: requireAbility("read", "PcpSetor"),
      schema: {
        querystring: empresaQuerySchema,
        response: { 200: z.array(equipamentoComSetorSchema) },
      },
    },
    async (request) =>
      listarEquipamentosComSetor(fastify, request.query.empresa),
  );

  fastify.withTypeProvider<ZodTypeProvider>().patch(
    "/equipamentos/:codigo/setor",
    {
      preHandler: requireAbility("update", "PcpSetor"),
      schema: {
        params: equipamentoCodigoParamSchema,
        querystring: empresaQuerySchema,
        body: vincularSetorSchema,
      },
    },
    async (request, reply) => {
      await vincularEquipamento(
        request.query.empresa,
        request.params.codigo,
        request.body.setorId,
      );
      return reply.status(204).send();
    },
  );
}