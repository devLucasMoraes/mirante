import type { HydratedDocument, Types } from "mongoose";
import { model, Schema } from "mongoose";

export interface ReciboEntregaItemFields {
  op: number;
  cliente: string | null;
  descricao: string;
  quantidade: number;
}

export interface ReciboEntregaFields {
  numero: number;
  dataEntrega: Date;
  usuario: {
    id: Types.ObjectId;
    nome: string;
  };
  itens: ReciboEntregaItemFields[];
  createdAt: Date;
  updatedAt: Date;
}

export interface ReciboEntregaDTO {
  id: string;
  numero: number;
  dataEntrega: string;
  usuario: {
    id: string;
    nome: string;
  };
  itens: ReciboEntregaItemFields[];
  createdAt: string;
}

export type ReciboEntregaDoc = HydratedDocument<ReciboEntregaFields>;

const reciboEntregaItemSchema = new Schema<ReciboEntregaItemFields>(
  {
    op: { type: Number, required: true },
    cliente: { type: String, default: null },
    descricao: { type: String, required: true, trim: true },
    quantidade: { type: Number, required: true, min: 0 },
  },
  { _id: false },
);

const reciboEntregaSchema = new Schema<ReciboEntregaFields>(
  {
    numero: { type: Number, required: true, unique: true },
    dataEntrega: { type: Date, required: true },
    usuario: {
      id: { type: Schema.Types.ObjectId, ref: "User", required: true },
      nome: { type: String, required: true, trim: true },
    },
    itens: {
      type: [reciboEntregaItemSchema],
      required: true,
      validate: {
        validator: (itens: ReciboEntregaItemFields[]) => itens.length > 0,
        message: "O recibo precisa de ao menos um item.",
      },
    },
  },
  { timestamps: true },
);

reciboEntregaSchema.index({ "itens.op": 1 });

reciboEntregaSchema.set("toJSON", {
  transform(_doc, ret) {
    const plain = ret as unknown as Record<string, unknown>;
    plain.id = String(plain._id);
    delete plain._id;
    delete plain.__v;
    return ret;
  },
});

export const ReciboEntregaModel = model<ReciboEntregaFields>(
  "ReciboEntrega",
  reciboEntregaSchema,
);

export function toReciboEntregaDTO(
  doc: ReciboEntregaFields & { _id: Types.ObjectId },
): ReciboEntregaDTO {
  const usuario = doc.usuario;
  return {
    id: String(doc._id),
    numero: doc.numero,
    dataEntrega: doc.dataEntrega.toISOString().slice(0, 10),
    usuario: {
      id: String(usuario.id),
      nome: usuario.nome,
    },
    itens: doc.itens.map((item) => ({
      op: item.op,
      cliente: item.cliente,
      descricao: item.descricao,
      quantidade: item.quantidade,
    })),
    createdAt: doc.createdAt.toISOString(),
  };
}