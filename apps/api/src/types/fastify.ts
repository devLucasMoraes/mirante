import type { Types } from "mongoose";
import type { UserRole } from "../models/user.model.ts";

export type JwtUser = {
  id: string;
  username: string;
  name: string;
  role: UserRole;
};

export interface AuthServiceOptions {
  refreshSecret: string;
  refreshTtl: string;
}

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
