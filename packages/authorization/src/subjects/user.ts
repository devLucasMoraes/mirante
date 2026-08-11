import { z } from "zod";

import { userSchema } from "../schemas.ts";

export const userSubject = z.tuple([
  z.union([
    z.literal("manage"),
    z.literal("read"),
    z.literal("create"),
    z.literal("update"),
    z.literal("delete"),
  ]),
  z.union([z.literal("User"), userSchema]),
]);