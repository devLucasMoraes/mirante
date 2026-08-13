import { Loader2, PackageSearch, Search, TriangleAlert } from "lucide-react";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@repo/ui/components/table";

import { getErrorMessage } from "@/lib/error-message";

import { OpsPagination } from "./ops-pagination";
import { formatCurrency, formatDate, formatQuantity } from "./wingraphex.format";
import type { WingraphexOp } from "./wingraphex.schemas";

const SKELETON_ROWS = 5;

function SkeletonRow() {
  return (
    <TableRow>
      <TableCell>
        <div className="h-4 w-14 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell>
        <div className="h-4 w-40 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell>
        <div className="h-4 w-56 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell>
        <div className="h-4 w-20 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell className="text-right">
        <div className="ml-auto h-4 w-12 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell className="text-right">
        <div className="ml-auto h-4 w-20 animate-pulse rounded bg-muted" />
      </TableCell>
      <TableCell>
        <div className="h-4 w-16 animate-pulse rounded bg-muted" />
      </TableCell>
    </TableRow>
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
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-20">OP</TableHead>
                <TableHead>Cliente</TableHead>
                <TableHead>Descrição</TableHead>
                <TableHead>Data</TableHead>
                <TableHead className="text-right">Quantidade</TableHead>
                <TableHead className="text-right">Valor pago</TableHead>
                <TableHead>Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {Array.from({ length: SKELETON_ROWS }, (_, index) => (
                <SkeletonRow key={index} />
              ))}
            </TableBody>
          </Table>
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
            <div className="overflow-x-auto">
              <Table className="min-w-[760px]">
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-20">OP</TableHead>
                    <TableHead className="w-[22%]">Cliente</TableHead>
                    <TableHead className="w-[30%]">Descrição</TableHead>
                    <TableHead>Data</TableHead>
                    <TableHead className="text-right">Quantidade</TableHead>
                    <TableHead className="text-right">Valor pago</TableHead>
                    <TableHead>Status</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {itens?.map((op) => (
                    <TableRow key={op.op}>
                      <TableCell className="font-medium tabular-nums">
                        {op.op}
                      </TableCell>
                      <TableCell className="truncate font-medium">
                        {op.cliente ?? "—"}
                      </TableCell>
                      <TableCell
                        className="truncate text-muted-foreground"
                        title={op.descricao}
                      >
                        {op.descricao || "—"}
                      </TableCell>
                      <TableCell className="whitespace-nowrap tabular-nums text-muted-foreground">
                        {formatDate(op.data_emissao)}
                      </TableCell>
                      <TableCell className="text-right tabular-nums">
                        {formatQuantity(op.qtd_total)}
                      </TableCell>
                      <TableCell className="text-right font-medium tabular-nums">
                        {formatCurrency(op.valor_pago)}
                      </TableCell>
                      <TableCell>
                        {op.status ? (
                          <Badge variant="secondary">{op.status}</Badge>
                        ) : (
                          <span className="text-muted-foreground">—</span>
                        )}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
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