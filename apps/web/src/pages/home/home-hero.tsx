import { Link } from "react-router";

import {
  ArrowRight,
  BarChart3,
  Check,
  Sparkles,
  Users,
} from "lucide-react";

import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";

function PreviewCard() {
  return (
    <div className="relative mx-auto mt-20 max-w-4xl">
      <div
        className="absolute -inset-6 rounded-3xl bg-gradient-to-r from-primary/20 via-accent/20 to-ring/20 blur-2xl"
        aria-hidden="true"
      />
      <div className="relative overflow-hidden rounded-2xl border border-border bg-card shadow-2xl">
        <div className="flex items-center justify-between border-b border-border px-6 py-4">
          <div className="flex items-center gap-2">
            <Sparkles className="size-5 text-primary" />
            <span className="text-sm font-semibold">acme</span>
          </div>
          <div className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-destructive/70" />
            <span className="h-2.5 w-2.5 rounded-full bg-amber-500/70" />
            <span className="h-2.5 w-2.5 rounded-full bg-emerald-500/70" />
          </div>
        </div>
        <div className="grid grid-cols-1 gap-6 p-6 md:grid-cols-[220px_1fr]">
          <div className="hidden flex-col gap-2 md:flex">
            <div className="flex h-12 items-center rounded-lg border border-border bg-muted/50 px-3 text-xs font-medium text-muted-foreground">
              Visão geral
            </div>
            <div className="flex items-center gap-2 rounded-lg px-3 py-2 text-xs text-muted-foreground">
              <BarChart3 className="size-4" /> Relatórios
            </div>
            <div className="flex items-center gap-2 rounded-lg px-3 py-2 text-xs text-muted-foreground">
              <Users className="size-4" /> Membro do time
            </div>
          </div>
          <div className="space-y-5">
            <div className="grid grid-cols-3 gap-4">
              {[
                ["Receita", "R$ 128k"],
                ["Novos usuários", "2.4k"],
                ["Conversão", "12,8%"],
              ].map(([label, value]) => (
                <div
                  key={label}
                  className="rounded-lg border border-border bg-muted/40 p-4"
                >
                  <p className="text-xs text-muted-foreground">{label}</p>
                  <p className="mt-1 text-xl font-semibold">{value}</p>
                </div>
              ))}
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="rounded-lg border border-border bg-muted/40 p-4">
                <div className="flex items-end gap-2">
                  <div className="h-16 w-6 rounded-md bg-primary/70" />
                  <div className="h-24 w-6 rounded-md bg-primary/70" />
                  <div className="h-20 w-6 rounded-md bg-primary/70" />
                  <div className="h-28 w-6 rounded-md bg-primary/90" />
                  <div className="h-22 w-6 rounded-md bg-primary/80" />
                </div>
              </div>
              <div className="flex flex-col justify-center gap-3 rounded-lg border border-border bg-muted/40 p-4">
                <div className="flex items-center gap-2 text-sm">
                  <Check className="size-4 text-emerald-500" /> Tarefas em dia
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <Check className="size-4 text-emerald-500" /> Sprint
                  atualizada
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export function HomeHero() {
  return (
    <section className="relative overflow-hidden">
      <div
        className="pointer-events-none absolute left-1/2 top-0 -z-10 h-[600px] w-[900px] -translate-x-1/2 rounded-full bg-primary/10 blur-3xl"
        aria-hidden="true"
      />
      <div className="mx-auto max-w-7xl px-6 pb-16 pt-24 text-center md:pt-32">
        <Badge
          variant="secondary"
          className="mx-auto mb-6 gap-1.5 rounded-full px-3 py-1"
        >
          <Sparkles className="size-3.5 text-primary" />
          Novidade: automações com IA
        </Badge>
        <h1 className="mx-auto max-w-3xl text-4xl font-bold tracking-tight sm:text-5xl md:text-6xl">
          Produtividade em escala para a sua equipe
        </h1>
        <p className="mx-auto mt-6 max-w-2xl text-lg text-muted-foreground">
          A plataforma tudo-em-um que ajuda times a planejar, executar e medir
          o trabalho em um só lugar — sem migrar a forma de trabalhar.
        </p>
        <div className="mt-10 flex flex-col items-center justify-center gap-3 sm:flex-row">
          <Button size="lg" asChild>
            <Link to="/login">
              Entrar
              <ArrowRight />
            </Link>
          </Button>
          <Button size="lg" variant="outline" asChild>
            <a href="#recursos">Ver recurso</a>
          </Button>
        </div>
        <p className="mt-4 text-sm text-muted-foreground">
          Acesso restrito à rede interna da empresa
        </p>

        <PreviewCard />
      </div>
    </section>
  );
}
