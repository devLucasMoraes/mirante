import { z } from "zod";
import { USER_ROLES } from "./models/User.ts";

export const credentialsSchema = z.object({
  username: z.string().min(3, "O usuário deve ter ao menos 3 caracteres"),
  password: z.string().min(6, "A senha deve ter ao menos 6 caracteres"),
});

export type Credentials = z.infer<typeof credentialsSchema>;

export const createUserSchema = z.object({
  username: z.string().min(3, "O usuário deve ter ao menos 3 caracteres"),
  name: z.string().min(1, "Informe o nome"),
  password: z.string().min(6, "A senha deve ter ao menos 6 caracteres"),
  role: z.enum(USER_ROLES),
});

export type CreateUserPayload = z.infer<typeof createUserSchema>;

export const updateUserSchema = z.object({
  username: z
    .string()
    .min(3, "O usuário deve ter ao menos 3 caracteres")
    .optional(),
  name: z.string().min(1, "Informe o nome").optional(),
  password: z
    .string()
    .min(6, "A senha deve ter ao menos 6 caracteres")
    .optional(),
  role: z.enum(USER_ROLES).optional(),
});

export type UpdateUserPayload = z.infer<typeof updateUserSchema>;

export const userResponseSchema = z.object({
  id: z.string(),
  username: z.string(),
  name: z.string(),
  role: z.enum(USER_ROLES),
});

export type UserResponse = z.infer<typeof userResponseSchema>;
