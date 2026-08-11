import { Types } from "mongoose";
import type { FastifyInstance } from "fastify";
import type { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";
import { AppError, isDuplicateKeyError } from "../lib/errors.ts";
import { UserModel, toUserDTO } from "../models/user.model.ts";
import { hashPassword } from "../services/password.service.ts";
import { authenticate } from "../hooks/authenticate.hook.ts";
import { getUserAbility, requireAbility, toUserSubject } from "../lib/authorization.ts";
import {
  createUserSchema,
  updateUserSchema,
  userResponseSchema,
} from "../schemas/index.ts";

const userParamsSchema = z.object({
  id: z.string(),
});

async function findUserOrThrow(id: string) {
  if (!Types.ObjectId.isValid(id)) {
    throw new AppError(404, "Usuário não encontrado.");
  }
  const user = await UserModel.findById(id).exec();
  if (user === null) {
    throw new AppError(404, "Usuário não encontrado.");
  }
  return user;
}

export async function userRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.withTypeProvider<ZodTypeProvider>().get(
    "/users",
    {
      preHandler: requireAbility("read", "User"),
      schema: {
        response: {
          200: z.array(userResponseSchema),
        },
      },
    },
    async () => {
      const users = await UserModel.find().sort({ createdAt: -1 }).exec();
      return users.map(toUserDTO);
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().post(
    "/users",
    {
      preHandler: requireAbility("create", "User"),
      schema: {
        body: createUserSchema,
        response: { 201: userResponseSchema },
      },
    },
    async (request, reply) => {
      const { username, name, password, role } = request.body;
      const passwordHash = await hashPassword(password);

      try {
        const user = await UserModel.create({
          username,
          name,
          passwordHash,
          role,
        });
        return reply.status(201).send(toUserDTO(user));
      } catch (error) {
        if (isDuplicateKeyError(error)) {
          throw new AppError(409, "Já existe um usuário com esse nome.");
        }
        throw error;
      }
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().patch(
    "/users/:id",
    {
      schema: {
        body: updateUserSchema,
        params: userParamsSchema,
        response: { 200: userResponseSchema },
      },
    },
    async (request) => {
      const { id } = request.params;
      const data = request.body;

      const user = await findUserOrThrow(id);
      const ability = getUserAbility(request.user);
      const target = toUserSubject(toUserDTO(user));

      if (ability.cannot("update", target)) {
        throw new AppError(403, "Acesso restrito.");
      }
      if (data.username !== undefined && ability.cannot("update", target, "username")) {
        throw new AppError(403, "Acesso restrito.");
      }
      if (data.name !== undefined && ability.cannot("update", target, "name")) {
        throw new AppError(403, "Acesso restrito.");
      }
      if (data.role !== undefined && ability.cannot("update", target, "role")) {
        throw new AppError(403, "Acesso restrito.");
      }
      if (data.password !== undefined && ability.cannot("update", target, "password")) {
        throw new AppError(403, "Acesso restrito.");
      }

      if (data.username !== undefined) {
        user.username = data.username;
      }
      if (data.name !== undefined) {
        user.name = data.name;
      }
      if (data.role !== undefined) {
        user.role = data.role;
      }
      if (data.password !== undefined) {
        user.passwordHash = await hashPassword(data.password);
      }

      try {
        await user.save();
      } catch (error) {
        if (isDuplicateKeyError(error)) {
          throw new AppError(409, "Já existe um usuário com esse nome.");
        }
        throw error;
      }

      return toUserDTO(user);
    },
  );

  fastify.withTypeProvider<ZodTypeProvider>().delete(
    "/users/:id",
    {
      preHandler: requireAbility("delete", "User"),
      schema: {
        params: userParamsSchema,
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      if (request.user.id === id) {
        throw new AppError(400, "Você não pode excluir a si mesmo.");
      }
      await findUserOrThrow(id);
      await UserModel.deleteOne({ _id: id }).exec();
      return reply.status(204).send();
    },
  );
}
