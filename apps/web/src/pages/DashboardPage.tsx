import { toast } from "sonner";
import {
  Activity,
  ArrowUpRight,
  CircleDollarSign,
  Plus,
  Users,
} from "lucide-react";
import { Badge } from "@repo/ui/components/badge";
import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@repo/ui/components/table";
import { useAuthStore } from "@/auth/authStore";

const STATS = [
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

const PROJECTS = [
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

type ProjectStatus = (typeof PROJECTS)[number]["status"];

const STATUS_VARIANT: Record<
  ProjectStatus,
  "outline" | "secondary" | "default"
> = {
  "Em andamento": "secondary",
  "Em revisão": "outline",
  Concluído: "default",
};

export function DashboardPage() {
  const user = useAuthStore((state) => state.user);
  const username = user?.username ?? "";
  const name = user?.name ?? username;
  const firstName = name.split(" ")[0] ?? "aí";

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">
            Olá, {firstName}
          </h1>
          <p className="mt-1 text-muted-foreground">
            Veja o que está acontecendo no seu workspace hoje.
          </p>
        </div>
        <Button
          onClick={() => toast.info("Criação de projetos chega em breve!")}
          className="md:self-auto"
        >
          <Plus />
          Novo projeto
        </Button>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {STATS.map((stat) => (
          <Card key={stat.label}>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <p className="text-sm text-muted-foreground">{stat.label}</p>
                <div className="flex size-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
                  <stat.icon className="size-4" />
                </div>
              </div>
              <div className="mt-3 flex items-center gap-2">
                <span className="text-2xl font-semibold tracking-tight">
                  {stat.value}
                </span>
                <Badge
                  variant="secondary"
                  className="gap-0.5 px-1.5 py-0 text-xs"
                >
                  <ArrowUpRight className="size-3" />
                  {stat.change}
                </Badge>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Projetos recentes</CardTitle>
          <CardDescription>
            Os últimos projetos atualizados no seu workspace.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-[45%]">Projeto</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="hidden md:table-cell">
                  Responsável
                </TableHead>
                <TableHead className="hidden text-right sm:table-cell">
                  Progresso
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {PROJECTS.map((project) => (
                <TableRow key={project.name}>
                  <TableCell className="font-medium">{project.name}</TableCell>
                  <TableCell>
                    <Badge variant={STATUS_VARIANT[project.status]}>
                      {project.status}
                    </Badge>
                  </TableCell>
                  <TableCell className="hidden text-muted-foreground md:table-cell">
                    {project.owner}
                  </TableCell>
                  <TableCell className="hidden sm:table-cell">
                    <div className="flex items-center justify-end gap-3">
                      <div className="h-2 w-24 overflow-hidden rounded-full bg-muted">
                        <div
                          className="h-full rounded-full bg-primary"
                          style={{ width: `${project.progress}%` }}
                        />
                      </div>
                      <span className="w-8 text-right text-xs text-muted-foreground tabular-nums">
                        {project.progress}%
                      </span>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
