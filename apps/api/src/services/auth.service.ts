import { randomUUID } from "node:crypto";
import type { Types } from "mongoose";
import type { FastifyInstance } from "fastify";
import { config } from "../config.ts";
import { AppError } from "../lib/errors.ts";
import { RefreshTokenModel } from "../models/refresh-token.model.ts";
import { UserModel, toUserDTO } from "../models/user.model.ts";
import type {
  AuthService,
  AuthServiceOptions,
  JwtUser,
} from "../types/fastify.ts";
import { ttlToMs } from "./cookie.service.ts";
import { hashToken } from "./token.service.ts";

export function createAuthService(
  fastify: FastifyInstance,
  opts: AuthServiceOptions,
): AuthService {
  function signAccessToken(user: JwtUser): string {
    return fastify.jwt.sign(
      {
        id: user.id,
        username: user.username,
        name: user.name,
        role: user.role,
      },
      { expiresIn: config.ACCESS_TOKEN_TTL },
    );
  }

  async function issueRefreshToken(
    userId: Types.ObjectId,
    familyId: string,
  ): Promise<string> {
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
  }

  async function rotateRefreshToken(rawToken: string) {
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

    const newRawToken = await issueRefreshToken(user._id, existing.familyId);
    await existing.updateOne({
      $set: { revokedAt: new Date(), replacedBy: hashToken(newRawToken) },
    });

    return {
      accessToken: signAccessToken(toUserDTO(user)),
      refreshToken: newRawToken,
    };
  }

  async function revokeRefreshToken(
    rawToken: string | undefined,
  ): Promise<void> {
    if (rawToken === undefined) {
      return;
    }
    await RefreshTokenModel.updateOne(
      { tokenHash: hashToken(rawToken) },
      { $set: { revokedAt: new Date() } },
    ).exec();
  }

  return {
    signAccessToken,
    issueRefreshToken,
    rotateRefreshToken,
    revokeRefreshToken,
  };
}
