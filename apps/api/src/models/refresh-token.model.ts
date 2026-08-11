import { Schema, model } from "mongoose";
import type { HydratedDocument, Types } from "mongoose";

export interface RefreshTokenFields {
  tokenHash: string;
  familyId: string;
  userId: Types.ObjectId;
  expiresAt: Date;
  createdAt: Date;
  revokedAt: Date | null;
  replacedBy: string | null;
}

export type RefreshTokenDoc = HydratedDocument<RefreshTokenFields>;

const refreshTokenSchema = new Schema<RefreshTokenFields>({
  tokenHash: { type: String, required: true, unique: true },
  familyId: { type: String, required: true, index: true },
  userId: {
    type: Schema.Types.ObjectId,
    ref: "User",
    required: true,
    index: true,
  },
  expiresAt: { type: Date, required: true },
  createdAt: { type: Date, default: Date.now },
  revokedAt: { type: Date, default: null },
  replacedBy: { type: String, default: null },
});

export const RefreshTokenModel = model<RefreshTokenFields>(
  "RefreshToken",
  refreshTokenSchema,
);
