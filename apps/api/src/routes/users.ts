import { Types } from "mongoose";
import type { FastifyInstance } from "fastify";
import { AppError, isDuplicateKeyError } from "../errors.ts";
import { UserModel, toUserDTO } from "../models/User.ts";
import { hashPassword } from "../services/passwords.ts";
import { authenticate, requireAdmin } from "../plugins/auth.ts";
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
  fastify.addHook("preHandler", requireAdmin);

  fastify.get(
    "/users",
    {
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

  fastify.delete("/users/:id", async (request, reply) => {
    const { id } = request.params as { id: string };
    if (request.user.id === id) {
      throw new AppError(400, "Você não pode excluir a si mesmo.");
    }
    await findUserOrThrow(id);
    await UserModel.deleteOne({ _id: id }).exec();
    return reply.status(204).send();
  });
}
