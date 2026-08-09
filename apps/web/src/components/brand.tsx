import { Sparkles } from "lucide-react";
import { cn } from "@repo/ui/lib/utils";

type BrandLogoProps = {
  className?: string;
  size?: "sm" | "md";
};

export function BrandLogo({ className, size = "md" }: BrandLogoProps) {
  const iconBox =
    size === "sm"
      ? "size-7 rounded-lg [&_svg]:size-4"
      : "size-8 rounded-lg [&_svg]:size-5";

  return (
    <div className={cn("flex items-center gap-2", className)}>
      <span
        className={cn(
          "flex items-center justify-center bg-primary text-primary-foreground",
          iconBox,
        )}
      >
        <Sparkles />
      </span>
      <span
        className={cn(
          "font-semibold tracking-tight text-foreground",
          size === "sm" ? "text-sm" : "text-lg",
        )}
      >
        acme
      </span>
    </div>
  );
}