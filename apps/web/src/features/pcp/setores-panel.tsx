import { useEffect, useState } from "react";

import { useAbility } from "@casl/react";
import { ChevronDown, ChevronUp, Loader2, Pencil, Plus, Save, Trash2, TriangleAlert } from "lucide-react";
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
} from "@repo/ui/components/alert-dialog";
import { Button } from "@repo/ui/components/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@repo/ui/components/card";
import { Input } from "@repo/ui/components/input";
import { Label } from "@repo/ui/components/label";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@repo/ui/components/sheet";

import { getErrorMessage } from "@/lib/error-message";

import {
  useCriarSetorMutation,
  useExcluirSetorMutation,
  useRenomearSetorMutation,
  useReordenarSetoresMutation,
  useSetoresQuery,
} from "./pcp.queries";
import type { PcpSetor } from "./pcp.schemas";

export function SetoresPanel() {
  const ability = useAbility();
  const canManage = ability.can("manage", "PcpSetor");
  const { data: setores, isPending } = useSetoresQuery();

  const [novoNome, setNovoNome] = useState("");
  const [erroCriar, setErroCriar] = useState<string | null>(null);
  const [renomeando, setRenomeando] = useState<PcpSetor | null>(null);
  const [excluindo, setExcluindo] = useState<PcpSetor | null>(null);

  const criarMutation = useCriarSetorMutation();
  const reordenarMutation = useReordenarSetoresMutation();

  const criar = () => {
    const nome = novoNome.trim();
    if (nome === "") {
      setErroCriar("Informe o nome do setor.");
      return;
    }
    setErroCriar(null);
    criarMutation.mutate(nome, {
      onSuccess: () => {
        setNovoNome("");
        toast.success("Setor criado com sucesso.");
      },
      onError: (err) => setErroCriar(getErrorMessage(err)),
    });
  };

  const trocarPosicoes = (a: number, b: number) => {
    if (!setores || setores.length < 2) return;
    if (a < 0 || b < 0 || a >= setores.length || b >= setores.length) return;
    const ids = setores.map((setor) => setor.id);
    const idA = ids[a];
    const idB = ids[b];
    if (idA === undefined || idB === undefined) return;
    ids[a] = idB;
    ids[b] = idA;
    reordenarMutation.mutate(ids, {
      onError: (err) => toast.error(getErrorMessage(err)),
    });
  };

  const subir = (index: number) => trocarPosicoes(index, index - 1);
  const descer = (index: number) => trocarPosicoes(index, index + 1);

  return (
    <Card className="flex flex-col">
      <CardHeader>
        <CardTitle>Setores</CardTitle>
        <CardDescription>
          Categorias usadas para agrupar os equipamentos na produção.
        </CardDescription>
      </CardHeader>
      <CardContent className="flex flex-col gap-4">
        {canManage ? (
          <div className="flex flex-col gap-2">
            <Label htmlFor="novo-setor">Novo setor</Label>
            <div className="flex flex-col gap-2 sm:flex-row">
              <Input
                id="novo-setor"
                placeholder="Ex.: Impressão offset"
                value={novoNome}
                onChange={(event) => setNovoNome(event.target.value)}
                onKeyDown={(event) => {
                  if (event.key === "Enter") criar();
                }}
                disabled={criarMutation.isPending}
              />
              <Button
                type="button"
                onClick={criar}
                disabled={criarMutation.isPending}
                className="sm:shrink-0"
              >
                {criarMutation.isPending ? (
                  <Loader2 className="animate-spin" />
                ) : (
                  <Plus />
                )}
                Criar
              </Button>
            </div>
            {erroCriar ? (
              <p
                role="alert"
                className="flex items-center gap-2 text-sm text-destructive"
              >
                <TriangleAlert className="size-4 shrink-0" />
                {erroCriar}
              </p>
            ) : null}
          </div>
        ) : null}

        {isPending ? (
          <div className="flex items-center justify-center gap-2 py-8 text-sm text-muted-foreground">
            <Loader2 className="animate-spin" />
            Carregando setores...
          </div>
        ) : !setores || setores.length === 0 ? (
          <p className="rounded-md border border-dashed p-4 text-center text-sm text-muted-foreground">
            Nenhum setor cadastrado ainda.
          </p>
        ) : (
          <ul className="flex flex-col gap-2">
            {setores.map((setor, index) => (
              <li
                key={setor.id}
                className="flex items-center justify-between gap-3 rounded-md border p-3"
              >
                <div className="min-w-0">
                  <p className="truncate font-medium">{setor.nome}</p>
                  <p className="text-xs text-muted-foreground">
                    Posição {index + 1} de {setores.length}
                  </p>
                </div>
                {canManage ? (
                  <div className="flex shrink-0 items-center gap-1">
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      className="size-8"
                      onClick={() => subir(index)}
                      disabled={index === 0 || reordenarMutation.isPending}
                      aria-label={`Mover ${setor.nome} para cima`}
                    >
                      <ChevronUp />
                    </Button>
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      className="size-8"
                      onClick={() => descer(index)}
                      disabled={
                        index === setores.length - 1 ||
                        reordenarMutation.isPending
                      }
                      aria-label={`Mover ${setor.nome} para baixo`}
                    >
                      <ChevronDown />
                    </Button>
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      className="size-8 text-muted-foreground"
                      onClick={() => setRenomeando(setor)}
                      aria-label={`Renomear ${setor.nome}`}
                    >
                      <Pencil />
                    </Button>
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon"
                      className="size-8 text-muted-foreground hover:text-destructive"
                      onClick={() => setExcluindo(setor)}
                      aria-label={`Excluir ${setor.nome}`}
                    >
                      <Trash2 />
                    </Button>
                  </div>
                ) : null}
              </li>
            ))}
          </ul>
        )}
      </CardContent>

      <RenomearSetorSheet
        setor={renomeando}
        onOpenChange={(open) => {
          if (!open) setRenomeando(null);
        }}
      />

      <ExcluirSetorDialog
        setor={excluindo}
        onOpenChange={(open) => {
          if (!open) setExcluindo(null);
        }}
      />
    </Card>
  );
}

