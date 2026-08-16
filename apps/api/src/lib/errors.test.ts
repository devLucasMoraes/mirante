import { describe, expect, test } from "vitest";

import { AppError, isDuplicateKeyError } from "./errors.ts";

describe("AppError", () => {
  test("carrega statusCode, message e name", () => {
    const error = new AppError(404, "Recibo não encontrado.");
    expect(error.statusCode).toBe(404);
    expect(error.message).toBe("Recibo não encontrado.");
    expect(error.name).toBe("AppError");
    expect(error).toBeInstanceOf(Error);
  });
});

describe("isDuplicateKeyError", () => {
  test("reconhece erro de chave duplicada do MongoDB", () => {
    expect(isDuplicateKeyError({ code: 11000 })).toBe(true);
  });

  test("ignora erros sem code 11000", () => {
    expect(isDuplicateKeyError({ code: 66 })).toBe(false);
    expect(isDuplicateKeyError(null)).toBe(false);
    expect(isDuplicateKeyError("erro")).toBe(false);
  });
});