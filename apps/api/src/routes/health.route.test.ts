import { describe, expect, test } from "vitest";

import { createApp } from "../app.ts";
import { getTestMongoUri } from "../test/db.ts";
import { createFakeWingraphexPool } from "../test/pool.ts";

describe("GET /health", () => {
  test("reporta mongodb conectado e wingraphex disponível com pool injetado", async () => {
    const { pool, query } = createFakeWingraphexPool();
    query.mockResolvedValue([[], []]);

    const app = await createApp({
      mongoUri: getTestMongoUri("health"),
      wingraphex: pool,
      logger: false,
    });
    await app.ready();

    const response = await app.inject({ method: "GET", url: "/health" });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({
      status: "ok",
      db: 1,
      wingraphex: true,
    });
    expect(query).toHaveBeenCalledWith("SELECT 1");
  });
});