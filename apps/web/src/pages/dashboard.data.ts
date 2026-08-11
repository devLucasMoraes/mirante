import { Activity, CircleDollarSign, Users } from "lucide-react";

export const STATS = [
  {
    label: "Receita recorrente",
    value: "R$ 128.400",
    change: "+12,5%",
    icon: CircleDollarSign,
  },
  {
    label: "Usuários ativos",
    value: "2.418",
    change: "+8,2%",
    icon: Users,
  },
  {
    label: "Taxa de conversão",
    value: "12,8%",
    change: "+1,9%",
    icon: Activity,
  },
];

export const PROJECTS = [
  {
    name: "Website corporativo",
    status: "Em andamento",
    owner: "Dani Alves",
    progress: 68,
  },
  {
    name: "Painel de métricas",
    status: "Em revisão",
    owner: "Rafael Costa",
    progress: 84,
  },
  {
    name: "Onboarding novo cliente",
    status: "Concluído",
    owner: "Bia Ramos",
    progress: 100,
  },
  {
    name: "Documentação da API",
    status: "Em andamento",
    owner: "Leo Prado",
    progress: 41,
  },
];

export type ProjectStatus = (typeof PROJECTS)[number]["status"];

export const STATUS_VARIANT: Record<
  ProjectStatus,
  "outline" | "secondary" | "default"
> = {
  "Em andamento": "secondary",
  "Em revisão": "outline",
  Concluído: "default",
};
