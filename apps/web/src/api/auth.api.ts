import type { Credentials } from "@/features/auth/auth.schemas";
import {
  authResponseSchema,
  credentialsSchema,
} from "@/features/auth/auth.schemas";

import { api } from "./client";

export async function login(credentials: Credentials) {
  const payload = credentialsSchema.parse(credentials);
  const { data } = await api.post<unknown>("/auth/login", payload);
  return authResponseSchema.parse(data);
}

export async function logout(): Promise<void> {
  await api.post("/auth/logout");
}
