import { http, HttpResponse } from "msw";

import type { User } from "@/features/users/users.schemas";

export const testUser: User = {
  __typename: "User",
  id: "user-1",
  username: "joao",
  name: "João",
  role: "user",
};

const reciboUsuario = { id: testUser.id, nome: testUser.name };

export const handlers = [
  http.post("*/api/auth/login", () => HttpResponse.json({ user: testUser })),
  http.post(
    "*/api/auth/logout",
    () => new HttpResponse(null, { status: 204 }),
  ),
  http.post(
    "*/api/auth/refresh",
    () => new HttpResponse(null, { status: 204 }),
  ),
  http.get("*/api/entregas/op/:opId", () =>
    HttpResponse.json([
      {
        __typename: "ReciboEntrega",
        id: "recibo-1",
        numero: 1,
        dataEntrega: "2026-08-10",
        usuario: reciboUsuario,
        itens: [
          { op: 5, cliente: "Cliente X", descricao: "Cartão de visita", quantidade: 500 },
        ],
        createdAt: "2026-08-10T12:00:00.000Z",
      },
      {
        __typename: "ReciboEntrega",
        id: "recibo-2",
        numero: 2,
        dataEntrega: "2026-08-12",
        usuario: reciboUsuario,
        itens: [
          { op: 5, cliente: "Cliente X", descricao: "Folder A4", quantidade: 200 },
        ],
        createdAt: "2026-08-12T12:00:00.000Z",
      },
    ]),
  ),
  http.post("*/api/entregas", () =>
    HttpResponse.json(
      {
        __typename: "ReciboEntrega",
        id: "recibo-3",
        numero: 3,
        dataEntrega: "2026-08-16",
        usuario: reciboUsuario,
        itens: [
          { op: 5, cliente: "Cliente X", descricao: "Cartão de visita", quantidade: 500 },
        ],
        createdAt: "2026-08-16T12:00:00.000Z",
      },
      { status: 201 },
    ),
  ),
];