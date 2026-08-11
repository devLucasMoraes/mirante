import { Link } from "react-router";

import { Compass } from "lucide-react";

import { Button } from "@repo/ui/components/button";

export function NotFoundPage() {
  return (
    <main className="flex min-h-svh items-center justify-center px-6 py-24">
      <div className="flex max-w-md flex-col items-center text-center">
        <div className="mb-6 flex size-16 items-center justify-center rounded-2xl bg-muted text-muted-foreground">
          <Compass className="size-8" aria-hidden="true" />
        </div>
        <p className="font-mono text-sm font-semibold tracking-widest text-primary">
          404
        </p>
        <h1 className="mt-2 text-3xl font-bold tracking-tight">
          Página não encontrada
        </h1>
        <p className="mt-3 text-muted-foreground">
          O conteúdo que você procura não existe ou foi movido para outro
          endereço.
        </p>
        <div className="mt-8 flex flex-col gap-3 sm:flex-row">
          <Button asChild>
            <Link to="/">Ir para o início</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link to="/login">Entrar</Link>
          </Button>
        </div>
      </div>
    </main>
  );
}