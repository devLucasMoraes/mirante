import { useEffect, useMemo, useState } from "react";

import { Loader2, Plus, Trash2, TriangleAlert } from "lucide-react";
import { toast } from "sonner";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@repo/ui/components/dialog";
import { Input } from "@repo/ui/components/input";
import { Label } from "@repo/ui/components/label";
import { Textarea } from "@repo/ui/components/textarea";

import { getErrorMessage } from "@/lib/error-message";

import { useCreateReciboMutation } from "./entrega.queries";
import type { ReciboEntrega } from "./entrega.schemas";

type Linha = {
  op: number;
  cliente: string | null;
  descricao: string;
  quantidade: number;
  ultrapassa: boolean;
};

function todayString(): string {
  const now = new Date();
  const local = new Date(now.getTime() - now.getTimezoneOffset() * 60_000);
  return local.toISOString().slice(0, 10);
}

function formatQuantity(value: number): string {
  return new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 0,
  }).format(value);
}

export function ReciboDialog({
  open,
  onOpenChange,
  onSalvo,
  itens,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSalvo?: (recibo: ReciboEntrega) => void;
  itens: {
    op: number;
    cliente: string | null;
    descricao: string;
    qtd_total: number;
    entregue: number;
  }[];
}) {
  const createMutation = useCreateReciboMutation();
  const [dataEntrega, setDataEntrega] = useState(todayString());
  const [linhas, setLinhas] = useState<Linha[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (open) {
      setError(null);
      setDataEntrega(todayString());
      setLinhas(
        itens.map((item) => ({
          op: item.op,
          cliente: item.cliente,
          descricao: item.descricao,
          quantidade: Math.max(item.qtd_total - item.entregue, 0),
          ultrapassa: false,
        })),
      );
    }
  }, [open, itens]);

  const hasUltrapassa = useMemo(
    () => linhas.some((linha) => linha.ultrapassa),
    [linhas],
  );

  const setLinha = (op: number, patch: Partial<Omit<Linha, "op">>) => {
    setLinhas((current) => {
      const origem = current.find((linha) => linha.op === op);
      if (!origem) return current;
      return current.map((linha) => {
        if (linha.op !== op) return linha;
        const next = { ...linha, ...patch };
        const informacao = itens.find((item) => item.op === op);
        if (informacao && next.quantidade > 0) {
          next.ultrapassa =
            informacao.entregue + next.quantidade > informacao.qtd_total;
        }
        return next;
      });
    });
  };

  const removeLinha = (op: number) => {
    setLinhas((current) => current.filter((linha) => linha.op !== op));
  };

  const handleSubmit = () => {
    setError(null);

    const validas = linhas.filter((linha) => linha.op !== undefined);
    if (validas.length === 0) {
      setError("Selecione ao menos uma OP.");
      return;
    }
    if (!dataEntrega) {
      setError("Informe a data de entrega.");
      return;
    }
    const itensValidos = validas
      .map((linha) => ({
        op: linha.op,
        cliente: linha.cliente ?? undefined,
        descricao: linha.descricao.trim(),
        quantidade: linha.quantidade,
      }))
      .filter((item) => item.descricao !== "" && item.quantidade > 0);

    if (itensValidos.length === 0) {
      setError("Preencha descrição e quantidade de ao menos um item.");
      return;
    }

    createMutation.mutate(
      { dataEntrega, itens: itensValidos },
      {
        onSuccess: (recibo) => {
          toast.success(`Recibo nº ${recibo.numero} gerado com sucesso!`);
          onOpenChange(false);
          onSalvo?.(recibo);
        },
        onError: (err) => setError(getErrorMessage(err)),
      },
    );
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>Gerar recibo de entrega</DialogTitle>
          <DialogDescription>
            Revise a descrição e a quantidade de cada OP antes de gerar o recibo.
          </DialogDescription>
        </DialogHeader>

        {error ? (
          <div
            role="alert"
            className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
          >
            <TriangleAlert className="size-4 shrink-0" />
            {error}
          </div>
        ) : null}

        <div className="flex flex-col gap-4">
          <div className="space-y-2">
            <Label htmlFor="recibo-data-entrega">Data de entrega</Label>
            <Input
              id="recibo-data-entrega"
              type="date"
              value={dataEntrega}
              onChange={(event) => setDataEntrega(event.target.value)}
              disabled={createMutation.isPending}
            />
          </div>

          {hasUltrapassa ? (
            <div className="flex items-center gap-2 rounded-md border border-amber-500/40 bg-amber-500/10 px-3 py-2 text-sm text-amber-700 dark:text-amber-400">
              <TriangleAlert className="size-4 shrink-0" />
              Alguma OP recebeu mais do que a quantidade total cadastrada. Revise
              os valores ou prossiga mesmo assim.
            </div>
          ) : null}

          <div className="flex flex-col gap-2">
            <Label>Itens do recibo</Label>
            {linhas.length === 0 ? (
              <p className="rounded-md border border-dashed p-4 text-center text-sm text-muted-foreground">
                Nenhuma OP selecionada.
              </p>
            ) : (
              linhas.map((linha) => {
                const informacao = itens.find((item) => item.op === linha.op);
                return (
                  <div
                    key={linha.op}
                    className="flex flex-col gap-3 rounded-md border p-3"
                  >
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex min-w-0 items-center gap-2">
                        <span className="font-medium tabular-nums">OP {linha.op}</span>
                        {informacao ? (
                          <Badge variant="outline" className="cursor-default">
                            Entregue {formatQuantity(informacao.entregue)} de{" "}
                            {formatQuantity(informacao.qtd_total)}
                          </Badge>
                        ) : null}
                      </div>
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        className="size-8 text-muted-foreground hover:text-destructive"
                        onClick={() => removeLinha(linha.op)}
                        disabled={createMutation.isPending}
                        aria-label={`Remover OP ${linha.op}`}
                      >
                        <Trash2 />
                      </Button>
                    </div>

                    {linha.cliente ? (
                      <p className="truncate text-xs text-muted-foreground">
                        Cliente: {linha.cliente}
                      </p>
                    ) : null}

                    <div className="space-y-2">
                      <Label htmlFor={`recibo-descricao-${linha.op}`}>Descrição</Label>
                      <Textarea
                        id={`recibo-descricao-${linha.op}`}
                        value={linha.descricao}
                        onChange={(event) =>
                          setLinha(linha.op, { descricao: event.target.value })
                        }
                        rows={2}
                        disabled={createMutation.isPending}
                      />
                    </div>

                    <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:gap-3">
                      <Label
                        htmlFor={`recibo-quantidade-${linha.op}`}
                        className="sm:w-28 sm:shrink-0"
                      >
                        Quantidade
                      </Label>
                      <Input
                        id={`recibo-quantidade-${linha.op}`}
                        type="number"
                        min={0}
                        value={linha.quantidade}
                        onChange={(event) =>
                          setLinha(linha.op, {
                            quantidade: Number(event.target.value),
                          })
                        }
                        disabled={createMutation.isPending}
                        className="sm:max-w-40"
                      />
                      {linha.ultrapassa ? (
                        <span className="text-xs text-amber-600 dark:text-amber-400">
                          Aviso: soma passa do total da OP.
                        </span>
                      ) : null}
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>

        <DialogFooter>
          <Button
            type="button"
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={createMutation.isPending}
          >
            Cancelar
          </Button>
          <Button
            type="button"
            onClick={handleSubmit}
            disabled={createMutation.isPending || linhas.length === 0}
          >
            {createMutation.isPending ? (
              <>
                <Loader2 className="animate-spin" />
                Gerando...
              </>
            ) : (
              <>
                <Plus />
                Gerar recibo
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}