function RenomearSetorSheet({
  setor,
  onOpenChange,
}: {
  setor: PcpSetor | null;
  onOpenChange: (open: boolean) => void;
}) {
  const renomearMutation = useRenomearSetorMutation();
  const [nome, setNome] = useState("");
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    if (setor) {
      setNome(setor.nome);
      setErro(null);
    }
  }, [setor]);

  const salvar = () => {
    if (!setor) return;
    const proximo = nome.trim();
    if (proximo === "") {
      setErro("Informe o nome do setor.");
      return;
    }
    setErro(null);
    renomearMutation.mutate(
      { id: setor.id, nome: proximo },
      {
        onSuccess: () => {
          toast.success("Setor renomeado.");
          onOpenChange(false);
        },
        onError: (err) => setErro(getErrorMessage(err)),
      },
    );
  };

  return (
    <Sheet open={setor !== null} onOpenChange={onOpenChange}>
      <SheetContent>
        <SheetHeader>
          <SheetTitle>Renomear setor</SheetTitle>
          <SheetDescription>
            Atualize o nome para melhor identificar o setor.
          </SheetDescription>
        </SheetHeader>
        <div className="flex flex-col gap-2">
          <Label htmlFor="renomear-setor-nome">Nome</Label>
          <Input
            id="renomear-setor-nome"
            value={nome}
            onChange={(event) => setNome(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter") salvar();
            }}
            disabled={renomearMutation.isPending}
          />
          {erro ? (
            <p
              role="alert"
              className="flex items-center gap-2 text-sm text-destructive"
            >
              <TriangleAlert className="size-4 shrink-0" />
              {erro}
            </p>
          ) : null}
        </div>
        <SheetFooter>
          <Button
            type="button"
            variant="outline"
            onClick={() => onOpenChange(false)}
            disabled={renomearMutation.isPending}
          >
            Cancelar
          </Button>
          <Button
            type="button"
            onClick={salvar}
            disabled={renomearMutation.isPending}
          >
            {renomearMutation.isPending ? (
              <Loader2 className="animate-spin" />
            ) : (
              <Save />
            )}
            Salvar
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

function ExcluirSetorDialog({
  setor,
  onOpenChange,
}: {
  setor: PcpSetor | null;
  onOpenChange: (open: boolean) => void;
}) {
  const excluirMutation = useExcluirSetorMutation();

  const excluir = () => {
    if (!setor) return;
    excluirMutation.mutate(setor.id, {
      onSuccess: () => {
        toast.success(
          `Setor "${setor.nome}" excluído. Equipamentos desvinculados.`,
        );
        onOpenChange(false);
      },
      onError: (err) => toast.error(getErrorMessage(err)),
    });
  };

  return (
    <AlertDialog open={setor !== null} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle>Excluir setor?</AlertDialogTitle>
          <AlertDialogDescription>
            Os equipamentos vinculados ao setor &quot;{setor?.nome}&quot; serão
            desvinculados e ficarão sem categoria.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={excluirMutation.isPending}>
            Cancelar
          </AlertDialogCancel>
          <AlertDialogAction
            variant="destructive"
            onClick={excluir}
            disabled={excluirMutation.isPending}
          >
            {excluirMutation.isPending ? (
              <Loader2 className="animate-spin" />
            ) : (
              <Trash2 />
            )}
            Excluir
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}