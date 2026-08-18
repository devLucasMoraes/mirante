import { useEffect, useRef, useState } from "react";

import { ImagePlus, Loader2, Trash2,TriangleAlert } from "lucide-react";
import { toast } from "sonner";

import { Button } from "@repo/ui/components/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@repo/ui/components/card";
import { Input } from "@repo/ui/components/input";
import { Label } from "@repo/ui/components/label";

import { getErrorMessage } from "@/lib/error-message";

import { useUpdateCompanySettingsMutation } from "./company-settings.queries";
import {
  companyLogoSchema,
  companyNameSchema,
  LOGO_ACCEPTED_TYPES,
  LOGO_MAX_BYTES,
  LOGO_MIN_DIMENSION,
} from "./company-settings.schemas";
import { useCompanySettingsStore } from "./company-settings.store";

function isAcceptedLogo(file: File): boolean {
  return LOGO_ACCEPTED_TYPES.includes(file.type);
}

function isRasterLogo(file: File): boolean {
  return file.type !== "image/svg+xml";
}

function loadImageDimensions(
  dataUrl: string,
): Promise<{ width: number; height: number }> {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () =>
      resolve({ width: image.naturalWidth, height: image.naturalHeight });
    image.onerror = () => reject(new Error("Falha ao ler a imagem."));
    image.src = dataUrl;
  });
}

export function CompanySettingsForm() {
  const updateMutation = useUpdateCompanySettingsMutation();
  const branding = useCompanySettingsStore((state) => state.branding);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [name, setName] = useState("");
  const [logo, setLogo] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setName(branding.companyName);
    setLogo(branding.logo);
  }, [branding]);

  const nameChanged = name.trim() !== branding.companyName;
  const logoChanged = logo !== branding.logo;
  const hasChanges = nameChanged || logoChanged;

  const handleLogoSelected = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = "";
    if (file === undefined) {
      return;
    }

    if (!isAcceptedLogo(file)) {
      setError("A logo deve ser uma imagem PNG, JPEG, WebP ou SVG.");
      return;
    }
    if (file.size > LOGO_MAX_BYTES) {
      setError("A imagem deve ter no máximo 1 MB.");
      return;
    }

    const reader = new FileReader();
    reader.onload = async () => {
      const dataUrl = typeof reader.result === "string" ? reader.result : null;
      if (dataUrl === null) {
        setError("Não foi possível ler a imagem.");
        return;
      }
      try {
        if (isRasterLogo(file)) {
          const { width, height } = await loadImageDimensions(dataUrl);
          if (width < LOGO_MIN_DIMENSION || height < LOGO_MIN_DIMENSION) {
            setError(
              `A imagem deve ter ao menos ${LOGO_MIN_DIMENSION}×${LOGO_MIN_DIMENSION} pixels.`,
            );
            return;
          }
        }
        setError(null);
        setLogo(dataUrl);
      } catch {
        setError("Não foi possível ler a imagem.");
      }
    };
    reader.readAsDataURL(file);
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);

    const payload: Record<string, string | null> = {};
    if (nameChanged) {
      const parsedName = companyNameSchema.safeParse(name);
      if (!parsedName.success) {
        setError(parsedName.error.issues[0]?.message ?? "Dados inválidos.");
        return;
      }
      payload.nome = parsedName.data;
    }
    if (logoChanged) {
      if (logo !== null) {
        const parsedLogo = companyLogoSchema.safeParse(logo);
        if (!parsedLogo.success) {
          setError(parsedLogo.error.issues[0]?.message ?? "Dados inválidos.");
          return;
        }
        payload.logo = parsedLogo.data;
      } else {
        payload.logo = null;
      }
    }

    if (Object.keys(payload).length === 0) {
      toast.info("Nenhuma alteração para salvar.");
      return;
    }

    updateMutation.mutate(payload, {
      onSuccess: () => {
        toast.success("Configurações salvas com sucesso!");
      },
      onError: (err) => setError(getErrorMessage(err)),
    });
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Identidade da empresa</CardTitle>
        <CardDescription>
          Personalize o nome e a logo exibidos em todo o sistema (white-label).
        </CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          {error ? (
            <div
              role="alert"
              className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive"
            >
              <TriangleAlert className="size-4 shrink-0" />
              {error}
            </div>
          ) : null}

          <div className="space-y-2">
            <Label htmlFor="company-name">Nome da empresa</Label>
            <Input
              id="company-name"
              type="text"
              placeholder="Mirante"
              value={name}
              onChange={(event) => setName(event.target.value)}
              required
              maxLength={80}
              disabled={updateMutation.isPending}
            />
          </div>

          <div className="space-y-2">
            <Label>Logo</Label>
            <div className="flex items-center gap-4">
              {logo !== null ? (
                <img
                  src={logo}
                  alt="Prévia da logo"
                  className="size-16 rounded-lg border border-border object-contain"
                />
              ) : (
                <div className="flex size-16 items-center justify-center rounded-lg border border-dashed border-border bg-muted/40 text-muted-foreground">
                  <ImagePlus className="size-6" />
                </div>
              )}
              <div className="flex flex-col gap-2">
                <input
                  ref={fileInputRef}
                  type="file"
                  accept={LOGO_ACCEPTED_TYPES.join(",")}
                  onChange={handleLogoSelected}
                  className="hidden"
                  aria-label="Escolher logo"
                />
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  disabled={updateMutation.isPending}
                  onClick={() => fileInputRef.current?.click()}
                >
                  <ImagePlus />
                  {logo !== null ? "Trocar logo" : "Enviar logo"}
                </Button>
                {logo !== null ? (
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="text-destructive hover:text-destructive"
                    disabled={updateMutation.isPending}
                    onClick={() => setLogo(null)}
                  >
                    <Trash2 />
                    Remover logo
                  </Button>
                ) : null}
              </div>
            </div>
            <p className="text-xs text-muted-foreground">
              PNG, JPEG, WebP ou SVG · quadrado 512×512 px (mín. 128×128 px
              p/ raster) · máx. 1 MB.
            </p>
          </div>

          <Button
            type="submit"
            disabled={updateMutation.isPending || !hasChanges}
            className="w-full"
          >
            {updateMutation.isPending ? (
              <>
                <Loader2 className="animate-spin" />
                Salvando...
              </>
            ) : (
              "Salvar alterações"
            )}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}