import { Check } from "lucide-react";

import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@repo/ui/components/tooltip";
import { cn } from "@repo/ui/lib/utils";

import type { PcpSetorProgresso } from "./wingraphex.schemas";

const STEP_CLIP_PATH =
  "polygon(0 0, calc(100% - 10px) 0, 100% 50%, calc(100% - 10px) 100%, 0 100%, 10px 50%)";

export function PcpSteps({ setores }: { setores: PcpSetorProgresso[] }) {
  if (setores.length === 0) {
    return <span className="text-sm text-muted-foreground">—</span>;
  }

  return (
    <div className="flex flex-wrap items-center gap-y-2">
      {setores.map((setor) => (
        <Tooltip key={setor.id}>
          <TooltipTrigger asChild>
            <span
              aria-label={`${setor.nome}: ${setor.finalizados}/${setor.processos} finalizados`}
              style={{ clipPath: STEP_CLIP_PATH }}
              className={cn(
                "flex h-7 min-w-9 items-center justify-center gap-1 px-3 text-xs font-semibold",
                "ml-[-10px] first:ml-0",
                setor.finalizado
                  ? "bg-emerald-500/15 text-emerald-700 dark:text-emerald-400"
                  : "bg-muted text-muted-foreground",
              )}
            >
              {setor.finalizado ? <Check className="size-3.5 shrink-0" /> : null}
              <span className="whitespace-nowrap">{setor.nome}</span>
            </span>
          </TooltipTrigger>
          <TooltipContent side="bottom" align="start">
            <p>
              {setor.nome}: {setor.finalizados}/{setor.processos} finalizados
            </p>
          </TooltipContent>
        </Tooltip>
      ))}
    </div>
  );
}