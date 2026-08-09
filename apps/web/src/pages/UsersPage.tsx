import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import {
  Loader2,
  Pencil,
  Plus,
  Trash2,
  TriangleAlert,
  Users,
} from "lucide-react";
import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
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
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@repo/ui/components/table";
import { api } from "@/auth/apiClient";
import { getErrorMessage } from "@/auth/getErrorMessage";
import { useAuthStore } from "@/auth/authStore";
import { createUserSchema, updateUserSchema, userSchema } from "@/auth/schemas";
import type { User, UserRole } from "@/auth/schemas";

type UserFormState = {
  username: string;
  name: string;
  password: string;
  confirmPassword: string;
  role: UserRole;
};

const EMPTY_FORM: UserFormState = {
  username: "",
  name: "",
  password: "",
  confirmPassword: "",
  role: "user",
};

function parseUsers(data: unknown): User[] {
  if (!Array.isArray(data)) {
    throw new Error("Resposta inválida da API");
  }
  return data.map((item) => userSchema.parse(item));
}

function UserFormSheet({
  open,
  onOpenChange,
  editing,
  onSaved,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  editing: User | null;
  onSaved: () => void;
}) {
  const [form, setForm] = useState<UserFormState>(EMPTY_FORM);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setForm(
        editing
          ? {
              username: editing.username,
              name: editing.name,
              password: "",
              confirmPassword: "",
              role: editing.role,
            }
          : EMPTY_FORM,
      );
      setError(null);
    }
  }, [open, editing]);

  const isEditing = editing !== null;

  const set = (field: keyof UserFormState) => (value: string) =>
    setForm((current) => ({ ...current, [field]: value }));

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      if (isEditing) {
        const payload = updateUserSchema.parse({
          username: form.username,
          name: form.name,
          password: form.password || undefined,
          role: form.role,
        });
        await api.patch(`/users/${editing.id}`, payload);
        toast.success("Usuário atualizado com sucesso!");
      } else {
        if (form.password !== form.confirmPassword) {
          setError("As senhas não coincidem.");
          return;
        }
        const payload = createUserSchema.parse(form);
        await api.post("/users", payload);
        toast.success("Usuário criado com sucesso!");
      }
      onSaved();
      onOpenChange(false);
    } catch (err) {
      setError(getErrorMessage(err));
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="sm:max-w-md">
        <SheetHeader>
          <SheetTitle>
            {isEditing ? "Editar usuário" : "Novo usuário"}
          </SheetTitle>
          <SheetDescription>
            {isEditing
              ? "Atualize os dados do usuário. Deixe a senha em branco para mantê-la."
              : "Cadastre um novo usuário para acessar o sistema."}
          </SheetDescription>
        </SheetHeader>

        {error ? (
          <div
            role="alert"
            className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
          >
            <TriangleAlert className="size-4 shrink-0" />
            {error}
          </div>
        ) : null}

        <form id="user-form" onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="user-username">Usuário</Label>
            <Input
              id="user-username"
              autoComplete="off"
              placeholder="ex.: joao.silva"
              value={form.username}
              onChange={(event) => set("username")(event.target.value)}
              required
              disabled={submitting}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="user-name">Nome</Label>
            <Input
              id="user-name"
              placeholder="Nome completo"
              value={form.name}
              onChange={(event) => set("name")(event.target.value)}
              required
              disabled={submitting}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="user-password">
              {isEditing ? "Nova senha" : "Senha"}
            </Label>
            <Input
              id="user-password"
              type="password"
              autoComplete="new-password"
              placeholder="Mínimo de 6 caracteres"
              value={form.password}
              onChange={(event) => set("password")(event.target.value)}
              required={!isEditing}
              disabled={submitting}
            />
          </div>

          {!isEditing ? (
            <div className="space-y-2">
              <Label htmlFor="user-confirm-password">Confirmar senha</Label>
              <Input
                id="user-confirm-password"
                type="password"
                autoComplete="new-password"
                placeholder="Repita a senha"
                value={form.confirmPassword}
                onChange={(event) => set("confirmPassword")(event.target.value)}
                required
                disabled={submitting}
              />
            </div>
          ) : null}

          <div className="space-y-2">
            <Label htmlFor="user-role">Papel</Label>
            <select
              id="user-role"
              value={form.role}
              onChange={(event) => set("role")(event.target.value)}
              disabled={submitting}
              className="h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-base shadow-xs outline-none placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm dark:bg-input/30"
            >
              <option value="user">Usuário</option>
              <option value="admin">Administrador</option>
            </select>
          </div>
        </form>

        <SheetFooter>
          <Button
            type="submit"
            form="user-form"
            disabled={submitting}
            className="w-full"
          >
            {submitting ? (
              <>
                <Loader2 className="animate-spin" />
                Salvando...
              </>
            ) : isEditing ? (
              "Salvar alterações"
            ) : (
              "Criar usuário"
            )}
          </Button>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
}

export function UsersPage() {
  const currentUser = useAuthStore((state) => state.user);
  const [users, setUsers] = useState<User[] | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [sheetOpen, setSheetOpen] = useState(false);
  const [editing, setEditing] = useState<User | null>(null);

  const loadUsers = useCallback(async () => {
    try {
      const { data } = await api.get<unknown>("/users");
      setUsers(parseUsers(data));
      setError(null);
    } catch (err) {
      setError(getErrorMessage(err));
    }
  }, []);

  useEffect(() => {
    void loadUsers();
  }, [loadUsers]);

  const openCreate = () => {
    setEditing(null);
    setSheetOpen(true);
  };

  const openEdit = (user: User) => {
    setEditing(user);
    setSheetOpen(true);
  };

  const handleDelete = async (user: User) => {
    if (user.id === currentUser?.id) {
      toast.error("Você não pode excluir o seu próprio usuário.");
      return;
    }
    if (!window.confirm(`Excluir o usuário "${user.username}"?`)) {
      return;
    }
    try {
      await api.delete(`/users/${user.id}`);
      toast.success("Usuário excluído.");
      await loadUsers();
    } catch (err) {
      toast.error(getErrorMessage(err));
    }
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

      {error ? (
        <div
          role="alert"
          className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
        >
          <TriangleAlert className="size-4 shrink-0" />
          {error}
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
          {users === null ? (
            <div className="flex items-center justify-center gap-2 py-10 text-sm text-muted-foreground">
              <Loader2 className="animate-spin" />
              Carregando usuários...
            </div>
          ) : users.length === 0 ? (
            <div className="flex flex-col items-center gap-2 py-10 text-center text-sm text-muted-foreground">
              <Users className="size-6" />
              Nenhum usuário cadastrado ainda.
            </div>
          ) : (
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
                      {user.id === currentUser?.id ? (
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
                        variant={
                          user.role === "admin" ? "secondary" : "outline"
                        }
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
                          onClick={() => openEdit(user)}
                        >
                          <Pencil />
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          aria-label={`Excluir ${user.username}`}
                          disabled={user.id === currentUser?.id}
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
          )}
        </CardContent>
      </Card>

      <UserFormSheet
        open={sheetOpen}
        onOpenChange={setSheetOpen}
        editing={editing}
        onSaved={loadUsers}
      />
    </>
  );
}
