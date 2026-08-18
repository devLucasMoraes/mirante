import { z } from "zod";

export const companySettingsSubject = z.tuple([
  z.union([
    z.literal("manage"),
    z.literal("read"),
    z.literal("update"),
  ]),
  z.literal("CompanySettings"),
]);