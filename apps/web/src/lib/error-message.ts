import { AxiosError } from "axios";

export function getErrorMessage(error: unknown): string {
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