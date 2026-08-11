import {
  BarChart3,
  Layers,
  Lock,
  ShieldCheck,
  Users,
  Workflow,
} from "lucide-react";

import {
  Card,
  CardContent,
} from "@repo/ui/components/card";

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

export function HomeFeatures() {
  return (
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
  );
}
