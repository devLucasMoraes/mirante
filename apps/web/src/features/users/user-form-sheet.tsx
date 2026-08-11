import { useEffect, useState } from "react";

import { Loader2, TriangleAlert } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@repo/ui/components/button";
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

import { createUser, updateUser } from "@/api/users.api";
import { getErrorMessage } from "@/lib/error-message";

import type { User, UserRole } from "./users.schemas";
import { createUserSchema } from "./users.schemas";

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

export function UserFormSheet({
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
        await updateUser(editing.id, {
          username: form.username,
          name: form.name,
          password: form.password || undefined,
          role: form.role,
        });
        toast.success("Usuário atualizado com sucesso!");
      } else {
        if (form.password !== form.confirmPassword) {
          setError("As senhas não coincidem.");
          return;
        }
        const payload = createUserSchema.parse(form);
        await createUser(payload);
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
