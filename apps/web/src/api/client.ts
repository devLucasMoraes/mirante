import type { AxiosError, InternalAxiosRequestConfig } from "axios";
import axios from "axios";
import { toast } from "sonner";

import { useAuthStore } from "@/features/auth/auth.store";

export function resolveBaseUrl(raw: string | undefined): string {
  if (raw === undefined) {
    return import.meta.env.PROD ? "/api" : "http://localhost:3000/api";
  }
  if (
    raw.startsWith("http://") ||
    raw.startsWith("https://") ||
    raw.startsWith("/")
  ) {
    return raw;
  }
  return "/api";
}

const BASE_URL = resolveBaseUrl(import.meta.env.VITE_API_URL);

export const api = axios.create({
  baseURL: BASE_URL,
  withCredentials: true,
});

type RetriableConfig = InternalAxiosRequestConfig & { _retry?: boolean };

let refreshPromise: Promise<boolean> | null = null;

api.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalConfig = error.config as RetriableConfig | undefined;
    const isAuthEndpoint = originalConfig?.url?.includes("/auth/");

    if (
      error.response?.status === 401 &&
      originalConfig !== undefined &&
      originalConfig._retry !== true &&
      !isAuthEndpoint
    ) {
      originalConfig._retry = true;
      refreshPromise ??= performRefresh();
      const refreshed = await refreshPromise;
      refreshPromise = null;

      if (refreshed) {
        return api(originalConfig);
      }
    }

    return Promise.reject(error);
  },
);

async function performRefresh(): Promise<boolean> {
  const { logout } = useAuthStore.getState();

  try {
    await api.post("/auth/refresh");
    return true;
  } catch {
    toast.error("Sessão expirada. Faça login novamente.");
    await logout();
    return false;
  }
}
