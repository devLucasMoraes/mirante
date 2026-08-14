import { Loader2, PackageSearch, Search, TriangleAlert } from "lucide-react";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@repo/ui/components/tooltip";
import { cn } from "@repo/ui/lib/utils";

import { getErrorMessage } from "@/lib/error-message";

import { OpsPagination } from "./ops-pagination";
import { formatCurrency, formatDate, formatQuantity } from "./wingraphex.format";
import type { NotaFaturamento, WingraphexOp } from "./wingraphex.schemas";

const SKELETON_CARDS = 6;

const STATUS_LABELS: Record<string, string> = {
  TSF_AFATURAR: "A faturar",
  TSF_FATURADA: "Faturada",
};

function StatusBadge({ status }: { status: string }) {
  const label = STATUS_LABELS[status] ?? status;

  if (status === "TSF_FATURADA") {
    return (
      <Badge
        variant="outline"
        className="border-emerald-500/30 bg-emerald-500/10 text-emerald-700 dark:text-emerald-400"
      >
        {label}
      </Badge>
    );
  }

  if (status === "TSF_AFATURAR") {
    return (
      <Badge
        variant="outline"
        className="border-amber-500/30 bg-amber-500/10 text-amber-700 dark:text-amber-400"
      >
        {label}
      </Badge>
    );
  }

  return <Badge variant="secondary">{label}</Badge>;
}

function Stat({
  label,
  value,
  hint,
  className,
}: {
  label: string;
  value: string;
  hint?: string;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "flex min-w-0 flex-col gap-0.5",
        className
      )}
    >
      <dt className="truncate text-[11px] font-medium uppercase tracking-wide text-muted-foreground">
        {label}
      </dt>
      <dd className="truncate text-sm font-medium text-foreground tabular-nums">
        {value}
        {hint ? (
          <span className="ml-1 text-xs font-normal text-muted-foreground">
            {hint}
          </span>
        ) : null}
      </dd>
    </div>
  );
}

function FooterGroupLabel({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <p
      className={cn(
        "text-[11px] font-semibold uppercase tracking-wide text-muted-foreground",
        className,
      )}
    >
      {children}
    </p>
  );
}

function formatNotaNumero(nota: NotaFaturamento): string {
  return nota.serie ? `${nota.serie} ${nota.numero}` : nota.numero;
}

function NotasList({ notas }: { notas: NotaFaturamento[] }) {
  if (notas.length === 0) {
    return <p className="text-sm text-muted-foreground">—</p>;
  }

  const visible = notas.slice(0, 2);
  const extraCount = notas.length - visible.length;

  const chips = (
    <div className="flex flex-wrap items-center gap-1.5">
      {visible.map((nota) => (
        <Badge key={formatNotaNumero(nota)} variant="outline" className="cursor-default">
          {formatNotaNumero(nota)}
        </Badge>
      ))}
      {extraCount > 0 ? (
        <Badge variant="outline" className="cursor-default">
          +{extraCount}
        </Badge>
      ) : null}
    </div>
  );

  if (notas.length === 1) {
    return chips;
  }

  return (
    <Tooltip>
      <TooltipTrigger asChild>{chips}</TooltipTrigger>
      <TooltipContent side="bottom" align="start">
        <ul className="flex flex-col gap-2">
          {notas.map((nota) => (
            <li key={formatNotaNumero(nota)} className="flex flex-col gap-0.5">
              <span className="font-medium">{formatNotaNumero(nota)}</span>
              <span className="text-muted-foreground">
                {nota.data ? formatDate(nota.data) : "—"} ·{" "}
                {formatQuantity(nota.quantidade)} un ·{" "}
                {formatCurrency(nota.valor)}
              </span>
            </li>
          ))}
        </ul>
      </TooltipContent>
    </Tooltip>
  );
}

