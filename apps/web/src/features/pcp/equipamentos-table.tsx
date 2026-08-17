import { Fragment, useMemo, useState } from "react";

import { useAbility } from "@casl/react";
import { Loader2, TriangleAlert } from "lucide-react";
import { toast } from "sonner";

import { Badge } from "@repo/ui/components/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@repo/ui/components/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@repo/ui/components/table";

import { getErrorMessage } from "@/lib/error-message";

import {
  useEquipamentosQuery,
  useSetoresQuery,
  useVincularEquipamentoMutation,
} from "./pcp.queries";
import type { EquipamentoComSetor } from "./pcp.schemas";

const SEM_SETOR_VALUE = "__sem_setor__";

function EquipamentoRow({
  equipamento,
  setores,
  canManage,
  isPending,
  onChange,
}: {
  equipamento: EquipamentoComSetor;
  setores: { id: string; nome: string }[];
  canManage: boolean;
  isPending: boolean;
  onChange: (codigo: number, setorId: string | null) => void;
}) {
  const valor = equipamento.setorId ?? SEM_SETOR_VALUE;

  return (
    <TableRow>
      <TableCell className="font-medium tabular-nums">
        {equipamento.codigo}
      </TableCell>
      <TableCell className="max-w-0 truncate">{equipamento.nome}</TableCell>
      <TableCell>
        {canManage ? (
          <Select
            value={valor}
            onValueChange={(proximo) =>
              onChange(
                equipamento.codigo,
                proximo === SEM_SETOR_VALUE ? null : proximo,
              )
            }
            disabled={isPending}
          >
            <SelectTrigger size="sm" className="w-full min-w-40" aria-label={`Setor do equipamento ${equipamento.codigo}`}>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={SEM_SETOR_VALUE}>Sem categoria</SelectItem>
              {setores.map((setor) => (
                <SelectItem key={setor.id} value={setor.id}>
                  {setor.nome}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        ) : (
          <Badge variant="outline">
            {equipamento.setorId === null
              ? "Sem categoria"
              : (setores.find((setor) => setor.id === equipamento.setorId)
                  ?.nome ?? "Sem categoria")}
          </Badge>
        )}
      </TableCell>
    </TableRow>
  );
}

export function EquipamentosTable() {
  const ability = useAbility();
  const canManage = ability.can("manage", "PcpSetor");
  const { data: equipamentos, isPending, isError, error } =
    useEquipamentosQuery();
  const { data: setores } = useSetoresQuery();
  const vincularMutation = useVincularEquipamentoMutation();
  const [pendentes, setPendentes] = useState<ReadonlySet<number>>(new Set());

  const grupos = useMemo(() => {
    const catálogo = equipamentos ?? [];
    const semCategoria = catálogo.filter(
      (equipamento) => equipamento.setorId === null,
    );
    const classificados = catálogo.filter(
      (equipamento) => equipamento.setorId !== null,
    );

    const porSetor = (setores ?? [])
      .slice()
      .sort((a, b) => a.ordem - b.ordem)
      .map((setor) => ({
        setor,
        itens: classificados
          .filter((equipamento) => equipamento.setorId === setor.id)
          .sort((a, b) => a.codigo - b.codigo),
      }))
      .filter((grupo) => grupo.itens.length > 0);

    return { semCategoria, porSetor };
  }, [equipamentos, setores]);

  const vincular = (codigo: number, setorId: string | null) => {
    setPendentes((atual) => new Set(atual).add(codigo));
    vincularMutation.mutate(
      { codigo, setorId },
      {
        onSettled: () => {
          setPendentes((atual) => {
            const proximo = new Set(atual);
            proximo.delete(codigo);
            return proximo;
          });
        },
        onError: (err) => toast.error(getErrorMessage(err)),
      },
    );
  };

  if (isError) {
    return (
      <div
        role="alert"
        className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
      >
        <TriangleAlert className="size-4 shrink-0" />
        {getErrorMessage(error)}
      </div>
    );
  }

  if (isPending) {
    return (
      <div className="flex items-center justify-center gap-2 py-16 text-sm text-muted-foreground">
        <Loader2 className="animate-spin" />
        Carregando equipamentos...
      </div>
    );
  }

  const nenhumEquipamento = (equipamentos ?? []).length === 0;
  const selecaoPendente = vincularMutation.isPending;

  return (
    <div className="flex flex-col gap-4">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-24">Código</TableHead>
            <TableHead>Equipamento</TableHead>
            <TableHead>Setor</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {nenhumEquipamento ? (
            <TableRow>
              <TableCell
                colSpan={3}
                className="h-24 text-center text-muted-foreground"
              >
                Nenhum equipamento encontrado.
              </TableCell>
            </TableRow>
          ) : (
            <>
              {grupos.semCategoria.length > 0 ? (
                <>
                  <TableRow className="bg-muted/50">
                    <TableCell
                      colSpan={3}
                      className="py-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground"
                    >
                      Sem categoria ({grupos.semCategoria.length})
                    </TableCell>
                  </TableRow>
                  {grupos.semCategoria.map((equipamento) => (
                    <EquipamentoRow
                      key={equipamento.codigo}
                      equipamento={equipamento}
                      setores={setores ?? []}
                      canManage={canManage}
                      isPending={
                        pendentes.has(equipamento.codigo) || selecaoPendente
                      }
                      onChange={vincular}
                    />
                  ))}
                </>
              ) : null}

              {grupos.porSetor.map(({ setor, itens }) => (
                <Fragment key={setor.id}>
                  <TableRow className="bg-muted/50">
                    <TableCell
                      colSpan={3}
                      className="py-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground"
                    >
                      {setor.nome} ({itens.length})
                    </TableCell>
                  </TableRow>
                  {itens.map((equipamento) => (
                    <EquipamentoRow
                      key={equipamento.codigo}
                      equipamento={equipamento}
                      setores={setores ?? []}
                      canManage={canManage}
                      isPending={
                        pendentes.has(equipamento.codigo) || selecaoPendente
                      }
                      onChange={vincular}
                    />
                  ))}
                </Fragment>
              ))}
            </>
          )}
        </TableBody>
      </Table>
    </div>
  );
}