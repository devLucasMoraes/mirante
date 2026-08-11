import { randomUUID } from "node:crypto";
import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";
import { AppError } from "../errors.ts";
import { UserModel, toUserDTO } from "../models/User.ts";
import { verifyPassword } from "../services/passwords.ts";
import { config } from "../config.ts";
import {
  COOKIE_NAMES,
  clearAuthCookies,
  getSignedCookie,
  setAuthCookies,
} from "../services/cookies.ts";
import { credentialsSchema, userResponseSchema } from "../schemas.ts";

export default async function authRoutes(fastify: FastifyInstance) {
  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/login",
    {
      config: { rateLimit: { max: 5, timeWindow: "1 minute" } },
      schema: {
        body: credentialsSchema,
        response: {
          200: z.object({
            user: userResponseSchema,
          }),
        },
      },
    },
    async (request, reply) => {
      const { username, password } = request.body;

      const user = await UserModel.findOne({ username })
        .select("+passwordHash")
        .exec();

      if (user === null || !(await verifyPassword(password, user.passwordHash))) {
        throw new AppError(401, "Credenciais inválidas.");
      }

      const familyId = randomUUID();
      const refreshToken = await fastify.authService.issueRefreshToken(
        user._id,
        familyId,
      );
      const userDTO = toUserDTO(user);

      setAuthCookies(reply, {
        accessToken: fastify.authService.signAccessToken(userDTO),
        refreshToken,
        accessTtl: config.ACCESS_TOKEN_TTL,
        refreshTtl: config.REFRESH_TOKEN_TTL,
      });

      return { user: userDTO };
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/refresh",
    {
      schema: {
        response: {
          204: z.void(),
        },
      },
    },
    async (request, reply) => {
      const refreshToken = getSignedCookie(request, COOKIE_NAMES.refresh);
      if (!refreshToken) {
        throw new AppError(401, "Refresh token ausente.");
      }

      const rotated = await fastify.authService.rotateRefreshToken(refreshToken);
      setAuthCookies(reply, {
        accessToken: rotated.accessToken,
        refreshToken: rotated.refreshToken,
        accessTtl: config.ACCESS_TOKEN_TTL,
        refreshTtl: config.REFRESH_TOKEN_TTL,
      });

      return reply.status(204).send();
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/logout",
    {
      schema: {
        response: {
          204: z.void(),
        },
      },
    },
    async (request, reply) => {
      const refreshToken = getSignedCookie(request, COOKIE_NAMES.refresh);
      await fastify.authService.revokeRefreshToken(refreshToken);
      clearAuthCookies(reply);
      return reply.status(204).send();
    },
  );
}
