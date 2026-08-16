import cookie from "@fastify/cookie";
import cors from "@fastify/cors";
import helmet from "@fastify/helmet";
import jwt from "@fastify/jwt";
import type { MySQLPromisePool } from "@fastify/mysql";
import rateLimit from "@fastify/rate-limit";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";
import type { FastifyInstance } from "fastify";
import Fastify from "fastify";
import {
  jsonSchemaTransform,
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from "fastify-type-provider-zod";

import { config, mongoUri } from "./config.ts";
import { setErrorHandler } from "./lib/errors.ts";
import {
  authPlugin,
  mongoosePlugin,
  wingraphexPlugin,
} from "./plugins/index.ts";
import {
  authRoutes,
  entregaRoutes,
  healthRoutes,
  userRoutes,
  wingraphexRoutes,
} from "./routes/index.ts";

export interface CreateAppOptions {
  mongoUri?: string;
  wingraphex?: MySQLPromisePool;
  logger?: boolean;
}

export async function createApp(
  options: CreateAppOptions = {},
): Promise<FastifyInstance> {
  const fastify = Fastify({
    logger:
      options.logger === false
        ? false
        : {
            level: process.env.LOG_LEVEL ?? "debug",
            transport: {
              target: "pino-pretty",
              options: {
                colorize: true,
                levelFirst: true,
                translateTime: "SYS:yyyy-mm-dd HH:MM:ss.l",
                ignore: "pid,hostname",
                singleLine: true,
                customColors:
                  "trace:white,warn:yellow,info:cyan,debug:green,error:red,fatal:red,bgRed",
              },
            },
            serializers: {
              req(request) {
                return {
                  method: request.method,
                  url: request.url,
                  remoteAddress: request.ip,
                };
              },
              res(reply) {
                return { statusCode: reply.statusCode };
              },
            },
          },
  }).withTypeProvider<ZodTypeProvider>();

  fastify.setValidatorCompiler(validatorCompiler);
  fastify.setSerializerCompiler(serializerCompiler);

  await fastify.register(helmet);
  await fastify.register(cors, {
    origin: config.CORS_ORIGIN,
    credentials: true,
    methods: ["GET", "POST", "PATCH", "DELETE"],
  });
  await fastify.register(rateLimit, { max: 100, timeWindow: "1 minute" });
  await fastify.register(cookie, { secret: config.COOKIE_SECRET });

  await fastify.register(mongoosePlugin, {
    uri: options.mongoUri ?? mongoUri,
  });
  if (options.wingraphex !== undefined) {
    await fastify.register(wingraphexPlugin, {
      connection: options.wingraphex,
    });
  } else {
    await fastify.register(wingraphexPlugin);
  }
  await fastify.register(jwt, { secret: config.JWT_ACCESS_SECRET });
  await fastify.register(authPlugin, {
    refreshSecret: config.JWT_REFRESH_SECRET,
    refreshTtl: config.REFRESH_TOKEN_TTL,
  });

  await fastify.register(swagger, {
    openapi: {
      info: {
        title: "My Monorepo API",
        description: "API do monorepo com autenticação por cookies httpOnly",
        version: "1.0.0",
      },
      components: {
        securitySchemes: {
          cookieAuth: {
            type: "apiKey",
            in: "cookie",
            name: "access_token",
          },
        },
      },
    },
    transform: jsonSchemaTransform,
  });

  await fastify.register(swaggerUi, {
    routePrefix: "/api/docs",
  });

  await fastify.register(healthRoutes);
  await fastify.register(authRoutes, { prefix: "/api/auth" });
  await fastify.register(userRoutes, { prefix: "/api" });
  await fastify.register(entregaRoutes, { prefix: "/api/entregas" });
  await fastify.register(wingraphexRoutes, { prefix: "/api/wingraphex" });

  setErrorHandler(fastify);

  return fastify;
}