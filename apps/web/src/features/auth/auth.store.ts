import { create } from "zustand";
import { createJSONStorage, persist } from "zustand/middleware";

import { login as loginRequest, logout as logoutRequest } from "@/api/auth.api";
import type { User } from "@/features/users/users.schemas";
import { getErrorMessage } from "@/lib/error-message";

import type { Credentials } from "./auth.schemas";

type AuthStatus = "idle" | "loading" | "authenticated" | "unauthenticated";

type AuthState = {
  user: User | null;
  status: AuthStatus;
  error: string | null;
  login: (credentials: Credentials) => Promise<boolean>;
  logout: () => Promise<void>;
  setUser: (user: User) => void;
  clearError: () => void;
};

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      status: "idle",
      error: null,

      login: async (credentials) => {
        set({ status: "loading", error: null });
        try {
          const { user } = await loginRequest(credentials);
          set({ user, status: "authenticated", error: null });
          return true;
        } catch (error) {
          set({ status: "unauthenticated", error: getErrorMessage(error) });
          return false;
        }
      },

      logout: async () => {
        try {
          await logoutRequest();
        } catch {
          // best-effort: o logout local sempre acontece
        }
        set({ user: null, status: "unauthenticated", error: null });
      },

      setUser: (user) => set({ user }),

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
