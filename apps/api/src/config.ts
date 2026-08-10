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
