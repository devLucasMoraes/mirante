import { existsSync } from "node:fs";
import path from "node:path";
import dotenv from "dotenv";
import { z } from "zod";

const rootEnvFile = path.resolve(
  import.meta.dirname,
  `../../../.env.${process.env.NODE_ENV ?? "development"}`,
);

if (existsSync(rootEnvFile)) {
  dotenv.config({ path: rootEnvFile });
}

const envSchema = z.object({
  MONGODB_PORT: z.coerce.number().default(27017),
  MONGO_INITDB_DATABASE: z.string().min(1).default("my_monorepo"),
  MONGO_INITDB_USERNAME: z.string().min(1).default("app"),
  MONGO_INITDB_PASSWORD: z.string().min(1),
  PORT: z.coerce.number().default(3000),
  HOST: z.string().default("0.0.0.0"),
  JWT_ACCESS_SECRET: z.string().min(32),
  JWT_REFRESH_SECRET: z.string().min(32),
  ACCESS_TOKEN_TTL: z.string().min(1).default("15m"),
  REFRESH_TOKEN_TTL: z.string().min(1).default("7d"),
  COOKIE_SECRET: z.string().min(32),
  COOKIE_SECURE: z.coerce.boolean().default(process.env.NODE_ENV === "production"),
  CORS_ORIGIN: z.string().default("http://localhost:5173"),
  BCRYPT_ROUNDS: z.coerce.number().int().min(4).max(15).default(12),
  SEED_ADMIN_USERNAME: z.string().min(3).default("admin"),
  SEED_ADMIN_NAME: z.string().min(1).default("Administrador"),
  SEED_ADMIN_PASSWORD: z.string().min(6).default("admin123"),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  const details = parsed.error.issues
    .map((issue) => `  - ${issue.path.join(".")}: ${issue.message}`)
    .join("\n");
  throw new Error(`Invalid environment variables:\n${details}`);
}

export const config = parsed.data;

export const mongoUri = `mongodb://${config.MONGO_INITDB_USERNAME}:${config.MONGO_INITDB_PASSWORD}@127.0.0.1:${config.MONGODB_PORT}/${config.MONGO_INITDB_DATABASE}?authSource=${config.MONGO_INITDB_DATABASE}`;
