import { Link } from "react-router";
import {
  ArrowRight,
  BarChart3,
  Check,
  ChevronDown,
  Layers,
  Lock,
  Rocket,
  ShieldCheck,
  Sparkles,
  Users,
  Workflow,
} from "lucide-react";
import { Badge } from "@repo/ui/components/badge";
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

const FEATURES = [
  {
    icon: Workflow,
    title: "Automações poderosas",
    description:
      "Conecte suas ferramentas e elimine tarefas repetitivas com fluxos visuais.",
  },
  {
    icon: BarChart3,
    title: "Métricas em tempo real",
    description:
      "Acompanhe o desempenho do time com dashboards claros e personalizáveis.",
  },
  {
    icon: Users,
    title: "Colaboração sem fricção",
    description:
      "Compartilhe projetos, comentários e decisões em um único lugar.",
  },
  {
    icon: ShieldCheck,
    title: "Segurança e conformidade",
    description:
      "SSO, criptografia em repouso e em trânsito e auditoria completa de acessos.",
  },
  {
    icon: Layers,
    title: "Integrações nativas",
    description:
      "Conecte sua stack favorita em minutos com nossa marketplace de apps.",
  },
  {
    icon: Lock,
    title: "Controle de acesso por papel",
    description:
      "Permissões granulares para cada membro, do estagiário ao administrador.",
  },
];

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

const TESTIMONIALS = [
  {
    quote:
      "A acme transformou a forma como coordenamos nossos projetos. Economizamos horas toda semana.",
    author: "Marina Souza",
    role: "Head of Product, Nimbus",
  },
  {
    quote:
      "A adoção pelo time foi instantânea. É a única ferramenta que as pessoas realmente usam.",
    author: "Rafael Costa",
    role: "CTO, Ledger",
  },
  {
    quote:
      "O tempo de relatório caiu 70%. Recomendo para qualquer equipe que valorize resultado.",
    author: "Bianca Lima",
    role: "Gerente de Ops, Fastlane",
  },
];

const FAQ = [
  {
    question: "Posso testar antes de pagar?",
    answer:
      "Sim. Nossa os planos Pro incluem 14 dias de teste grátis, sem cartão de crédito.",
  },
  {
    question: "Funciona com as ferramentas que a gente já usa?",
    answer:
      "Sim. Temos integrações nativas com as ferramentas mais populares e uma API completa.",
  },
  {
    question: "Como funciona o plano Enterprise?",
    answer:
      "Suporte a SSO, auditoria e preços personalizados. Chame nosso time comercial.",
  },
];

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

export function HomePage() {
  return (
    <>
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

      <section
        id="recursos"
        className="mx-auto max-w-7xl scroll-mt-20 px-6 py-24"
      >
        <div className="mx-auto mb-14 max-w-2xl text-center">
          <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
            Tudo o que você precisa para crescer
          </h2>
          <p className="mt-4 text-muted-foreground">
            Ferramentas simples e poderosas para equipes de qualquer tamanho.
          </p>
        </div>
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          {FEATURES.map((feature) => (
            <Card
              key={feature.title}
              className="group transition-shadow hover:shadow-lg"
            >
              <CardContent className="p-6">
                <div className="mb-4 flex size-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                  <feature.icon className="size-5" />
                </div>
                <h3 className="font-semibold">{feature.title}</h3>
                <p className="mt-2 text-sm text-muted-foreground">
                  {feature.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

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

      <section
        id="depoimentos"
        className="mx-auto max-w-7xl scroll-mt-20 px-6 py-24"
      >
        <div className="mb-14 max-w-2xl text-center">
          <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
            Quem usa, recomenda
          </h2>
          <p className="mt-4 text-muted-foreground">
            Mais de 10.000 equipes já escolheram a acme.
          </p>
        </div>
        <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
          {TESTIMONIALS.map((testimonial) => (
            <Card key={`${testimonial.author}-${testimonial.role}`}>
              <CardContent className="flex h-full flex-col justify-between p-6">
                <p className="text-muted-foreground">
                  &ldquo;{testimonial.quote}&rdquo;
                </p>
                <div className="mt-6 flex items-center gap-3">
                  <div className="flex size-10 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">
                    {testimonial.author.slice(0, 2)}
                  </div>
                  <div>
                    <p className="text-sm font-medium">{testimonial.author}</p>
                    <p className="text-xs text-muted-foreground">
                      {testimonial.role}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      <section id="faq" className="mx-auto max-w-3xl scroll-mt-20 px-6 py-24">
        <div className="mb-14 text-center">
          <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
            Perguntas frequentes
          </h2>
        </div>
        <div className="space-y-3">
          {FAQ.map((item) => (
            <details
              key={item.question}
              className="group rounded-lg border border-border bg-card p-5 open:bg-accent/40"
            >
              <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-medium [&::-webkit-details-marker]:hidden">
                {item.question}
                <ChevronDown className="size-4 shrink-0 rotate-0 transition-transform group-open:rotate-180" />
              </summary>
              <p className="mt-3 text-sm text-muted-foreground">
                {item.answer}
              </p>
            </details>
          ))}
        </div>
      </section>

      <section className="px-6 pb-24">
        <div className="mx-auto max-w-7xl overflow-hidden rounded-3xl bg-primary px-6 py-16 text-center text-primary-foreground md:py-20">
          <Rocket
            className="mx-auto mb-6 size-10 text-primary-foreground/80"
            aria-hidden="true"
          />
          <h2 className="mx-auto max-w-2xl text-3xl font-bold tracking-tight md:text-4xl">
            Pronto para trabalhar com mais leveza?
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-primary-foreground/80">
            Fale com o administrador do sistema para solicitar seu acesso.
          </p>
          <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
            <Button
              size="lg"
              variant="outline"
              className="bg-primary-foreground text-primary hover:bg-primary-foreground/90"
              asChild
            >
              <Link to="/login">
                Entrar
                <ArrowRight />
              </Link>
            </Button>
          </div>
        </div>
      </section>
    </>
  );
}
