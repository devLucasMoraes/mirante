import { Schema, model } from "mongoose";
import type { HydratedDocument, Types } from "mongoose";

export const USER_ROLES = ["admin", "user"] as const;
export type UserRole = (typeof USER_ROLES)[number];

export interface UserFields {
  username: string;
  name: string;
  passwordHash: string;
  role: UserRole;
}

export interface UserDTO {
  id: string;
  username: string;
  name: string;
  role: UserRole;
}

export type UserDoc = HydratedDocument<UserFields>;

const userSchema = new Schema<UserFields>(
  {
    username: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      minlength: 3,
    },
    name: { type: String, required: true, trim: true, minlength: 1 },
    passwordHash: { type: String, required: true, select: false },
    role: { type: String, required: true, enum: USER_ROLES, default: "user" },
  },
  { timestamps: true },
);

userSchema.set("toJSON", {
  transform(_doc, ret) {
    const plain = ret as unknown as Record<string, unknown>;
    plain.id = String(plain._id);
    delete plain._id;
    delete plain.__v;
    delete plain.passwordHash;
    return ret;
  },
});

export const UserModel = model<UserFields>("User", userSchema);

export function toUserDTO(
  doc: UserFields & { _id: Types.ObjectId },
): UserDTO {
  return {
    id: String(doc._id),
    username: doc.username,
    name: doc.name,
    role: doc.role,
  };
}
