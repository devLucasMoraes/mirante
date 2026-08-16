import { MongoMemoryServer } from "mongodb-memory-server";
import type { TestProject } from "vitest/node";

declare module "vitest" {
  interface ProvidedContext {
    MONGO_URI: string;
  }
}

let mongod: MongoMemoryServer | null = null;

export default async function setup(project: TestProject): Promise<() => Promise<void>> {
  mongod = await MongoMemoryServer.create();
  project.provide("MONGO_URI", mongod.getUri("").replace(/\/$/, ""));
  return async () => {
    await mongod?.stop();
  };
}