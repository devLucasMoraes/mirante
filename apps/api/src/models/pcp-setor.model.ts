import type { HydratedDocument, Types } from "mongoose";
import { model, Schema } from "mongoose";

export interface PcpSetorFields {
  nome: string;
  ordem: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface PcpSetorDTO {
  id: string;
  nome: string;
  ordem: number;
}

export type PcpSetorDoc = HydratedDocument<Omit<PcpSetorFields, "createdAt" | "updatedAt">>;

const pcpSetorSchema = new Schema<PcpSetorFields>(
  {
    nome: { type: String, required: true, unique: true, trim: true },
    ordem: { type: Number, required: true, min: 0 },
  },
  { timestamps: true },
);

export const PcpSetorModel = model<PcpSetorFields>("PcpSetor", pcpSetorSchema);

export function toPcpSetorDTO(
  doc: PcpSetorFields & { _id: Types.ObjectId },
): PcpSetorDTO {
  return {
    id: String(doc._id),
    nome: doc.nome,
    ordem: doc.ordem,
  };
}