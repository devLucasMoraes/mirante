import { http, HttpResponse } from "msw";
import { beforeEach, describe, expect, test } from "vitest";

import { useAuthStore } from "@/features/auth/auth.store";
import { testUser } from "@/test/handlers";
import { server } from "@/test/server";

beforeEach(() => {
  useAuthStore.setState({ user: null, status: "idle", error: null });
});

describe("auth.store", () => {
  test("login com sucesso autentica e persiste o usuário", async () => {
    const ok = await useAuthStore
      .getState()
      .login({ username: "joao", password: "senha123" });

    expect(ok).toBe(true);

    const state = useAuthStore.getState();
    expect(state.status).toBe("authenticated");
    expect(state.error).toBeNull();
    expect(state.user).toMatchObject({ username: "joao", role: "user" });

    const persisted = JSON.parse(
      localStorage.getItem("auth-storage") ?? "{}",
    ) as { state: { user: typeof testUser } };
    expect(persisted.state.user.username).toBe("joao");
  });

  test("login com credenciais inválidas retorna false e registra erro", async () => {
    server.use(
      http.post(
        "*/api/auth/login",
        () =>
          HttpResponse.json(
            { message: "Credenciais inválidas." },
            { status: 401 },
          ),
        { once: true },
      ),
    );

    const ok = await useAuthStore
      .getState()
      .login({ username: "joao", password: "errada" });

    expect(ok).toBe(false);

    const state = useAuthStore.getState();
    expect(state.status).toBe("unauthenticated");
    expect(state.error).toBe("Credenciais inválidas.");
    expect(state.user).toBeNull();
  });

  test("logout limpa usuário e status", async () => {
    useAuthStore.setState({
      user: testUser,
      status: "authenticated",
      error: null,
    });

    await useAuthStore.getState().logout();

    const state = useAuthStore.getState();
    expect(state.user).toBeNull();
    expect(state.status).toBe("unauthenticated");
    expect(state.error).toBeNull();
  });
});