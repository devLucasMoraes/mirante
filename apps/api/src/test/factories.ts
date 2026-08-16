import { faker } from "@faker-js/faker";
import { hash } from "bcryptjs";

import { UserModel, type UserRole } from "../models/index.ts";

export const TEST_PASSWORD = "senha123";

const BCRYPT_ROUNDS = 4;

export interface CreateTestUserParams {
  username?: string;
  name?: string;
  role?: UserRole;
}

export async function createTestUser(params: CreateTestUserParams = {}) {
  const username =
    params.username ??
    `${faker.internet.username()}-${faker.string.nanoid(6)}`;
  const name = params.name ?? faker.person.fullName();
  const role = params.role ?? "user";
  const user = await UserModel.create({
    username,
    name,
    role,
    passwordHash: await hash(TEST_PASSWORD, BCRYPT_ROUNDS),
  });
  return { user, password: TEST_PASSWORD };
}

export interface FakeOpRow {
  op: string;
  cliente: string;
  descricao: string;
  qtd_total: string;
  valor_servico: string;
  data_emissao: string;
  status: string;
  pcp_processos: string;
  pcp_finalizados: string;
}

export function createFakeOpRow(): FakeOpRow {
  return {
    op: faker.number.int({ min: 1, max: 9_999 }).toString(),
    cliente: faker.company.name(),
    descricao: faker.commerce.productName(),
    qtd_total: faker.number.int({ min: 100, max: 100_000 }).toString(),
    valor_servico: faker.commerce.price({ min: 1, max: 5_000, dec: 2 }),
    data_emissao: "2026-08-01",
    status: "N",
    pcp_processos: "2",
    pcp_finalizados: "1",
  };
}

export interface FakeClienteRow {
  id: number;
  nome: string;
  fantasia: string;
}

export function createFakeClienteRow(): FakeClienteRow {
  return {
    id: faker.number.int({ min: 1, max: 100_000 }),
    nome: faker.company.name(),
    fantasia: faker.company.name(),
  };
}