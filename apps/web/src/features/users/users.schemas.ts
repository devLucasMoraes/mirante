import { z } from "zod";

import { userRoleSchema } from "@repo/authorization";

export type { User, UserRole } from "@repo/authorization";
export { userRoleSchema, userSchema } from "@repo/authorization";

export const createUserSchema = z.object({
  username: z.string().min(3, "O usuário deve ter ao menos 3 caracteres"),
  name: z.string().min(1, "Informe o nome"),
  password: z.string().min(6, "A senha deve ter ao menos 6 caracteres"),
  role: userRoleSchema,
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
  role: userRoleSchema.optional(),
});

export type UpdateUserPayload = z.infer<typeof updateUserSchema>;

export const updateProfileSchema = z.object({
  name: z.string().min(1, "Informe o nome").optional(),
  password: z
    .string()
    .min(6, "A senha deve ter ao menos 6 caracteres")
    .optional(),
});

export type UpdateProfilePayload = z.infer<typeof updateProfileSchema>;
