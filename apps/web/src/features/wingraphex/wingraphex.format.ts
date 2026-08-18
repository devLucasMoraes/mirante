import type { EmpresaFilter } from "./wingraphex.schemas";

const currencyFormatter = new Intl.NumberFormat("pt-BR", {
  style: "currency",
  currency: "BRL",
});

const dateFormatter = new Intl.DateTimeFormat("pt-BR");

const quantityFormatter = new Intl.NumberFormat("pt-BR", {
  maximumFractionDigits: 0,
});

export function formatCurrency(value: number): string {
  return currencyFormatter.format(value);
}

export function formatDate(value: string): string {
  const [year, month, day] = value.split("-").map(Number);
  if (
    year === undefined ||
    month === undefined ||
    day === undefined ||
    Number.isNaN(year) ||
    Number.isNaN(month) ||
    Number.isNaN(day)
  ) {
    return value || "—";
  }
  return dateFormatter.format(new Date(year, month - 1, day));
}

export function formatQuantity(value: number): string {
  return quantityFormatter.format(value);
}

const EMPRESA_NOME: Record<EmpresaFilter, string> = {
  ambas: "Ambas",
  1: "Gráfica Plantão",
  2: "Editora Esquivel",
};

export function empresaNome(empresa: EmpresaFilter | number): string {
  return EMPRESA_NOME[String(empresa) as EmpresaFilter] ?? "Empresa";
}
