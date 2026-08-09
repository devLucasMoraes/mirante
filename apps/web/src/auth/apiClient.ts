import axios from "axios";
import type { AxiosError, InternalAxiosRequestConfig } from "axios";
import { refreshResponseSchema } from "./schemas";
import { useAuthStore } from "./authStore";

const BASE_URL = import.meta.env.VITE_API_URL ?? "http://localhost:3333/api";

export const api = axios.create({
  baseURL: BASE_URL,
});

api.interceptors.request.use((config) => {
  const { accessToken } = useAuthStore.getState();
  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`;
  }
  return config;
});

type RetriableConfig = InternalAxiosRequestConfig & { _retry?: boolean };

let refreshPromise: Promise<string | null> | null = null;

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
      const newAccessToken = await refreshPromise;
      refreshPromise = null;

      if (newAccessToken) {
        originalConfig.headers.Authorization = `Bearer ${newAccessToken}`;
        return api(originalConfig);
      }
    }

    return Promise.reject(error);
  },
);

async function performRefresh(): Promise<string | null> {
  const { refreshToken, logout } = useAuthStore.getState();
  if (!refreshToken) {
    await logout();
    return null;
  }

  try {
    const { data } = await api.post<unknown>("/auth/refresh", { refreshToken });
    const { accessToken } = refreshResponseSchema.parse(data);
    useAuthStore.setState({ accessToken });
    return accessToken;
  } catch {
    await logout();
    return null;
  }
}