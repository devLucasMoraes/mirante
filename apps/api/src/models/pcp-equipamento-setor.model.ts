import type { HydratedDocument, Types } from "mongoose";
import { model, Schema } from "mongoose";

export interface PcpEquipamentoSetorFields {
  empId: number;
  codigoEquipamento: number;
  setorId: Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

export interface PcpEquipamentoSetorDTO {
  empId: number;
  codigoEquipamento: number;
  setorId: string;
}

export type PcpEquipamentoSetorDoc = HydratedDocument<PcpEquipamentoSetorFields>;

const pcpEquipamentoSetorSchema = new Schema<PcpEquipamentoSetorFields>(
  {
    empId: { type: Number, required: true, min: 1 },
    codigoEquipamento: { type: Number, required: true, min: 1 },
    setorId: {
      type: Schema.Types.ObjectId,
      ref: "PcpSetor",
      required: true,
    },
  },
  { timestamps: true },
);

pcpEquipamentoSetorSchema.index(
  { empId: 1, codigoEquipamento: 1 },
  { unique: true },
);

export const PcpEquipamentoSetorModel = model<PcpEquipamentoSetorFields>(
  "PcpEquipamentoSetor",
  pcpEquipamentoSetorSchema,
);