function SkeletonCard() {
  return (
    <Card className="gap-3 py-4">
      <CardHeader className="flex items-center justify-between px-4">
        <div className="h-4 w-24 animate-pulse rounded bg-muted" />
        <div className="h-4 w-16 animate-pulse rounded bg-muted" />
      </CardHeader>
      <CardContent className="flex flex-col gap-2 px-4">
        <div className="h-4 w-full animate-pulse rounded bg-muted" />
        <div className="h-4 w-2/3 animate-pulse rounded bg-muted" />
        <div className="mt-1 h-4 w-40 animate-pulse rounded bg-muted" />
      </CardContent>
      <CardFooter className="flex-col gap-3 border-t px-4 pt-3">
        <div className="grid w-full grid-cols-2 gap-2 sm:grid-cols-4">
          {Array.from({ length: 4 }, (_, index) => (
            <div
              key={index}
              className="h-9 animate-pulse rounded bg-muted"
            />
          ))}
        </div>
        <div className="ml-auto h-4 w-40 animate-pulse rounded bg-muted" />
      </CardFooter>
    </Card>
  );
}

function OpCard({ op }: { op: WingraphexOp }) {
  return (
    <Card className="gap-3 py-4">
      <CardHeader className="flex items-start justify-between gap-4 px-4">
        <div className="flex min-w-0 flex-col gap-1">
          <div className="flex items-center gap-2">
            <span className="font-medium tabular-nums">OP {op.op}</span>
            <StatusBadge status={op.status} />
          </div>
          <p className="text-sm text-muted-foreground">
            Emissão:{" "}
            <time
              dateTime={op.data_emissao}
              className="whitespace-nowrap tabular-nums"
            >
              {formatDate(op.data_emissao)}
            </time>
          </p>
        </div>
        <dl className="shrink-0 text-right">
          <Stat
            label="Quantidade"
            value={formatQuantity(op.qtd_total)}
            className="items-end"
          />
        </dl>
      </CardHeader>

      <CardContent className="flex flex-col gap-1.5 px-4">
        <Tooltip>
          <TooltipTrigger asChild>
            <p className="line-clamp-2 text-sm font-medium text-foreground">
              {op.descricao || "—"}
            </p>
          </TooltipTrigger>
          <TooltipContent
            side="bottom"
            align="start"
            className="max-w-sm"
          >
            <p className="break-words whitespace-pre-line">
              {op.descricao}
            </p>
          </TooltipContent>
        </Tooltip>
        <p className="truncate text-sm text-muted-foreground">
          {op.cliente ?? "—"}
        </p>
      </CardContent>

      <CardFooter className="flex-col gap-4 border-t px-4 pt-3">
        <div className="grid w-full gap-x-8 gap-y-4 sm:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_auto] sm:items-start">
          <div className="flex min-w-0 flex-col gap-2">
            <FooterGroupLabel>Serviço</FooterGroupLabel>
            <dl className="flex flex-wrap items-end gap-x-6 gap-y-2">
              <Stat
                label="Valor do serviço"
                value={formatCurrency(op.valor_servico)}
              />
              <Stat label="Quantidade" value={formatQuantity(op.qtd_total)} />
              <Stat
                label="PCP"
                value={`${op.pcp.finalizados}/${op.pcp.processos}`}
                hint="finalizados/total"
              />
            </dl>
          </div>

          <div className="flex min-w-0 flex-col gap-2">
            <FooterGroupLabel>Faturamento</FooterGroupLabel>
            <dl className="flex flex-wrap items-end gap-x-6 gap-y-2">
              <Stat
                label="Valor faturado"
                value={formatCurrency(op.faturamento.valor_faturado)}
              />
              <Stat
                label="Quantidade"
                value={formatQuantity(op.faturamento.quantidade_faturada)}
              />
            </dl>
            <div className="flex items-center gap-1.5">
              <span className="text-[11px] font-medium uppercase tracking-wide text-muted-foreground">
                Nº da nota
              </span>
              <NotasList notas={op.faturamento.notas} />
            </div>
          </div>

          <div className="flex shrink-0 flex-col gap-2 text-right">
            <FooterGroupLabel className="text-right">Financeiro</FooterGroupLabel>
            <dl className="flex flex-col items-end gap-1.5 text-sm">
              <div className="flex items-baseline gap-1.5">
                <dt className="text-muted-foreground">Pago (baixado)</dt>
                <dd className="font-semibold tabular-nums">
                  {formatCurrency(op.financeiro.pago)}
                </dd>
              </div>
              <div className="flex items-baseline gap-1.5">
                <dt className="text-muted-foreground">A pagar</dt>
                <dd className="font-semibold tabular-nums">
                  {formatCurrency(op.financeiro.saldo)}
                </dd>
              </div>
            </dl>
          </div>
        </div>
      </CardFooter>
    </Card>
  );
}

