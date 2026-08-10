import { create } from "zustand";
import { createJSONStorage, persist } from "zustand/middleware";
import { api } from "./apiClient";
import { getErrorMessage } from "./getErrorMessage";
import { authResponseSchema, credentialsSchema } from "./schemas";
import type { Credentials, User } from "./schemas";

type AuthStatus = "idle" | "loading" | "authenticated" | "unauthenticated";

type AuthState = {
  user: User | null;
  status: AuthStatus;
  error: string | null;
  login: (credentials: Credentials) => Promise<boolean>;
  logout: () => Promise<void>;
  clearError: () => void;
};

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      status: "idle",
      error: null,

      login: async (credentials) => {
        const payload = credentialsSchema.parse(credentials);
        set({ status: "loading", error: null });
        try {
          const { data } = await api.post<unknown>("/auth/login", payload);
          const session = authResponseSchema.parse(data);
          set({
            user: session.user,
            status: "authenticated",
            error: null,
          });
          return true;
        } catch (error) {
          set({ status: "unauthenticated", error: getErrorMessage(error) });
          return false;
        }
      },

      logout: async () => {
        try {
          await api.post("/auth/logout");
        } catch {
          // best-effort: o logout local sempre acontece
        }
        set({
          user: null,
          status: "unauthenticated",
          error: null,
        });
      },

      clearError: () => set({ error: null }),
    }),
    {
      name: "auth-storage",
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        user: state.user,
      }),
    },
  ),
);
