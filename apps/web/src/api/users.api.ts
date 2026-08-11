import type {
  CreateUserPayload,
  UpdateUserPayload,
  User,
} from "@/features/users/users.schemas";
import {
  createUserSchema,
  updateUserSchema,
  userSchema,
} from "@/features/users/users.schemas";

import { api } from "./client";

function parseUsers(data: unknown): User[] {
  if (!Array.isArray(data)) {
    throw new Error("Resposta inválida da API");
  }
  return data.map((item) => userSchema.parse(item));
}

export async function listUsers(): Promise<User[]> {
  const { data } = await api.get<unknown>("/users");
  return parseUsers(data);
}

export async function createUser(payload: CreateUserPayload): Promise<User> {
  const parsed = createUserSchema.parse(payload);
  const { data } = await api.post<unknown>("/users", parsed);
  return userSchema.parse(data);
}

export async function updateUser(
  id: string,
  payload: UpdateUserPayload,
): Promise<User> {
  const parsed = updateUserSchema.parse(payload);
  const { data } = await api.patch<unknown>(`/users/${id}`, parsed);
  return userSchema.parse(data);
}

export async function deleteUser(id: string): Promise<void> {
  await api.delete(`/users/${id}`);
}
