import { Link } from "react-router";

import { ShieldAlert } from "lucide-react";

import { Button } from "@repo/ui/components/button";

export function UnauthorizedPage() {
  return (
    <main className="flex min-h-svh items-center justify-center px-6 py-24">
      <div className="mx-auto flex max-w-md flex-col items-center text-center">
        <div className="mb-6 flex size-16 items-center justify-center rounded-2xl bg-destructive/10 text-destructive">
          <ShieldAlert className="size-8" aria-hidden="true" />
        </div>
        <h1 className="text-3xl font-bold tracking-tight">Acesso não autorizado</h1>
        <p className="mt-3 text-muted-foreground">
          Você precisa entrar na sua conta para acessar esta página.
        </p>
        <div className="mt-8 flex flex-col gap-3 sm:flex-row">
          <Button asChild>
            <Link to="/login">Entrar na conta</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link to="/">Voltar para o site</Link>
          </Button>
        </div>
      </div>
    </main>
  );
}