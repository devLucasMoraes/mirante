import type { FastifyInstance } from "fastify";
import { Types } from "mongoose";

import { reciboEntregaSubjectSchema } from "@repo/authorization";

import { getUserAbility } from "../lib/authorization.ts";
import { AppError } from "../lib/errors.ts";
import {
  nextSequenceValue,
  type ReciboEntregaDTO,
  ReciboEntregaModel,
  toReciboEntregaDTO,
} from "../models/index.ts";
import type { CreateReciboPayload } from "../schemas/index.ts";
import type { JwtUser } from "../types/fastify.ts";

const RECIBO_COUNTER = "reciboEntrega";

export async function createRecibo(
  _fastify: FastifyInstance,
  user: JwtUser,
  payload: CreateReciboPayload,
): Promise<ReciboEntregaDTO> {
  const numero = await nextSequenceValue(RECIBO_COUNTER);
  const doc = await ReciboEntregaModel.create({
    numero,
    dataEntrega: new Date(`${payload.dataEntrega}T00:00:00.000Z`),
    usuario: {
      id: new Types.ObjectId(user.id),
      nome: user.name,
    },
    itens: payload.itens.map((item) => ({
      op: item.op,
      cliente: item.cliente ?? null,
      descricao: item.descricao,
      quantidade: item.quantidade,
    })),
  });
  return toReciboEntregaDTO(doc);
}

export async function historicoPorOp(
  fastify: FastifyInstance,
  opId: number,
): Promise<ReciboEntregaDTO[]> {
  try {
    const docs = await ReciboEntregaModel.find({ "itens.op": opId })
      .sort({ createdAt: -1 })
      .exec();
    return docs.map(toReciboEntregaDTO);
  } catch (err) {
    fastify.log.error({ err, opId }, "historico de entregas falhou");
    throw new AppError(500, "Erro ao consultar histórico de entregas.");
  }
}

export async function sumQuantidadePorOps(
  opIds: number[],
): Promise<Map<number, number>> {
  if (opIds.length === 0) return new Map();
  const rows = await ReciboEntregaModel.aggregate<{
    _id: number;
    entregue: number;
  }>([
    { $unwind: "$itens" },
    { $match: { "itens.op": { $in: opIds } } },
    { $group: { _id: "$itens.op", entregue: { $sum: "$itens.quantidade" } } },
  ]).exec();
  return new Map(rows.map((row) => [row._id, row.entregue]));
}

export async function deleteRecibo(
  fastify: FastifyInstance,
  user: JwtUser,
  id: string,
): Promise<void> {
  if (!Types.ObjectId.isValid(id)) {
    throw new AppError(404, "Recibo não encontrado.");
  }
  try {
    const doc = await ReciboEntregaModel.findById(id).exec();
    if (doc === null) {
      throw new AppError(404, "Recibo não encontrado.");
    }

    const ability = getUserAbility(user);
    const sujeito = reciboEntregaSubjectSchema.parse(toReciboEntregaDTO(doc));
    if (ability.cannot("delete", sujeito)) {
      throw new AppError(403, "Acesso restrito.");
    }

    await ReciboEntregaModel.deleteOne({ _id: doc._id }).exec();
  } catch (err) {
    if (err instanceof AppError) throw err;
    fastify.log.error({ err, id }, "exclusão de recibo falhou");
    throw new AppError(500, "Erro ao excluir recibo.");
  }
}