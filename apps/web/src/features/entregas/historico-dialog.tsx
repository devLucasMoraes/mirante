import { useAbility } from "@casl/react";
import { FileDown, History, Loader2, Printer, Trash2, TriangleAlert } from "lucide-react";
import { toast } from "sonner";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@repo/ui/components/alert-dialog";
import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@repo/ui/components/dialog";

import { getErrorMessage } from "@/lib/error-message";

import { useDeleteReciboMutation } from "./entrega.queries";
import type { ReciboEntrega } from "./entrega.schemas";

async function baixarPdf(recibo: ReciboEntrega) {
  const { gerarPdfRecibo } = await import("./recibo-pdf");
  gerarPdfRecibo(recibo);
}

async function imprimirPdf(recibo: ReciboEntrega) {
  const { imprimirPdfRecibo } = await import("./recibo-pdf");
  imprimirPdfRecibo(recibo);
}

function formatDate(value: string): string {
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
  return new Intl.DateTimeFormat("pt-BR").format(new Date(year, month - 1, day));
}

function formatQuantity(value: number): string {
  return new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 0,
  }).format(value);
}

function formatCreatedAt(value: string): string {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  return new Intl.DateTimeFormat("pt-BR", {
    dateStyle: "short",
    timeStyle: "short",
  }).format(date);
}

export function HistoricoDialog({
  op,
  open,
  onOpenChange,
  recibos,
  isPending,
  isError,
  error,
  onRetry,
}: {
  op: { op: number; qtd_total: number; entregue: number };
  open: boolean;
  onOpenChange: (open: boolean) => void;
  recibos: ReciboEntrega[] | undefined;
  isPending: boolean;
  isError: boolean;
  error: Error | null;
  onRetry: () => void;
}) {
  const deleteMutation = useDeleteReciboMutation();
  const ability = useAbility();

  const itemDe = (recibo: ReciboEntrega) =>
    recibo.itens.find((item) => item.op === op.op);

  const handleDelete = (recibo: ReciboEntrega) => {
    deleteMutation.mutate(recibo.id, {
      onSuccess: () => {
        toast.success(`Recibo nº ${recibo.numero} excluído.`);
      },
      onError: (err) => toast.error(getErrorMessage(err)),
    });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-xl">
        <DialogHeader>
          <DialogTitle>Histórico de entregas — OP {op.op}</DialogTitle>
          <DialogDescription>
            Entregue{" "}
            <span className="font-semibold text-foreground">
              {formatQuantity(op.entregue)}
            </span>{" "}
            de {formatQuantity(op.qtd_total)} no total.
          </DialogDescription>
        </DialogHeader>

        <div className="flex flex-col gap-2">
          {isPending ? (
            <div className="flex items-center justify-center gap-2 py-8 text-sm text-muted-foreground">
              <Loader2 className="size-4 animate-spin" />
              Carregando histórico...
            </div>
          ) : isError ? (
            <div
              role="alert"
              className="flex items-center justify-between gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
            >
              <div className="flex items-center gap-2">
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
          ) : recibos === undefined || recibos.length === 0 ? (
            <div className="flex flex-col items-center gap-2 py-8 text-center text-sm text-muted-foreground">
              <History className="size-8" />
              <p>Nenhuma entrega registrada para esta OP.</p>
            </div>
          ) : (
            recibos.map((recibo) => {
              const item = itemDe(recibo);
              const podeExcluir = ability.can("delete", recibo);
              return (
                <div
                  key={recibo.id}
                  className="flex flex-col gap-2 rounded-md border p-3"
                >
                  <div className="flex items-center justify-between gap-2">
                    <div className="flex flex-wrap items-center gap-2">
                      <span className="font-medium tabular-nums">
                        Recibo #{recibo.numero}
                      </span>
                      <Badge variant="outline" className="cursor-default">
                        {formatQuantity(item?.quantidade ?? 0)} un
                      </Badge>
                    </div>
                    <div className="flex items-center gap-1">
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        className="h-8 text-muted-foreground"
                        onClick={() => void imprimirPdf(recibo)}
                      >
                        <Printer />
                        Imprimir
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        className="h-8 text-muted-foreground"
                        onClick={() => void baixarPdf(recibo)}
                      >
                        <FileDown />
                        PDF
                      </Button>
                      {podeExcluir ? (
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <Button
                              type="button"
                              variant="ghost"
                              size="icon"
                              className="size-8 text-muted-foreground hover:text-destructive"
                              aria-label={`Excluir recibo ${recibo.numero}`}
                            >
                              <Trash2 />
                            </Button>
                          </AlertDialogTrigger>
                          <AlertDialogContent size="sm">
                            <AlertDialogHeader>
                              <AlertDialogTitle>Excluir recibo nº {recibo.numero}?</AlertDialogTitle>
                              <AlertDialogDescription>
                                O recibo não pode mais ser editado e será removido do
                                histórico de entregas. Essa ação não pode ser desfeita.
                              </AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel disabled={deleteMutation.isPending}>
                                Cancelar
                              </AlertDialogCancel>
                              <AlertDialogAction
                                variant="destructive"
                                onClick={() => handleDelete(recibo)}
                                disabled={deleteMutation.isPending}
                              >
                                <Trash2 />
                                Excluir
                              </AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      ) : null}
                    </div>
                  </div>
                  <p className="text-sm text-muted-foreground">
                    {formatDate(recibo.dataEntrega)} · {recibo.usuario.nome}
                  </p>
                  <p className="line-clamp-2 text-sm">{item?.descricao ?? "—"}</p>
                  <p className="text-xs text-muted-foreground">
                    Gerado em {formatCreatedAt(recibo.createdAt)}
                  </p>
                </div>
              );
            })
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}