import type { FastifyInstance } from "fastify";
import { Types } from "mongoose";

import { AppError, isDuplicateKeyError } from "../lib/errors.ts";
import {
  PcpEquipamentoSetorModel,
  type PcpSetorDTO,
  PcpSetorModel,
  toPcpSetorDTO,
} from "../models/index.ts";
import type { EquipamentoComSetor } from "../schemas/index.ts";
import { queryEquipamentos } from "./wingraphex.service.ts";

const EMP_ID = 1;

function assertSetorObjectId(id: string): Types.ObjectId {
  if (!Types.ObjectId.isValid(id)) {
    throw new AppError(404, "Setor não encontrado.");
  }
  return new Types.ObjectId(id);
}

export async function listarSetores(): Promise<PcpSetorDTO[]> {
  const docs = await PcpSetorModel.find().sort({ ordem: 1 }).exec();
  return docs.map((doc) => toPcpSetorDTO(doc));
}

export async function criarSetor(nome: string): Promise<PcpSetorDTO> {
  const ultimo = await PcpSetorModel.findOne()
    .sort({ ordem: -1 })
    .select("ordem")
    .exec();
  const ordem = (ultimo?.ordem ?? -1) + 1;

  try {
    const doc = await PcpSetorModel.create({ nome, ordem });
    return toPcpSetorDTO(doc);
  } catch (err) {
    if (isDuplicateKeyError(err)) {
      throw new AppError(409, "Já existe um setor com esse nome.");
    }
    throw err;
  }
}

export async function renomearSetor(
  id: string,
  nome: string,
): Promise<PcpSetorDTO> {
  const setorId = assertSetorObjectId(id);
  try {
    const doc = await PcpSetorModel.findByIdAndUpdate(
      setorId,
      { nome },
      { returnDocument: "after" },
    ).exec();
    if (doc === null) {
      throw new AppError(404, "Setor não encontrado.");
    }
    return toPcpSetorDTO(doc);
  } catch (err) {
    if (isDuplicateKeyError(err)) {
      throw new AppError(409, "Já existe um setor com esse nome.");
    }
    if (err instanceof AppError) throw err;
    throw err;
  }
}

export async function excluirSetor(id: string): Promise<void> {
  const setorId = assertSetorObjectId(id);
  const doc = await PcpSetorModel.findByIdAndDelete(setorId).exec();
  if (doc === null) {
    throw new AppError(404, "Setor não encontrado.");
  }
  await PcpEquipamentoSetorModel.deleteMany({ setorId: doc._id }).exec();
}

export async function reordenarSetores(ids: string[]): Promise<void> {
  const idsUnicos = [...new Set(ids)];
  const existentes = await PcpSetorModel.find({
    _id: { $in: idsUnicos },
  })
    .select("_id")
    .exec();
  if (existentes.length !== idsUnicos.length) {
    throw new AppError(400, "Um ou mais setores não existem.");
  }

  await PcpSetorModel.bulkWrite(
    ids.map((id, index) => ({
      updateOne: {
        filter: { _id: new Types.ObjectId(id) },
        update: { $set: { ordem: index } },
      },
    })),
  );
}

export async function vincularEquipamento(
  codigo: number,
  setorId: string | null,
): Promise<void> {
  const filter = { empId: EMP_ID, codigoEquipamento: codigo };

  if (setorId === null) {
    await PcpEquipamentoSetorModel.deleteOne(filter).exec();
    return;
  }

  const setorObjectId = assertSetorObjectId(setorId);
  const setorExiste = await PcpSetorModel.exists({ _id: setorObjectId }).exec();
  if (!setorExiste) {
    throw new AppError(404, "Setor não encontrado.");
  }

  try {
    await PcpEquipamentoSetorModel.findOneAndUpdate(
      filter,
      { $set: { setorId: setorObjectId } },
      { upsert: true },
    ).exec();
  } catch (err) {
    if (isDuplicateKeyError(err)) {
      throw new AppError(409, "Vínculo do equipamento já existe.");
    }
    throw err;
  }
}

export async function listarEquipamentosComSetor(
  fastify: FastifyInstance,
): Promise<EquipamentoComSetor[]> {
  const equipamentos = await queryEquipamentos(fastify);
  if (equipamentos.length === 0) return [];

  const vinculos = await PcpEquipamentoSetorModel.find({
    empId: EMP_ID,
    codigoEquipamento: {
      $in: equipamentos.map((equipamento) => equipamento.codigo),
    },
  })
    .select("codigoEquipamento setorId")
    .exec();

  const setorPorCodigo = new Map(
    vinculos.map((vinculo) => [
      vinculo.codigoEquipamento,
      String(vinculo.setorId),
    ]),
  );

  return equipamentos.map((equipamento) => ({
    codigo: equipamento.codigo,
    nome: equipamento.nome,
    setorId: setorPorCodigo.get(equipamento.codigo) ?? null,
  }));
}