import mysql from "@fastify/mysql";
import type { FastifyInstance } from "fastify";
import fp from "fastify-plugin";

import { wingraphexConfig } from "../config.ts";

export interface WingraphexPluginOptions {
  pool?: Partial<typeof wingraphexConfig>;
}

export const wingraphexPlugin = fp<WingraphexPluginOptions>(
  async function (fastify: FastifyInstance, opts) {
    await fastify.register(mysql, {
      promise: true,
      ...wingraphexConfig,
      ...opts.pool,
    });

    fastify.decorate("wingraphex", fastify.mysql);

    fastify.addHook("onReady", async () => {
      try {
        await fastify.wingraphex.query("SELECT 1");
        fastify.log.info(
          { host: wingraphexConfig.host, port: wingraphexConfig.port },
          "Wingraphex MySQL connected",
        );
      } catch (err) {
        fastify.log.warn(
          { err, host: wingraphexConfig.host, port: wingraphexConfig.port },
          "Wingraphex MySQL unreachable - endpoints de consulta retornarao 503",
        );
      }
    });
  },
  { name: "wingraphex-mysql-connector" },
);