import { useMemo, useState } from "react";

import { FilePlus2, Search, SlidersHorizontal, X } from "lucide-react";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import { Input } from "@repo/ui/components/input";

import { useReciboPorOpQuery } from "@/features/entregas/entrega.queries";
import type { ReciboEntrega } from "@/features/entregas/entrega.schemas";
import { HistoricoDialog } from "@/features/entregas/historico-dialog";
import { ReciboAcoesDialog } from "@/features/entregas/recibo-acoes-dialog";
import { ReciboDialog } from "@/features/entregas/recibo-dialog";
import type { OpFilters } from "@/features/wingraphex/ops-filters-sheet";
import {
  EMPTY_FILTERS,
  OpsFiltersSheet,
} from "@/features/wingraphex/ops-filters-sheet";
import { OpsTable } from "@/features/wingraphex/ops-table";
import { useOpsQuery } from "@/features/wingraphex/wingraphex.queries";
import type { QueryOpsParams } from "@/features/wingraphex/wingraphex.schemas";

export function DashboardPage() {
  const [searchInput, setSearchInput] = useState("");
  const [descricao, setDescricao] = useState("");
  const [filters, setFilters] = useState<OpFilters>(EMPTY_FILTERS);
  const [sheetOpen, setSheetOpen] = useState(false);
  const [pagina, setPagina] = useState(1);
  const [selectedOps, setSelectedOps] = useState<ReadonlySet<number>>(new Set());
  const [reciboOpen, setReciboOpen] = useState(false);
  const [reciboGerado, setReciboGerado] = useState<ReciboEntrega | null>(null);
  const [historicoOp, setHistoricoOp] = useState<number | null>(null);

  const hasDateFilter = filters.dataInicio !== "" || filters.dataFim !== "";
  const hasCriteria =
    descricao.trim() !== "" ||
    filters.clienteId !== undefined ||
    hasDateFilter;
  const activeFilterCount =
    (filters.clienteId !== undefined ? 1 : 0) + (hasDateFilter ? 1 : 0);

  const params: QueryOpsParams = {
    descricao: descricao.trim() || undefined,
    clienteId: filters.clienteId,
    dataInicio: filters.dataInicio || undefined,
    dataFim: filters.dataFim || undefined,
    pagina,
  };
  const opsQuery = useOpsQuery(params);
  const opsItens = opsQuery.data?.itens;

  const opsPorId = useMemo(() => {
    const mapa = new Map<number, NonNullable<typeof opsItens>[number]>();
    for (const item of opsItens ?? []) {
      mapa.set(item.op, item);
    }
    return mapa;
  }, [opsItens]);

  const selecionadas = useMemo(
    () =>
      Array.from(selectedOps)
        .map((op) => opsPorId.get(op))
        .filter((item) => item !== undefined),
    [selectedOps, opsPorId],
  );

  const opHistorico = historicoOp !== null ? opsPorId.get(historicoOp) : undefined;
  const historicoQuery = useReciboPorOpQuery(historicoOp ?? 0);

  const handleSearch = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const term = searchInput.trim();
    setDescricao(term);
    setPagina(1);
    setSelectedOps(new Set());
  };

  const applyFilters = (next: OpFilters) => {
    setFilters(next);
    setPagina(1);
    setSelectedOps(new Set());
  };

  const handlePageChange = (page: number) => {
    setPagina(page);
    setSelectedOps(new Set());
  };

  const toggleSelect = (op: number) => {
    setSelectedOps((current) => {
      const next = new Set(current);
      if (next.has(op)) {
        next.delete(op);
      } else {
        next.add(op);
      }
      return next;
    });
  };

  const removeCliente = () => {
    setFilters((current) => ({
      ...current,
      clienteId: undefined,
      clienteNome: undefined,
    }));
    setPagina(1);
  };

  const removeData = () => {
    setFilters((current) => ({
      ...current,
      dataInicio: "",
      dataFim: "",
    }));
    setPagina(1);
  };

  const dateLabel =
    filters.dataInicio && filters.dataFim
      ? `${filters.dataInicio} — ${filters.dataFim}`
      : filters.dataInicio
        ? `A partir de ${filters.dataInicio}`
        : `Até ${filters.dataFim}`;

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">
            Ordens de produção
          </h1>
          <p className="mt-1 text-muted-foreground">
            Consulte as OPs pela descrição e refine por cliente e período.
          </p>
        </div>
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <form
          onSubmit={handleSearch}
          className="flex flex-1 gap-2"
          role="search"
        >
          <Input
            name="descricao"
            placeholder="Busque por um termo na descrição..."
            value={searchInput}
            onChange={(event) => setSearchInput(event.target.value)}
            className="flex-1"
          />
          <Button type="submit">
            <Search />
            Buscar
          </Button>
        </form>
        <Button
          type="button"
          variant="outline"
          onClick={() => setSheetOpen(true)}
          className="justify-between sm:w-auto"
        >
          <span className="flex items-center gap-2">
            <SlidersHorizontal />
            Filtros
          </span>
          {activeFilterCount > 0 ? (
            <span
              className="inline-flex size-5 items-center justify-center rounded-full bg-primary text-[11px] font-semibold text-primary-foreground"
              aria-label={`${activeFilterCount} filtro${
                activeFilterCount === 1 ? "" : "s"
              } ativo${activeFilterCount === 1 ? "" : "s"}`}
            >
              {activeFilterCount}
            </span>
          ) : null}
        </Button>
      </div>

      {activeFilterCount > 0 ? (
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-sm text-muted-foreground">Filtros ativos:</span>
          {filters.clienteId !== undefined ? (
            <Badge variant="secondary" className="gap-1 py-1 pr-1 pl-2">
              Cliente: {filters.clienteNome}
              <button
                type="button"
                aria-label="Remover filtro de cliente"
                onClick={removeCliente}
                className="flex items-center rounded-sm p-0.5 transition-opacity hover:opacity-70"
              >
                <X className="size-3" />
              </button>
            </Badge>
          ) : null}
          {hasDateFilter ? (
            <Badge variant="secondary" className="gap-1 py-1 pr-1 pl-2">
              Período: {dateLabel}
              <button
                type="button"
                aria-label="Remover filtro de período"
                onClick={removeData}
                className="flex items-center rounded-sm p-0.5 transition-opacity hover:opacity-70"
              >
                <X className="size-3" />
              </button>
            </Badge>
          ) : null}
        </div>
      ) : null}

      <OpsTable
        hasCriteria={hasCriteria}
        itens={opsQuery.data?.itens}
        total={opsQuery.data?.total}
        pagina={pagina}
        totalPaginas={opsQuery.data?.totalPaginas}
        isPending={opsQuery.isPending}
        isFetching={opsQuery.isFetching}
        isError={opsQuery.isError}
        error={opsQuery.error}
        selectedOps={selectedOps}
        onToggleSelect={toggleSelect}
        onHistorico={setHistoricoOp}
        onRetry={() => void opsQuery.refetch()}
        onPageChange={handlePageChange}
      />

      <OpsFiltersSheet
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        filters={filters}
        onApply={applyFilters}
      />

      {selecionadas.length > 0 ? (
        <div className="sticky bottom-4 z-20 flex items-center justify-between gap-3 rounded-lg border bg-background/95 px-4 py-3 shadow-lg backdrop-blur">
          <p className="text-sm text-muted-foreground">
            <span className="font-semibold text-foreground tabular-nums">
              {selecionadas.length}
            </span>{" "}
            OP{selecionadas.length === 1 ? "" : "s"} selecionada
            {selecionadas.length === 1 ? "" : "s"}.
          </p>
          <div className="flex items-center gap-2">
            <Button
              type="button"
              variant="outline"
              onClick={() => setSelectedOps(new Set())}
            >
              Limpar
            </Button>
            <Button type="button" onClick={() => setReciboOpen(true)}>
              <FilePlus2 />
              Gerar recibo
            </Button>
          </div>
        </div>
      ) : null}

      <ReciboDialog
        open={reciboOpen}
        onOpenChange={(open) => {
          setReciboOpen(open);
          if (!open) {
            setSelectedOps(new Set());
          }
        }}
        onSalvo={setReciboGerado}
        itens={selecionadas.map((item) => ({
          op: item.op,
          cliente: item.cliente,
          descricao: item.descricao,
          qtd_total: item.qtd_total,
          entregue: item.entregue,
        }))}
      />

      <ReciboAcoesDialog
        recibo={reciboGerado}
        open={reciboGerado !== null}
        onOpenChange={(open) => {
          if (!open) {
            setReciboGerado(null);
          }
        }}
      />

      <HistoricoDialog
        op={
          opHistorico
            ? {
                op: opHistorico.op,
                qtd_total: opHistorico.qtd_total,
                entregue: opHistorico.entregue,
              }
            : { op: 0, qtd_total: 0, entregue: 0 }
        }
        open={historicoOp !== null}
        onOpenChange={(open) => {
          if (!open) {
            setHistoricoOp(null);
          }
        }}
        recibos={historicoQuery.data}
        isPending={historicoQuery.isPending}
        isError={historicoQuery.isError}
        error={historicoQuery.error}
        onRetry={() => void historicoQuery.refetch()}
      />
    </div>
  );
}