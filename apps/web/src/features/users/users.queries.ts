import { queryOptions, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import { createUser, deleteUser, listUsers, updateUser } from "@/api/users.api";

import { usersKeys } from "./users.query-keys";
import type { UpdateUserPayload } from "./users.schemas";

export const usersQueryOptions = queryOptions({
  queryKey: usersKeys.list(),
  queryFn: listUsers,
});

export function useUsersQuery() {
  return useQuery(usersQueryOptions);
}

export function useCreateUserMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: createUser,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: usersKeys.all });
    },
  });
}

export function useUpdateUserMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, payload }: { id: string; payload: UpdateUserPayload }) =>
      updateUser(id, payload),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: usersKeys.all });
    },
  });
}

export function useDeleteUserMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: deleteUser,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: usersKeys.all });
    },
  });
}
