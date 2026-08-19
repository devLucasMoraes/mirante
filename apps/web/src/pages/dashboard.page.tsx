import { useEffect, useMemo, useState } from "react";

import { FilePlus2, Search, SlidersHorizontal, X } from "lucide-react";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import { Input } from "@repo/ui/components/input";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@repo/ui/components/tooltip";

import { useReciboPorOpQuery } from "@/features/entregas/entrega.queries";
import type { ReciboEntrega } from "@/features/entregas/entrega.schemas";
import { HistoricoDialog } from "@/features/entregas/historico-dialog";
import { ReciboAcoesDialog } from "@/features/entregas/recibo-acoes-dialog";
import { ReciboDialog } from "@/features/entregas/recibo-dialog";
import { useOpsFiltersStore } from "@/features/wingraphex/ops-filters.store";
import type { OpFilters } from "@/features/wingraphex/ops-filters-sheet";
import { OpsFiltersSheet } from "@/features/wingraphex/ops-filters-sheet";
import { useOpsSelectionStore } from "@/features/wingraphex/ops-selection.store";
import { OpsTable } from "@/features/wingraphex/ops-table";
import { empresaNome } from "@/features/wingraphex/wingraphex.format";
import { useOpsQuery } from "@/features/wingraphex/wingraphex.queries";
import type { QueryOpsParams } from "@/features/wingraphex/wingraphex.schemas";

export function DashboardPage() {
  const searchInput = useOpsFiltersStore((state) => state.searchInput);
  const descricao = useOpsFiltersStore((state) => state.descricao);
  const filters = useOpsFiltersStore((state) => state.filters);
  const pagina = useOpsFiltersStore((state) => state.pagina);
  const setSearchInput = useOpsFiltersStore((state) => state.setSearchInput);
  const applySearch = useOpsFiltersStore((state) => state.applySearch);
  const clearSearch = useOpsFiltersStore((state) => state.clearSearch);
  const applyStoredFilters = useOpsFiltersStore((state) => state.applyFilters);
  const removeClienteFilter = useOpsFiltersStore((state) => state.removeCliente);
  const removeEmpresaFilter = useOpsFiltersStore((state) => state.removeEmpresa);
  const removeDataFilter = useOpsFiltersStore((state) => state.removeData);
  const setPagina = useOpsFiltersStore((state) => state.setPagina);
  const irParaUltimaPagina = useOpsFiltersStore(
    (state) => state.irParaUltimaPagina,
  );
  const setIrParaUltimaPagina = useOpsFiltersStore(
    (state) => state.setIrParaUltimaPagina,
  );
  const selecionadas = useOpsSelectionStore((state) => state.selecionadas);
  const toggleSelection = useOpsSelectionStore((state) => state.toggle);
  const clearSelecionadas = useOpsSelectionStore((state) => state.clear);
  const [sheetOpen, setSheetOpen] = useState(false);
  const [reciboOpen, setReciboOpen] = useState(false);
  const [reciboGerado, setReciboGerado] = useState<ReciboEntrega | null>(null);
  const [historicoOp, setHistoricoOp] = useState<number | null>(null);

  const hasDateFilter = filters.dataInicio !== "" || filters.dataFim !== "";
  const hasCriteria =
    descricao.trim() !== "" ||
    filters.clienteId !== undefined ||
    hasDateFilter;
  const activeFilterCount =
    (filters.clienteId !== undefined ? 1 : 0) +
    (filters.empresa !== "ambas" ? 1 : 0) +
    (hasDateFilter ? 1 : 0);

  const params: QueryOpsParams = {
    descricao: descricao.trim() || undefined,
    empresa: filters.empresa,
    clienteId: filters.clienteId,
    dataInicio: filters.dataInicio || undefined,
    dataFim: filters.dataFim || undefined,
    ordenarPor: filters.ordenarPor,
    direcao: filters.direcao,
    pagina,
  };
  const opsQuery = useOpsQuery(params);
  const opsItens = opsQuery.data?.itens;

  useEffect(() => {
    if (!irParaUltimaPagina || opsQuery.data === undefined) {
      return;
    }
    const { totalPaginas } = opsQuery.data;
    if (totalPaginas > 0) {
      setPagina(totalPaginas);
    }
    setIrParaUltimaPagina(false);
  }, [irParaUltimaPagina, opsQuery.data, setPagina, setIrParaUltimaPagina]);

  const opsPorId = useMemo(() => {
    const mapa = new Map<number, NonNullable<typeof opsItens>[number]>();
    for (const item of opsItens ?? []) {
      mapa.set(item.op, item);
    }
    return mapa;
  }, [opsItens]);

  const selectedOps = useMemo(
    () => new Set(selecionadas.map((item) => item.op)),
    [selecionadas],
  );

  const opHistorico = historicoOp !== null ? opsPorId.get(historicoOp) : undefined;
  const historicoQuery = useReciboPorOpQuery(historicoOp ?? 0);

  const handleSearch = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const term = searchInput.trim();
    applySearch(term);
  };

  const handleClearSearch = () => {
    clearSearch();
  };

  const applyFilters = (next: OpFilters) => {
    applyStoredFilters(next);
  };

  const handlePageChange = (page: number) => {
    setPagina(page);
  };

  const toggleSelect = (op: number) => {
    const item = opsPorId.get(op);
    if (item) {
      toggleSelection({
        op: item.op,
        cliente: item.cliente,
        descricao: item.descricao,
        qtd_total: item.qtd_total,
        entregue: item.entregue,
      });
    }
  };

  const removeCliente = () => {
    removeClienteFilter();
  };

  const removeEmpresa = () => {
    removeEmpresaFilter();
  };

  const removeData = () => {
    removeDataFilter();
  };

  const empresaLabel =
    filters.empresa === "ambas" ? null : empresaNome(filters.empresa);

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
            Consulte as OPs pela descrição e refine por empresa, cliente e
            período.
          </p>
        </div>
      </div>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
        <form
          onSubmit={handleSearch}
          className="flex flex-1 gap-2"
          role="search"
        >
          <div className="relative flex-1">
            <Input
              name="descricao"
              placeholder="Busque por um termo na descrição..."
              value={searchInput}
              onChange={(event) => setSearchInput(event.target.value)}
              className="pr-9"
            />
            {searchInput !== "" ? (
              <TooltipProvider delayDuration={0}>
                <Tooltip>
                  <TooltipTrigger asChild>
                    <button
                      type="button"
                      aria-label="Limpar busca"
                      onClick={handleClearSearch}
                      className="absolute top-1/2 right-2 -translate-y-1/2 rounded-sm p-0.5 text-muted-foreground transition-opacity hover:opacity-70"
                    >
                      <X className="size-4" />
                    </button>
                  </TooltipTrigger>
                  <TooltipContent side="bottom">Limpar</TooltipContent>
                </Tooltip>
              </TooltipProvider>
            ) : null}
          </div>
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
          {empresaLabel !== null ? (
            <Badge variant="secondary" className="gap-1 py-1 pr-1 pl-2">
              Empresa: {empresaLabel}
              <button
                type="button"
                aria-label="Remover filtro de empresa"
                onClick={removeEmpresa}
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
              onClick={clearSelecionadas}
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
        onOpenChange={setReciboOpen}
        onSalvo={(recibo) => {
          setReciboGerado(recibo);
          clearSelecionadas();
        }}
        itens={selecionadas}
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