export function OpsTable({
  hasCriteria,
  itens,
  total,
  pagina,
  totalPaginas,
  isPending,
  isFetching,
  isError,
  error,
  onRetry,
  onPageChange,
}: {
  hasCriteria: boolean;
  itens: WingraphexOp[] | undefined;
  total: number | undefined;
  pagina: number;
  totalPaginas: number | undefined;
  isPending: boolean;
  isFetching: boolean;
  isError: boolean;
  error: Error | null;
  onRetry: () => void;
  onPageChange: (page: number) => void;
}) {
  const totalCount = total ?? itens?.length ?? 0;

  const description = !hasCriteria
    ? "Digite uma descrição ou aplique um filtro para listar as OPs."
    : isFetching
      ? "Atualizando resultados..."
      : `${totalCount} ${totalCount === 1 ? "OP encontrada" : "OPs encontradas"}`;

  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between gap-2">
          <CardTitle>Resultados</CardTitle>
          {hasCriteria && !isPending && isFetching ? (
            <Loader2 className="size-4 animate-spin text-muted-foreground" />
          ) : null}
        </div>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent>
        {!hasCriteria ? (
          <div className="flex flex-col items-center gap-3 py-12 text-center text-sm text-muted-foreground">
            <Search className="size-8" />
            <div>
              <p className="font-medium text-foreground">
                Consulte as ordens de produção
              </p>
              <p className="mt-1">
                Busque por um termo na descrição ou use os filtros de cliente
                e período.
              </p>
            </div>
          </div>
        ) : isError ? (
          <div
            role="alert"
            className="flex flex-col items-start gap-3 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive sm:flex-row sm:items-center"
          >
            <div className="flex flex-1 items-center gap-2">
              <TriangleAlert className="size-4 shrink-0" />
              {getErrorMessage(error)}
            </div>
            <Button
              variant="outline"
              size="sm"
              onClick={onRetry}
              className="border-destructive/40 text-destructive hover:text-destructive"
            >
              Tentar novamente
            </Button>
          </div>
        ) : isPending ? (
          <div className="grid grid-cols-1 gap-4">
            {Array.from({ length: SKELETON_CARDS }, (_, index) => (
              <SkeletonCard key={index} />
            ))}
          </div>
        ) : totalCount === 0 ? (
          <div className="flex flex-col items-center gap-3 py-12 text-center text-sm text-muted-foreground">
            <PackageSearch className="size-8" />
            <div>
              <p className="font-medium text-foreground">
                Nenhuma OP encontrada
              </p>
              <p className="mt-1">
                Ajuste os filtros ou tente outro termo de descrição.
              </p>
            </div>
          </div>
        ) : (
          <>
            <TooltipProvider delayDuration={0}>
              <div className="grid grid-cols-1 gap-4">
                {itens?.map((op) => <OpCard key={op.op} op={op} />)}
              </div>
            </TooltipProvider>
            {(totalPaginas ?? 0) > 1 ? (
              <div className="mt-4 border-t border-border pt-4">
                <OpsPagination
                  pagina={pagina}
                  totalPaginas={totalPaginas ?? 1}
                  onPageChange={onPageChange}
                />
              </div>
            ) : null}
          </>
        )}
      </CardContent>
    </Card>
  );
}