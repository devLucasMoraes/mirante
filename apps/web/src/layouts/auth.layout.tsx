import { Outlet } from "react-router";

import { Quote } from "lucide-react";

import { Badge } from "@repo/ui/components/badge";

import { BrandLogo } from "@/components/brand-logo";
import { ThemeToggle } from "@/features/theme/theme-toggle";

export function AuthLayout() {
  return (
    <div className="min-h-svh lg:grid lg:grid-cols-2">
      <aside className="relative hidden flex-col justify-between overflow-hidden bg-primary p-12 text-primary-foreground lg:flex">
        <div
          className="absolute inset-0 bg-primary"
          aria-hidden="true"
        />
        <div className="relative">
          <BrandLogo className="text-primary-foreground" />
        </div>

        <div className="relative">
          <Quote className="mb-6 size-8 text-primary-foreground/60" aria-hidden="true" />
          <blockquote className="max-w-xl">
            <p className="text-2xl font-semibold leading-snug tracking-tight">
              &ldquo;O Mirante reduziu pela metade o tempo das nossas consultas.
              Hoje a equipe trabalha no que importa de verdade.&rdquo;
            </p>
            <footer className="mt-6 flex items-center gap-3">
              <div className="flex size-10 items-center justify-center rounded-full bg-primary-foreground/20 text-sm font-semibold">
                MS
              </div>
              <div>
                <p className="text-sm font-medium">Marina Souza</p>
                <p className="text-sm text-primary-foreground/70">
                  COO na Gráfica Horizonte
                </p>
              </div>
            </footer>
          </blockquote>
        </div>

        <div className="relative flex items-center gap-4">
          <Badge
            variant="secondary"
            className="bg-primary-foreground/15 text-primary-foreground hover:bg-primary-foreground/20"
          >
            +100 consultas por dia
          </Badge>
          <p className="text-sm text-primary-foreground/80">
            Confiado por gráficas em todo o Brasil
          </p>
        </div>
      </aside>

      <div className="flex flex-col">
        <header className="flex h-16 items-center justify-between px-6">
          <BrandLogo />
          <ThemeToggle />
        </header>

        <main className="flex flex-1 items-center justify-center px-6 pb-12">
          <div className="w-full max-w-sm">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}