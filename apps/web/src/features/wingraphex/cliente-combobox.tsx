import { useEffect, useState } from "react";

import { Check, ChevronsUpDown, Loader2, X } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "@repo/ui/components/command";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@repo/ui/components/popover";
import { cn } from "@repo/ui/lib/utils";

import { useClientesQuery } from "./wingraphex.queries";
import type { WingraphexCliente } from "./wingraphex.schemas";

const MIN_TERM_LENGTH = 2;
const DEBOUNCE_MS = 300;

export function ClienteCombobox({
  value,
  onSelect,
}: {
  value: WingraphexCliente | null;
  onSelect: (cliente: WingraphexCliente | null) => void;
}) {
  const [open, setOpen] = useState(false);
  const [term, setTerm] = useState("");
  const [debouncedTerm, setDebouncedTerm] = useState("");

  useEffect(() => {
    if (!open) {
      setTerm("");
      setDebouncedTerm("");
      return;
    }
    const timer = setTimeout(() => setDebouncedTerm(term.trim()), DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [open, term]);

  const clientesQuery = useClientesQuery({ term: debouncedTerm });
  const loading = clientesQuery.isPending || clientesQuery.isFetching;
  const shouldSearch = debouncedTerm.length >= MIN_TERM_LENGTH;

  const handleSelect = (clienteId: string) => {
    const cliente =
      clientesQuery.data?.find((item) => String(item.id) === clienteId) ?? null;
    onSelect(cliente);
    setOpen(false);
  };

  const handleClear = (event: React.MouseEvent | React.KeyboardEvent) => {
    event.stopPropagation();
    event.preventDefault();
    onSelect(null);
  };

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          type="button"
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className={cn(
            "h-9 w-full justify-between font-normal",
            value === null && "text-muted-foreground",
          )}
        >
          <span className="truncate">{value?.nome ?? "Todos os clientes"}</span>
          {value !== null ? (
            <span
              role="button"
              tabIndex={0}
              aria-label="Limpar cliente selecionado"
              className="flex shrink-0 items-center rounded-sm opacity-60 transition-opacity hover:opacity-100 focus-visible:opacity-100 focus-visible:outline-none"
              onClick={handleClear}
              onKeyDown={(event) => {
                if (event.key === "Enter" || event.key === " ") {
                  handleClear(event);
                }
              }}
            >
              <X className="size-4" />
            </span>
          ) : (
            <ChevronsUpDown className="size-4 shrink-0 opacity-50" />
          )}
        </Button>
      </PopoverTrigger>

      <PopoverContent
        align="start"
        className="w-[var(--radix-popover-trigger-width)] p-0"
      >
        <Command shouldFilter={false}>
          <CommandInput
            placeholder="Buscar cliente por nome..."
            value={term}
            onValueChange={setTerm}
          />
          <CommandList>
            {!shouldSearch ? (
              <div className="py-6 text-center text-sm text-muted-foreground">
                Digite ao menos {MIN_TERM_LENGTH} caracteres para buscar.
              </div>
            ) : loading ? (
              <div className="flex items-center justify-center gap-2 py-6 text-sm text-muted-foreground">
                <Loader2 className="size-4 animate-spin" />
                Buscando...
              </div>
            ) : (clientesQuery.data?.length ?? 0) > 0 ? (
              <CommandGroup>
                {clientesQuery.data?.map((cliente) => (
                  <CommandItem
                    key={cliente.id}
                    value={String(cliente.id)}
                    onSelect={handleSelect}
                  >
                    <Check
                      className={cn(
                        "size-4 shrink-0",
                        value?.id === cliente.id
                          ? "opacity-100"
                          : "opacity-0",
                      )}
                    />
                    <span className="flex min-w-0 flex-col">
                      <span className="truncate">{cliente.nome}</span>
                      {cliente.fantasia !== "" &&
                      cliente.fantasia !== cliente.nome ? (
                        <span className="truncate text-xs text-muted-foreground">
                          {cliente.fantasia}
                        </span>
                      ) : null}
                    </span>
                  </CommandItem>
                ))}
              </CommandGroup>
            ) : (
              <CommandEmpty>Nenhum cliente encontrado</CommandEmpty>
            )}
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  );
}