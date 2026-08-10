import type { FastifyError, FastifyInstance } from "fastify";

export class AppError extends Error {
  readonly statusCode: number;

  constructor(statusCode: number, message: string) {
    super(message);
    this.name = "AppError";
    this.statusCode = statusCode;
  }
}

export function isDuplicateKeyError(error: unknown): boolean {
  return (
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    error.code === 11000
  );
}

export function setErrorHandler(fastify: FastifyInstance): void {
  fastify.setErrorHandler<FastifyError>((error, request, reply) => {
    if (error instanceof AppError) {
      reply.status(error.statusCode).send({ message: error.message });
      return;
    }

    if (
      error.validation !== undefined ||
      (error.statusCode !== undefined && error.statusCode < 500)
    ) {
      reply.status(error.statusCode ?? 400).send({ message: error.message });
      return;
    }

    request.log.error({ err: error }, "unhandled error");
    reply.status(500).send({ message: "Erro interno do servidor" });
  });
}
