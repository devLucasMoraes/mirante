import { Sparkles } from "lucide-react";

import { cn } from "@repo/ui/lib/utils";

import { useCompanySettingsStore } from "@/features/company-settings/company-settings.store";

type BrandLogoProps = {
  className?: string;
  size?: "sm" | "md";
};

export function BrandLogo({ className, size = "md" }: BrandLogoProps) {
  const branding = useCompanySettingsStore((state) => state.branding);

  const iconBox =
    size === "sm"
      ? "size-7 rounded-lg [&_svg]:size-4"
      : "size-8 rounded-lg [&_svg]:size-5";

  return (
    <div className={cn("flex items-center gap-2", className)}>
      {branding.logo !== null ? (
        <img
          src={branding.logo}
          alt=""
          className={cn(
            "object-contain",
            size === "sm" ? "size-7" : "size-8",
          )}
        />
      ) : (
        <span
          className={cn(
            "flex items-center justify-center bg-primary text-primary-foreground",
            iconBox,
          )}
        >
          <Sparkles />
        </span>
      )}
      <span
        className={cn(
          "font-semibold tracking-tight text-foreground",
          size === "sm" ? "text-sm" : "text-lg",
        )}
      >
        {branding.companyName}
      </span>
    </div>
  );
}