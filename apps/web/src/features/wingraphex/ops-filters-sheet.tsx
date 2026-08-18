import { useEffect, useState } from "react";

import { TriangleAlert } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import { Input } from "@repo/ui/components/input";
import { Label } from "@repo/ui/components/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@repo/ui/components/select";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@repo/ui/components/sheet";

import { ClienteCombobox } from "./cliente-combobox";
import { empresaNome } from "./wingraphex.format";
import type { EmpresaFilter } from "./wingraphex.schemas";

export type OrdenacaoOps = "emissao" | "prevista";
export type DirecaoOps = "asc" | "desc";

export type OpFilters = {
  empresa: EmpresaFilter;
  clienteId?: number;
  clienteNome?: string;
  clienteFantasia?: string;
  dataInicio: string;
  dataFim: string;
  ordenarPor: OrdenacaoOps;
  direcao: DirecaoOps;
};

export const EMPTY_FILTERS: OpFilters = {
  empresa: "ambas",
  dataInicio: "",
  dataFim: "",
  ordenarPor: "emissao",
  direcao: "desc",
};

export function OpsFiltersSheet({
  open,
  onOpenChange,
  filters,
  onApply,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  filters: OpFilters;
  onApply: (filters: OpFilters) => void;
}) {
  const [draft, setDraft] = useState<OpFilters>(filters);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (open) {
      setDraft(filters);
      setError(null);
    }
  }, [open, filters]);

  const set = (field: keyof OpFilters) => (value: string) =>
    setDraft((current) => ({ ...current, [field]: value }));

  const handleApply = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);
    if (draft.dataInicio && draft.dataFim && draft.dataInicio > draft.dataFim) {
      setError("A data final deve ser maior ou igual à data inicial.");
      return;
    }
    onApply(draft);
    onOpenChange(false);
  };

  const handleClear = () => {
    const empty = EMPTY_FILTERS;
    setDraft(empty);
    setError(null);
    onApply(empty);
    onOpenChange(false);
  };

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="sm:max-w-md">
        <SheetHeader>
          <SheetTitle>Filtros</SheetTitle>
          <SheetDescription>
            Refine a busca por empresa, cliente, período e ordenação. O período
            segue a ordenação escolhida (emissão ou data prevista).
          </SheetDescription>
        </SheetHeader>

        {error ? (
          <div
            role="alert"
            className="mx-4 flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
          >
            <TriangleAlert className="size-4 shrink-0" />
            {error}
          </div>
        ) : null}

        <form
          id="ops-filters-form"
          onSubmit={handleApply}
          className="space-y-4 px-4"
        >
          <div className="space-y-2">
            <Label>Empresa</Label>
            <Select
              value={draft.empresa}
              onValueChange={(value) =>
                setDraft((current) => ({
                  ...current,
                  empresa: value as EmpresaFilter,
                }))
              }
            >
              <SelectTrigger id="ops-empresa" className="w-full">
                <SelectValue placeholder="Empresa" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ambas">{empresaNome("ambas")}</SelectItem>
                <SelectItem value="1">{empresaNome("1")}</SelectItem>
                <SelectItem value="2">{empresaNome("2")}</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-2">
            <Label htmlFor="cliente-combobox">Cliente</Label>
            <div id="cliente-combobox">
              <ClienteCombobox
                value={
                  draft.clienteId !== undefined
                    ? {
                        id: draft.clienteId,
                        nome: draft.clienteNome ?? "",
                        fantasia: draft.clienteFantasia ?? "",
                      }
                    : null
                }
                empresa={draft.empresa}
                onSelect={(cliente) =>
                  setDraft((current) => ({
                    ...current,
                    clienteId: cliente?.id,
                    clienteNome: cliente?.nome,
                    clienteFantasia: cliente?.fantasia,
                  }))
                }
              />
            </div>
          </div>

          <div className="space-y-2">
            <Label>
              {draft.ordenarPor === "prevista"
                ? "Período da data prevista"
                : "Período de emissão"}
            </Label>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label
                  htmlFor="ops-data-inicio"
                  className="text-xs font-normal text-muted-foreground"
                >
                  De
                </Label>
                <Input
                  id="ops-data-inicio"
                  type="date"
                  value={draft.dataInicio}
                  max={draft.dataFim || undefined}
                  onChange={(event) => set("dataInicio")(event.target.value)}
                />
              </div>
              <div className="space-y-2">
                <Label
                  htmlFor="ops-data-fim"
                  className="text-xs font-normal text-muted-foreground"
                >
                  Até
                </Label>
                <Input
                  id="ops-data-fim"
                  type="date"
                  value={draft.dataFim}
                  min={draft.dataInicio || undefined}
                  onChange={(event) => set("dataFim")(event.target.value)}
                />
              </div>
            </div>
          </div>

          <div className="space-y-2">
            <Label>Ordenação</Label>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label
                  htmlFor="ops-ordem-campo"
                  className="text-xs font-normal text-muted-foreground"
                >
                  Ordenar por
                </Label>
                <Select
                  value={draft.ordenarPor}
                  onValueChange={(value) =>
                    setDraft((current) => ({
                      ...current,
                      ordenarPor: value as OrdenacaoOps,
                    }))
                  }
                >
                  <SelectTrigger id="ops-ordem-campo" className="w-full">
                    <SelectValue placeholder="Ordenar por" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="emissao">Emissão</SelectItem>
                    <SelectItem value="prevista">Data prevista</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label
                  htmlFor="ops-ordem-direcao"
                  className="text-xs font-normal text-muted-foreground"
                >
                  Direção
                </Label>
                <Select
                  value={draft.direcao}
                  onValueChange={(value) =>
                    setDraft((current) => ({
                      ...current,
                      direcao: value as DirecaoOps,
                    }))
                  }
                >
                  <SelectTrigger id="ops-ordem-direcao" className="w-full">
                    <SelectValue placeholder="Direção" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="asc">Crescente</SelectItem>
                    <SelectItem value="desc">Decrescente</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
          </div>
        </form>

        <SheetFooter>
          <Button type="submit" form="ops-filters-form" className="w-full">
            Aplicar filtros
          </Button>
          <Button
            type="button"
            variant="outline"
            onClick={handleClear}
            className="w-full"
          >
            Limpar filtros
          </Button>
          <Button
            type="button"
            variant="ghost"
            onClick={() => onOpenChange(false)}
            className="w-full"
          >
            Cancelar
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}