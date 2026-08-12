import { AxiosError } from "axios";
import { ZodError } from "zod";

export function getErrorMessage(error: unknown): string {
  if (error instanceof ZodError) {
    return error.issues
      .map((issue) => `${issue.path.join(".") || "valor"}: ${issue.message}`)
      .join(" | ");
  }
  if (error instanceof AxiosError) {
    const data: unknown = error.response?.data;
    if (typeof data === "object" && data !== null && "message" in data) {
      return String(data.message);
    }
    return error.message;
  }
  if (error instanceof Error) {
    return error.message;
  }
  return "Ocorreu um erro inesperado";
}