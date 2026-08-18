import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";

import { authenticate } from "../hooks/authenticate.hook.ts";
import { requireAbility } from "../lib/authorization.ts";
import {
  companySettingsResponseSchema,
  updateCompanySettingsSchema,
} from "../schemas/index.ts";
import {
  getCompanySettings,
  updateCompanySettings,
} from "../services/index.ts";

export async function companySettingsRoutes(fastify: FastifyInstance) {
  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/settings",
    {
      schema: {
        response: { 200: companySettingsResponseSchema },
      },
    },
    async () => getCompanySettings(),
  );

  fastify.withTypeProvider<ZodTypeProvider>().patch(
    "/settings",
    {
      preHandler: [authenticate, requireAbility("update", "CompanySettings")],
      schema: {
        body: updateCompanySettingsSchema,
        response: { 200: companySettingsResponseSchema },
      },
    },
    async (request) => updateCompanySettings(request.body),
  );
}