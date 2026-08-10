import fp from "fastify-plugin";
import type { FastifyInstance } from "fastify";
import { config } from "../config.ts";
import { AppError } from "../errors.ts";

const SAFE_METHODS = new Set(["GET", "HEAD", "OPTIONS"]);

export default fp(
  async function csrfPlugin(fastify: FastifyInstance) {
    const allowedOrigins = new Set(
      config.CORS_ORIGIN.split(",")
        .map((origin) => origin.trim())
        .filter((origin) => origin !== ""),
    );

    fastify.addHook("onRequest", async (request) => {
      const method = request.method.toUpperCase();
      if (SAFE_METHODS.has(method)) {
        return;
      }

      const origin = request.headers.origin;
      if (origin !== undefined && origin !== "" && !allowedOrigins.has(origin)) {
        throw new AppError(403, "Origem bloqueada por proteção CSRF.");
      }
    });
  },
  { name: "csrf-plugin" },
);
