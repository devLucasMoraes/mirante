import { FileDown, Printer } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@repo/ui/components/dialog";

import type { ReciboEntrega } from "./entrega.schemas";

async function baixarPdf(recibo: ReciboEntrega) {
  const { gerarPdfRecibo } = await import("./recibo-pdf");
  gerarPdfRecibo(recibo);
}

async function imprimirPdf(recibo: ReciboEntrega) {
  const { imprimirPdfRecibo } = await import("./recibo-pdf");
  imprimirPdfRecibo(recibo);
}

function formatQuantity(value: number): string {
  return new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 0,
  }).format(value);
}

export function ReciboAcoesDialog({
  recibo,
  open,
  onOpenChange,
}: {
  recibo: ReciboEntrega | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>Recibo nº {recibo?.numero ?? ""} gerado</DialogTitle>
          <DialogDescription>
            O recibo foi salvo e não pode mais ser editado. Baixe ou imprima o PDF.
          </DialogDescription>
        </DialogHeader>

        {recibo ? (
          <div className="flex flex-col gap-3">
            <div className="flex flex-wrap gap-4 rounded-md border bg-muted/50 px-4 py-3 text-sm">
              <span>
                <span className="text-muted-foreground">Data de entrega: </span>
                <FormatDate value={recibo.dataEntrega} />
              </span>
              <span>
                <span className="text-muted-foreground">Responsável: </span>
                {recibo.usuario.nome}
              </span>
            </div>
            <ul className="flex flex-col gap-2">
              {recibo.itens.map((item) => (
                <li
                  key={item.op}
                  className="flex items-baseline justify-between gap-3 rounded-md border px-3 py-2 text-sm"
                >
                  <div className="flex min-w-0 flex-col gap-0.5">
                    <span className="font-medium tabular-nums">OP {item.op}</span>
                    <span className="line-clamp-2 text-muted-foreground">
                      {item.descricao}
                    </span>
                  </div>
                  <span className="shrink-0 font-semibold tabular-nums">
                    {formatQuantity(item.quantidade)}
                  </span>
                </li>
              ))}
            </ul>
          </div>
        ) : null}

        <DialogFooter>
          <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
            Fechar
          </Button>
          <Button type="button" onClick={() => void imprimirPdf(recibo!)}>
            <Printer />
            Imprimir
          </Button>
          <Button type="button" onClick={() => void baixarPdf(recibo!)}>
            <FileDown />
            Baixar PDF
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function FormatDate({ value }: { value: string }) {
  const [year, month, day] = value.split("-").map(Number);
  if (
    year === undefined ||
    month === undefined ||
    day === undefined ||
    Number.isNaN(year) ||
    Number.isNaN(month) ||
    Number.isNaN(day)
  ) {
    return <>{value}</>;
  }
  return (
    <>
      {new Intl.DateTimeFormat("pt-BR").format(new Date(year, month - 1, day))}
    </>
  );
}