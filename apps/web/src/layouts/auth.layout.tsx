import { Outlet } from "react-router";

import { BrandLogo } from "@/components/brand-logo";
import { ThemeToggle } from "@/features/theme/theme-toggle";

export function AuthLayout() {
  return (
    <div className="flex min-h-svh flex-col">
      <header className="flex h-16 items-center justify-between px-6">
        <BrandLogo />
        <ThemeToggle />
      </header>

      <main className="flex flex-1 items-center justify-center px-6 pb-12">
        <div className="w-full max-w-sm">
          <Outlet />
        </div>
      </main>
    </div>
  );
}