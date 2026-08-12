import { useState } from "react";

import { Loader2, Pencil, Trash2 } from "lucide-react";
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
import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@repo/ui/components/table";

import { getErrorMessage } from "@/lib/error-message";

import { useDeleteUserMutation } from "./users.queries";
import type { User } from "./users.schemas";

export function UsersTable({
  users,
  currentUserId,
  onEdit,
}: {
  users: User[];
  currentUserId?: string;
  onEdit: (user: User) => void;
}) {
  const deleteMutation = useDeleteUserMutation();
  const [confirmUser, setConfirmUser] = useState<User | null>(null);

  const deletingId = deleteMutation.isPending
    ? deleteMutation.variables
    : undefined;

  const handleDeleteClick = (user: User) => {
    if (user.id === currentUserId) {
      toast.error("Você não pode excluir o seu próprio usuário.");
      return;
    }
    setConfirmUser(user);
  };

  const handleConfirmDelete = () => {
    if (confirmUser === null) {
      return;
    }
    deleteMutation.mutate(confirmUser.id, {
      onSuccess: () => {
        toast.success("Usuário excluído.");
      },
      onError: (err) => {
        toast.error(getErrorMessage(err));
      },
      onSettled: () => setConfirmUser(null),
    });
  };

  return (
    <>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="w-[30%]">Usuário</TableHead>
            <TableHead className="hidden md:table-cell">Nome</TableHead>
            <TableHead>Papel</TableHead>
            <TableHead className="text-right">Ações</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {users.map((user) => (
            <TableRow key={user.id}>
              <TableCell className="font-medium">
                @{user.username}
                {user.id === currentUserId ? (
                  <span className="ml-2 text-xs text-muted-foreground">
                    (você)
                  </span>
                ) : null}
              </TableCell>
              <TableCell className="hidden text-muted-foreground md:table-cell">
                {user.name}
              </TableCell>
              <TableCell>
                <Badge
                  variant={user.role === "admin" ? "secondary" : "outline"}
                >
                  {user.role === "admin" ? "Admin" : "Usuário"}
                </Badge>
              </TableCell>
              <TableCell className="text-right">
                <div className="flex items-center justify-end gap-1">
                  <Button
                    variant="ghost"
                    size="icon"
                    aria-label={`Editar ${user.username}`}
                    disabled={deletingId !== undefined}
                    onClick={() => onEdit(user)}
                  >
                    <Pencil />
                  </Button>
                  <Button
                    variant="ghost"
                    size="icon"
                    aria-label={`Excluir ${user.username}`}
                    disabled={
                      user.id === currentUserId || deletingId !== undefined
                    }
                    onClick={() => handleDeleteClick(user)}
                  >
                    {deletingId === user.id ? (
                      <Loader2 className="animate-spin text-destructive" />
                    ) : (
                      <Trash2 className="text-destructive" />
                    )}
                  </Button>
                </div>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      <AlertDialog
        open={confirmUser !== null}
        onOpenChange={(open) => {
          if (!open) {
            setConfirmUser(null);
          }
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Excluir usuário?</AlertDialogTitle>
            <AlertDialogDescription>
              Excluir o usuário &quot;@{confirmUser?.username}&quot;? Esta ação
              não pode ser desfeita.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleteMutation.isPending}>
              Cancelar
            </AlertDialogCancel>
            <AlertDialogAction
              variant="destructive"
              disabled={deleteMutation.isPending}
              onClick={() => void handleConfirmDelete()}
            >
              {deleteMutation.isPending ? (
                <Loader2 className="animate-spin" />
              ) : null}
              Excluir
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
}
