import { randomUUID } from "node:crypto";
import type { Types } from "mongoose";
import fp from "fastify-plugin";
import type { FastifyInstance, FastifyRequest } from "fastify";
import { config } from "../config.ts";
import { AppError } from "../errors.ts";
import { RefreshTokenModel } from "../models/RefreshToken.ts";
import { UserModel, toUserDTO } from "../models/User.ts";
import type { UserRole } from "../models/User.ts";
import { hashToken } from "../services/tokens.ts";
import { COOKIE_NAMES, getSignedCookie, ttlToMs } from "../services/cookies.ts";

export type JwtUser = {
  id: string;
  username: string;
  name: string;
  role: UserRole;
};

export interface AuthService {
  signAccessToken(user: JwtUser): string;
  issueRefreshToken(userId: Types.ObjectId, familyId: string): Promise<string>;
  rotateRefreshToken(
    rawToken: string,
  ): Promise<{ accessToken: string; refreshToken: string }>;
  revokeRefreshToken(rawToken: string | undefined): Promise<void>;
}

declare module "@fastify/jwt" {
  interface FastifyJWT {
    payload: JwtUser;
  }
}

declare module "fastify" {
  interface FastifyInstance {
    authService: AuthService;
  }
}

export async function authenticate(request: FastifyRequest): Promise<void> {
  const token = getSignedCookie(request, COOKIE_NAMES.access);
  if (!token) {
    throw new AppError(401, "Não autorizado. Token ausente.");
  }
  try {
    const payload = request.server.jwt.verify<JwtUser>(token);
    request.user = payload;
  } catch {
    throw new AppError(401, "Não autorizado. Token inválido ou expirado.");
  }
}

export async function requireAdmin(request: FastifyRequest): Promise<void> {
  if (request.user?.role !== "admin") {
    throw new AppError(403, "Acesso restrito ao administrador.");
  }
}

export default fp<{ refreshSecret: string; refreshTtl: string }>(
  async function authPlugin(fastify: FastifyInstance, opts) {
    const authService: AuthService = {
      signAccessToken(user: JwtUser): string {
        return fastify.jwt.sign(
          {
            id: user.id,
            username: user.username,
            name: user.name,
            role: user.role,
          },
          { expiresIn: config.ACCESS_TOKEN_TTL },
        );
      },

      async issueRefreshToken(userId, familyId): Promise<string> {
        const payload = {
          id: String(userId),
          jti: randomUUID(),
        } as unknown as JwtUser;
        const rawToken = fastify.jwt.sign(payload, {
          key: opts.refreshSecret,
          expiresIn: opts.refreshTtl,
        });
        await RefreshTokenModel.create({
          tokenHash: hashToken(rawToken),
          familyId,
          userId,
          expiresAt: new Date(Date.now() + ttlToMs(opts.refreshTtl)),
        });
        return rawToken;
      },

      async rotateRefreshToken(rawToken) {
        let payload: { id: string; jti: string };
        try {
          payload = fastify.jwt.verify<{ id: string; jti: string }>(rawToken, {
            key: opts.refreshSecret,
          });
        } catch {
          throw new AppError(401, "Refresh token inválido ou expirado.");
        }

        const tokenHash = hashToken(rawToken);
        const existing = await RefreshTokenModel.findOne({ tokenHash }).exec();

        if (existing === null) {
          throw new AppError(401, "Refresh token inválido.");
        }

        if (existing.revokedAt !== null) {
          await RefreshTokenModel.updateMany(
            { familyId: existing.familyId },
            { $set: { revokedAt: new Date() } },
          ).exec();
          throw new AppError(403, "Sessão revogada por reuso de token.");
        }

        if (existing.expiresAt.getTime() <= Date.now()) {
          throw new AppError(401, "Refresh token expirado.");
        }

        const user = await UserModel.findById(payload.id).exec();
        if (user === null) {
          throw new AppError(401, "Usuário não encontrado.");
        }

        const newRawToken = await this.issueRefreshToken(
          user._id,
          existing.familyId,
        );
        await existing.updateOne({
          $set: { revokedAt: new Date(), replacedBy: hashToken(newRawToken) },
        });

        return {
          accessToken: this.signAccessToken(toUserDTO(user)),
          refreshToken: newRawToken,
        };
      },

      async revokeRefreshToken(rawToken) {
        if (rawToken === undefined) {
          return;
        }
        await RefreshTokenModel.updateOne(
          { tokenHash: hashToken(rawToken) },
          { $set: { revokedAt: new Date() } },
        ).exec();
      },
    };

    fastify.decorate("authService", authService);
  },
  { name: "auth-plugin" },
);
