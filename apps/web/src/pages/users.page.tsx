import { useState } from "react";

import { Loader2, Plus, TriangleAlert, Users } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";

import { useAuthStore } from "@/features/auth/auth.store";
import { UserFormSheet } from "@/features/users/user-form-sheet";
import { useUsersQuery } from "@/features/users/users.queries";
import type { User } from "@/features/users/users.schemas";
import { UsersTable } from "@/features/users/users-table";
import { getErrorMessage } from "@/lib/error-message";

export function UsersPage() {
  const currentUser = useAuthStore((state) => state.user);
  const { data: users, isPending, isError, error } = useUsersQuery();
  const [sheetOpen, setSheetOpen] = useState(false);
  const [editing, setEditing] = useState<User | null>(null);

  const openCreate = () => {
    setEditing(null);
    setSheetOpen(true);
  };

  const openEdit = (user: User) => {
    setEditing(user);
    setSheetOpen(true);
  };

  return (
    <>
      <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Usuários</h1>
          <p className="mt-1 text-muted-foreground">
            Gerencie os usuários com acesso ao sistema.
          </p>
        </div>
        <Button onClick={openCreate} className="md:self-auto">
          <Plus />
          Novo usuário
        </Button>
      </div>

      {isError ? (
        <div
          role="alert"
          className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
        >
          <TriangleAlert className="size-4 shrink-0" />
          {getErrorMessage(error)}
        </div>
      ) : null}

      <Card>
        <CardHeader>
          <CardTitle>Usuários cadastrados</CardTitle>
          <CardDescription>
            Papéis: Administrador pode gerenciar usuários; Usuário tem acesso
            comum ao sistema.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {isPending ? (
            <div className="flex items-center justify-center gap-2 py-10 text-sm text-muted-foreground">
              <Loader2 className="animate-spin" />
              Carregando usuários...
            </div>
          ) : isError || users === undefined ? null : users.length === 0 ? (
            <div className="flex flex-col items-center gap-2 py-10 text-center text-sm text-muted-foreground">
              <Users className="size-6" />
              Nenhum usuário cadastrado ainda.
            </div>
          ) : (
            <UsersTable
              users={users}
              currentUserId={currentUser?.id}
              onEdit={openEdit}
            />
          )}
        </CardContent>
      </Card>

      <UserFormSheet
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        editing={editing}
      />
    </>
  );
}
