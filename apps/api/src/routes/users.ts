import { Types } from "mongoose";
import type { FastifyInstance } from "fastify";
import { AppError, isDuplicateKeyError } from "../errors.ts";
import { UserModel, toUserDTO } from "../models/User.ts";
import { hashPassword } from "../services/passwords.ts";
import { authenticate } from "../plugins/auth.ts";
import { getUserAbility, requireAbility, toUserSubject } from "../authorization.ts";
import {
  createUserSchema,
  updateUserSchema,
  userResponseSchema,
  zodFirstMessage,
} from "../schemas.ts";

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

export default async function usersRoutes(fastify: FastifyInstance) {
  fastify.addHook("preHandler", authenticate);

  fastify.get(
    "/users",
    {
      preHandler: requireAbility("read", "User"),
      schema: {
        response: {
          200: { type: "array", items: userResponseSchema },
        },
      },
    },
    async () => {
      const users = await UserModel.find().sort({ createdAt: -1 }).exec();
      return users.map(toUserDTO);
    },
  );

  fastify.post(
    "/users",
    {
      preHandler: requireAbility("create", "User"),
      schema: {
        response: { 201: userResponseSchema },
      },
    },
    async (request, reply) => {
      const parsed = createUserSchema.safeParse(request.body);
      if (!parsed.success) {
        throw new AppError(400, zodFirstMessage(parsed.error));
      }
      const { username, name, password, role } = parsed.data;
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

  fastify.patch(
    "/users/:id",
    {
      schema: {
        response: { 200: userResponseSchema },
      },
    },
    async (request) => {
      const parsed = updateUserSchema.safeParse(request.body);
      if (!parsed.success) {
        throw new AppError(400, zodFirstMessage(parsed.error));
      }
      const { id } = request.params as { id: string };
      const data = parsed.data;

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

  fastify.delete(
    "/users/:id",
    {
      preHandler: requireAbility("delete", "User"),
    },
    async (request, reply) => {
      const { id } = request.params as { id: string };
      if (request.user.id === id) {
        throw new AppError(400, "Você não pode excluir a si mesmo.");
      }
      await findUserOrThrow(id);
      await UserModel.deleteOne({ _id: id }).exec();
      return reply.status(204).send();
    },
  );
}
