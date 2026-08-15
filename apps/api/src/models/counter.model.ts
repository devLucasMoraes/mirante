import type { HydratedDocument } from "mongoose";
import { model, Schema } from "mongoose";

export interface CounterFields {
  _id: string;
  seq: number;
}

export type CounterDoc = HydratedDocument<CounterFields>;

const counterSchema = new Schema<CounterFields>({
  _id: { type: String, required: true },
  seq: { type: Number, required: true, default: 0 },
});

export const CounterModel = model<CounterFields>("Counter", counterSchema);

export async function nextSequenceValue(name: string): Promise<number> {
  const counter = await CounterModel.findOneAndUpdate(
    { _id: name },
    { $inc: { seq: 1 } },
    { new: true, upsert: true, setDefaultsOnInsert: true },
  )
    .lean()
    .exec();
  return counter?.seq ?? 0;
}