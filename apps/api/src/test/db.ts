import { inject } from "vitest";

export function getTestMongoUri(dbName: string): string {
  return `${inject("MONGO_URI")}/${dbName}`;
}