import { useAbility } from "@casl/react";

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";

import { CompanySettingsForm } from "@/features/company-settings/company-settings-form";

export function ConfiguracoesPage() {
  const ability = useAbility();
  const canUpdate = ability.can("update", "CompanySettings");

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">
          Configurações
        </h1>
        <p className="mt-1 text-muted-foreground">
          Personalize a identidade visual da sua empresa.
        </p>
      </div>

      {canUpdate ? (
        <CompanySettingsForm />
      ) : (
        <Card>
          <CardHeader>
            <CardTitle>Acesso restrito</CardTitle>
            <CardDescription>
              Apenas administradores podem alterar as configurações da empresa.
            </CardDescription>
          </CardHeader>
          <CardContent className="text-sm text-muted-foreground">
            Fale com um administrador para personalizar o nome e a logo.
          </CardContent>
        </Card>
      )}
    </div>
  );
}