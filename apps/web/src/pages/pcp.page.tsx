import { useState } from "react";

import { useAbility } from "@casl/react";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@repo/ui/components/card";
import { Label } from "@repo/ui/components/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@repo/ui/components/select";

import { EquipamentosTable } from "@/features/pcp/equipamentos-table";
import type { EmpresaPcp } from "@/features/pcp/pcp.schemas";
import { SetoresPanel } from "@/features/pcp/setores-panel";
import { empresaNome } from "@/features/wingraphex/wingraphex.format";

export function PcpPage() {
  const ability = useAbility();
  const isAdmin = ability.can("manage", "PcpSetor");
  const [empresa, setEmpresa] = useState<EmpresaPcp>("1");

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
          <CardContent className="flex flex-col gap-4">
            <div className="flex items-center gap-3">
              <Label htmlFor="pcp-empresa" className="shrink-0">
                Empresa
              </Label>
              <Select
                value={empresa}
                onValueChange={(value) => setEmpresa(value as EmpresaPcp)}
              >
                <SelectTrigger id="pcp-empresa" className="w-full sm:max-w-56">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="1">{empresaNome("1")}</SelectItem>
                  <SelectItem value="2">{empresaNome("2")}</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <EquipamentosTable empresa={empresa} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}