import { z } from "zod";

import { userSchema } from "@repo/authorization";

export const credentialsSchema = z.object({
  username: z.string().min(3, "O usuário deve ter ao menos 3 caracteres"),
  password: z.string().min(6, "A senha deve ter ao menos 6 caracteres"),
});

export type Credentials = z.infer<typeof credentialsSchema>;

export const authResponseSchema = z.object({
  user: userSchema,
});
