import path from "node:path";

const sharedMongosCache = path.resolve(
  import.meta.dirname,
  "../../../node_modules/.cache/mongodb-memory-server",
);

process.env.MONGOMS_DOWNLOAD_DIR ??= sharedMongosCache;

const fakeSecrets: Record<string, string> = {
  MONGO_INITDB_PASSWORD: "mongo-test-password",
  JWT_ACCESS_SECRET: "access-secret-tests-0123456789abcdef",
  JWT_REFRESH_SECRET: "refresh-secret-tests-0123456789abcdef",
  COOKIE_SECRET: "cookie-secret-tests-0123456789abcdef",
  WINGRAPHEX_DB_PASSWORD: "wingraphex-tests",
};

for (const [key, value] of Object.entries(fakeSecrets)) {
  process.env[key] = value;
}