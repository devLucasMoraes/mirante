import { useEffect, useState } from "react";

import { TriangleAlert } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import { Input } from "@repo/ui/components/input";
import { Label } from "@repo/ui/components/label";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@repo/ui/components/sheet";

import { ClienteCombobox } from "./cliente-combobox";

export type OpFilters = {
  clienteId?: number;
  clienteNome?: string;
  dataInicio: string;
  dataFim: string;
};

export const EMPTY_FILTERS: OpFilters = {
  dataInicio: "",
  dataFim: "",
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
            Refine a busca por cliente e por período de emissão.
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
            <Label htmlFor="cliente-combobox">Cliente</Label>
            <div id="cliente-combobox">
              <ClienteCombobox
                value={
                  draft.clienteId !== undefined
                    ? { id: draft.clienteId, nome: draft.clienteNome ?? "" }
                    : null
                }
                onSelect={(cliente) =>
                  setDraft((current) => ({
                    ...current,
                    clienteId: cliente?.id,
                    clienteNome: cliente?.nome,
                  }))
                }
              />
            </div>
          </div>

          <div className="space-y-2">
            <Label>Período</Label>
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