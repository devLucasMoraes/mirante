import { useEffect, useState } from "react";

import { useAbility } from "@casl/react";
import { Loader2, TriangleAlert } from "lucide-react";
import { toast } from "sonner";

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

import { useAuthStore } from "@/features/auth/auth.store";
import { useUpdateUserMutation } from "@/features/users/users.queries";
import { updateProfileSchema } from "@/features/users/users.schemas";
import { getErrorMessage } from "@/lib/error-message";

export function ProfilePage() {
  const user = useAuthStore((state) => state.user);
  const setUser = useAuthStore((state) => state.setUser);
  const ability = useAbility();
  const updateMutation = useUpdateUserMutation();

  const [name, setName] = useState(user?.name ?? "");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setName(user?.name ?? "");
  }, [user?.name]);

  if (user === null) {
    return null;
  }

  const canUpdateName = ability.can("update", user, "name");
  const canUpdatePassword = ability.can("update", user, "password");

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);

    if (canUpdatePassword && password && password !== confirmPassword) {
      setError("As senhas não coincidem.");
      return;
    }

    const payload: Record<string, string> = {};
    if (canUpdateName) {
      payload.name = name;
    }
    if (canUpdatePassword && password) {
      payload.password = password;
    }

    const parsed = updateProfileSchema.safeParse(payload);
    if (!parsed.success) {
      setError(parsed.error.issues[0]?.message ?? "Dados inválidos.");
      return;
    }

    updateMutation.mutate(
      { id: user.id, payload: parsed.data },
      {
        onSuccess: (updated) => {
          setUser(updated);
          setName(updated.name);
          setPassword("");
          setConfirmPassword("");
          toast.success("Perfil atualizado com sucesso!");
        },
        onError: (err) => setError(getErrorMessage(err)),
      },
    );
  };

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Meu perfil</h1>
        <p className="mt-1 text-muted-foreground">
          Atualize os dados da sua conta.
        </p>
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
          <CardTitle>Dados da conta</CardTitle>
          <CardDescription>
            Seu usuário e seu papel não podem ser alterados por você.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="profile-username">Usuário</Label>
              <Input
                id="profile-username"
                value={user.username}
                disabled
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="profile-role">Papel</Label>
              <div className="pt-1">
                <Badge variant={user.role === "admin" ? "secondary" : "outline"}>
                  {user.role === "admin" ? "Admin" : "Usuário"}
                </Badge>
              </div>
            </div>

            {canUpdateName ? (
              <div className="space-y-2">
                <Label htmlFor="profile-name">Nome</Label>
                <Input
                  id="profile-name"
                  type="text"
                  placeholder="Seu nome completo"
                  value={name}
                  onChange={(event) => setName(event.target.value)}
                  required
                  disabled={updateMutation.isPending}
                />
              </div>
            ) : null}

            {canUpdatePassword ? (
              <div className="space-y-2">
                <Label htmlFor="profile-password">Nova senha</Label>
                <Input
                  id="profile-password"
                  type="password"
                  autoComplete="new-password"
                  placeholder="Deixe em branco para manter"
                  value={password}
                  onChange={(event) => setPassword(event.target.value)}
                  disabled={updateMutation.isPending}
                />
              </div>
            ) : null}

            {canUpdatePassword ? (
              <div className="space-y-2">
                <Label htmlFor="profile-confirm-password">Confirmar senha</Label>
                <Input
                  id="profile-confirm-password"
                  type="password"
                  autoComplete="new-password"
                  placeholder="Repita a nova senha"
                  value={confirmPassword}
                  onChange={(event) => setConfirmPassword(event.target.value)}
                  disabled={updateMutation.isPending}
                />
              </div>
            ) : null}

            <Button type="submit" disabled={updateMutation.isPending} className="w-full">
              {updateMutation.isPending ? (
                <>
                  <Loader2 className="animate-spin" />
                  Salvando...
                </>
              ) : (
                "Salvar alterações"
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
