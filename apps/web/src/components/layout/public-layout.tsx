import { Link, Outlet } from "react-router";
import { Button } from "@repo/ui/components/button";
import { BrandLogo } from "@/components/brand";
import { ThemeToggle } from "@/components/theme/theme-toggle";

const NAV_ITEMS = [
  { label: "Recursos", href: "#recursos" },
  { label: "Preços", href: "#precos" },
  { label: "Depoimentos", href: "#depoimentos" },
  { label: "FAQ", href: "#faq" },
];

export function PublicLayout() {
  return (
    <div className="flex min-h-svh flex-col">
      <header className="sticky top-0 z-40 border-b border-border bg-background/80 backdrop-blur-sm">
        <div className="mx-auto flex h-16 w-full max-w-7xl items-center justify-between px-6">
          <BrandLogo />
          <nav className="hidden items-center gap-1 md:flex">
            {NAV_ITEMS.map((item) => (
              <a
                key={item.href}
                href={item.href}
                className="rounded-md px-3 py-2 text-sm text-muted-foreground transition-colors hover:text-foreground"
              >
                {item.label}
              </a>
            ))}
          </nav>
          <div className="flex items-center gap-2">
            <ThemeToggle />
            <div className="hidden items-center gap-2 sm:flex">
              <Button asChild>
                <Link to="/login">Entrar</Link>
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="flex-1">
        <Outlet />
      </main>

      <footer className="border-t border-border">
        <div className="mx-auto flex w-full max-w-7xl flex-col items-center justify-between gap-4 px-6 py-8 sm:flex-row">
          <BrandLogo size="sm" />
          <p className="text-sm text-muted-foreground">
            © {new Date().getFullYear()} acme. Todos os direitos reservados.
          </p>
          <div className="flex items-center gap-4 text-sm text-muted-foreground">
            <Link to="/login" className="hover:text-foreground">
              Entrar
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
