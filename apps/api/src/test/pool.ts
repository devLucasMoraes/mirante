import type { MySQLPromisePool } from "@fastify/mysql";
import { vi } from "vitest";

export function createFakeWingraphexPool() {
  const query = vi.fn<WingraphexQuery>();
  const pool = { query } as unknown as MySQLPromisePool;
  return { pool, query };
}

type WingraphexQuery = (sql: string) => Promise<unknown[][]>;