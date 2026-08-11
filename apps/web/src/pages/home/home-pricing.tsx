import { Link } from "react-router";

import { Check } from "lucide-react";

import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
import { cn } from "@repo/ui/lib/utils";

const PLANS = [
  {
    name: "Starter",
    price: "R$ 0",
    description: "Para começar a organizar seu fluxo de trabalho.",
    features: ["Até 3 membros", "Projetos ilimitados", "Suporte por e-mail"],
    cta: "Começar grátis",
    highlight: false,
  },
  {
    name: "Pro",
    price: "R$ 49",
    description: "Para equipes que querem crescer com produtividade.",
    features: [
      "Membros ilimitados",
      "Automações avançadas",
      "Relatórios personalizados",
      "Suporte prioritário 24/7",
    ],
    cta: "Testar por 14 dias",
    highlight: true,
  },
  {
    name: "Enterprise",
    price: "Sob consulta",
    description: "Para grandes organizações com demandas específicas.",
    features: ["SSO e AD/LDAP", "SLA dedicado", "Onboarding assistido"],
    cta: "Falar com vendas",
    highlight: false,
  },
];

export function HomePricing() {
  return (
    <section
      id="precos"
      className="border-y border-border bg-muted/40 px-6 py-24 scroll-mt-20"
    >
      <div className="mx-auto max-w-7xl">
        <div className="mb-14 max-w-2xl text-center">
          <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
            Preços simples, sem surpresas
          </h2>
          <p className="mt-4 text-muted-foreground">
            Escolha o plano certo para o momento da sua equipe. Upgrade sempre
            que quiser.
          </p>
        </div>
        <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
          {PLANS.map((plan) => (
            <Card
              key={plan.name}
              className={cn(
                "flex flex-col",
                plan.highlight &&
                  "border-primary/50 shadow-lg ring-1 ring-primary/30",
              )}
            >
              {plan.highlight ? (
                <div className="rounded-t-2xl bg-primary px-6 py-1.5 text-center text-xs font-semibold uppercase tracking-wider text-primary-foreground">
                  Mais popular
                </div>
              ) : null}
              <CardHeader>
                <CardTitle>{plan.name}</CardTitle>
                <CardDescription>{plan.description}</CardDescription>
              </CardHeader>
              <CardContent className="flex-1">
                <p className="text-3xl font-bold">{plan.price}</p>
                <ul className="mt-6 space-y-3">
                  {plan.features.map((feature) => (
                    <li
                      key={feature}
                      className="flex items-center gap-2 text-sm text-muted-foreground"
                    >
                      <Check className="size-4 shrink-0 text-primary" />
                      {feature}
                    </li>
                  ))}
                </ul>
              </CardContent>
              <CardFooter>
                <Button
                  className="w-full"
                  variant={plan.highlight ? "default" : "outline"}
                  asChild
                >
                  <Link to="/login">{plan.cta}</Link>
                </Button>
              </CardFooter>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}
