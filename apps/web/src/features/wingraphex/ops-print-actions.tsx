import { useEffect, useState } from "react";

import { FileDown, Loader2, Printer } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@repo/ui/components/button";

import { getErrorMessage } from "@/lib/error-message";

import type { ImpressaoOpsContexto } from "./ops-pdf";
import { useOpsImpressaoQuery } from "./wingraphex.queries";
import type { QueryOpsImpressaoParams } from "./wingraphex.schemas";

export function OpsPrintButtons({
  params,
  contexto,
}: {
  params: QueryOpsImpressaoParams;
  contexto: ImpressaoOpsContexto;
}) {
  const [acao, setAcao] = useState<null | "imprimir" | "baixar">(null);
  const opsQuery = useOpsImpressaoQuery(params, acao !== null);
  const itens = opsQuery.data;
  const busy = opsQuery.isFetching && acao !== null;

  useEffect(() => {
    if (acao === null) {
      return;
    }
    if (opsQuery.isError) {
      toast.error(getErrorMessage(opsQuery.error));
      setAcao(null);
      return;
    }
    if (itens === undefined) {
      return;
    }
    const action = acao;
    setAcao(null);
    void (async () => {
      const { imprimirPdfOps, gerarPdfOps } = await import("./ops-pdf");
      if (action === "imprimir") {
        imprimirPdfOps(itens, contexto);
      } else {
        gerarPdfOps(itens, contexto);
      }
    })();
  }, [acao, itens, opsQuery.isError, opsQuery.error, contexto]);

  return (
    <>
      <Button
        type="button"
        variant="outline"
        size="sm"
        disabled={busy}
        onClick={() => setAcao("imprimir")}
      >
        {busy ? <Loader2 className="size-4 animate-spin" /> : <Printer />}
        Imprimir
      </Button>
      <Button
        type="button"
        variant="outline"
        size="sm"
        disabled={busy}
        onClick={() => setAcao("baixar")}
      >
        <FileDown />
        Baixar PDF
      </Button>
    </>
  );
}