import { useAbility } from "@casl/react";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@repo/ui/components/card";

import { EquipamentosTable } from "@/features/pcp/equipamentos-table";
import { SetoresPanel } from "@/features/pcp/setores-panel";

export function PcpPage() {
  const ability = useAbility();
  const isAdmin = ability.can("manage", "PcpSetor");

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">PCP</h1>
        <p className="mt-1 text-muted-foreground">
          Classifique os equipamentos da produção em setores.
          {isAdmin
            ? " Somente administradores podem alterar os setores."
            : " Você tem acesso de leitura ao mapeamento."}
        </p>
      </div>

      <div className="grid gap-6 lg:grid-cols-[380px_minmax(0,1fr)]">
        <SetoresPanel />

        <Card className="min-w-0">
          <CardHeader>
            <CardTitle>Equipamentos</CardTitle>
            <CardDescription>
              Catálogo ao vivo do Wingraphex com o setor de cada equipamento.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <EquipamentosTable />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}