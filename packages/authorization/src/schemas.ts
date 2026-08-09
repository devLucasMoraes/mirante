import { z } from "zod";

export const userRoleSchema = z.enum(["admin", "user"]);

export type UserRole = z.infer<typeof userRoleSchema>;

export const userSchema = z.object({
  __typename: z.literal("User").default("User"),
  id: z.string(),
  username: z.string(),
  name: z.string(),
  role: userRoleSchema,
});

export type User = z.infer<typeof userSchema>;