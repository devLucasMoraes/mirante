import { http, HttpResponse } from "msw";
import { describe, expect, test, vi } from "vitest";

import { api, resolveBaseUrl } from "@/api/client";
import { useAuthStore } from "@/features/auth/auth.store";
import { testUser } from "@/test/handlers";
import { server } from "@/test/server";

describe("resolveBaseUrl", () => {
  test("usa o valor quando é uma URL http(s) válida", () => {
    expect(resolveBaseUrl("https://192.168.1.16/api")).toBe(
      "https://192.168.1.16/api",
    );
  });

  test("usa o valor quando é relativo à raiz", () => {
    expect(resolveBaseUrl("/api")).toBe("/api");
  });

  test("cai em /api quando o valor é um caminho mangleado (ex.: Git Bash)", () => {
    expect(resolveBaseUrl("C:/Program Files/Git/api")).toBe("/api");
  });

  test("usa localhost em dev quando não definido", () => {
    expect(resolveBaseUrl(undefined)).toBe("http://localhost:3000/api");
  });
});

describe("interceptor de resposta 401", () => {
  test("chama /auth/refresh e repete a requisição original", async () => {
    const getSpy = vi
      .fn()
      .mockResolvedValueOnce(new HttpResponse(null, { status: 401 }))
      .mockResolvedValueOnce(HttpResponse.json({ ok: true }));

    server.use(
      http.get("*/api/dados", getSpy),
      http.post(
        "*/api/auth/refresh",
        () => new HttpResponse(null, { status: 204 }),
      ),
    );

    const response = await api.get<{ ok: boolean }>("/dados");

    expect(response.data).toEqual({ ok: true });
    expect(getSpy).toHaveBeenCalledTimes(2);
  });

  test("se o refresh falhar, desloga e rejeita a requisição original", async () => {
    useAuthStore.setState({
      user: testUser,
      status: "authenticated",
      error: null,
    });

    server.use(
      http.get("*/api/dados", () => new HttpResponse(null, { status: 401 })),
      http.post(
        "*/api/auth/refresh",
        () => new HttpResponse(null, { status: 401 }),
      ),
      http.post(
        "*/api/auth/logout",
        () => new HttpResponse(null, { status: 204 }),
      ),
    );

    await expect(api.get("/dados")).rejects.toThrow();

    const state = useAuthStore.getState();
    expect(state.user).toBeNull();
    expect(state.status).toBe("unauthenticated");
  });

  test("não tenta refresh em endpoints de autenticação", async () => {
    const refreshSpy = vi.fn();

    server.use(
      http.post("*/api/auth/refresh", (info) => {
        refreshSpy(info.request.url);
        return new HttpResponse(null, { status: 204 });
      }),
      http.post(
        "*/api/auth/login",
        () => new HttpResponse(null, { status: 401 }),
      ),
    );

    await expect(api.post("/auth/login", {})).rejects.toThrow();
    expect(refreshSpy).not.toHaveBeenCalled();
  });
});