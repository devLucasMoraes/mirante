import { Pencil, Trash2 } from "lucide-react";
import { toast } from "sonner";

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

import { deleteUser } from "@/api/users.api";
import { getErrorMessage } from "@/lib/error-message";

import type { User } from "./users.schemas";

export function UsersTable({
  users,
  currentUserId,
  onEdit,
  onChanged,
}: {
  users: User[];
  currentUserId?: string;
  onEdit: (user: User) => void;
  onChanged: () => void;
}) {
  const handleDelete = async (user: User) => {
    if (user.id === currentUserId) {
      toast.error("Você não pode excluir o seu próprio usuário.");
      return;
    }
    if (!window.confirm(`Excluir o usuário "${user.username}"?`)) {
      return;
    }
    try {
      await deleteUser(user.id);
      toast.success("Usuário excluído.");
      onChanged();
    } catch (err) {
      toast.error(getErrorMessage(err));
    }
  };

  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead className="w-[30%]">Usuário</TableHead>
          <TableHead>Nome</TableHead>
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
            <TableCell className="text-muted-foreground">
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
                  onClick={() => onEdit(user)}
                >
                  <Pencil />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  aria-label={`Excluir ${user.username}`}
                  disabled={user.id === currentUserId}
                  onClick={() => void handleDelete(user)}
                >
                  <Trash2 className="text-destructive" />
                </Button>
              </div>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
}
