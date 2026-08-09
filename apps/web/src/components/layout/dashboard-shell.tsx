import { NavLink, Outlet, useNavigate } from "react-router";
import { LayoutDashboard, LogOut, Menu } from "lucide-react";
import { cn } from "@repo/ui/lib/utils";
import { Avatar, AvatarFallback } from "@repo/ui/components/avatar";
import { Button } from "@repo/ui/components/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@repo/ui/components/dropdown-menu";
import { Sheet, SheetContent, SheetTrigger } from "@repo/ui/components/sheet";
import { BrandLogo } from "@/components/brand";
import { ThemeToggle } from "@/components/theme/theme-toggle";
import { useAuthStore } from "@/auth/authStore";

const NAV_ITEMS = [
  { label: "Visão geral", href: "/dashboard", icon: LayoutDashboard },
];

function getInitials(name: string, email: string): string {
  const source = name.trim() || email.trim();
  return source.slice(0, 2).toUpperCase() || "A";
}

function UserMenu() {
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);
  const navigate = useNavigate();

  const email = user?.email ?? "";
  const name = user?.name ?? email;

  const handleLogout = async () => {
    await logout();
    navigate("/login", { replace: true });
  };

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="size-9 rounded-full"
          aria-label="Abrir menu do usuário"
        >
          <Avatar className="size-9">
            <AvatarFallback className="text-xs">
              {getInitials(name, email)}
            </AvatarFallback>
          </Avatar>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel className="flex flex-col gap-0.5">
          <span className="text-sm font-medium text-foreground">{name}</span>
          <span className="text-xs font-normal text-muted-foreground">
            {email}
          </span>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem variant="destructive" onClick={() => void handleLogout()}>
          <LogOut className="text-destructive" />
          Sair
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

function SidebarNav() {
  return (
    <nav className="flex-1 space-y-1 p-4">
      {NAV_ITEMS.map((item) => (
        <NavLink
          key={item.href}
          to={item.href}
          end
          className={({ isActive }) =>
            cn(
              "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors",
              isActive
                ? "bg-accent text-accent-foreground"
                : "text-muted-foreground hover:bg-accent/60 hover:text-accent-foreground",
            )
          }
        >
          <item.icon className="size-4" />
          {item.label}
        </NavLink>
      ))}
    </nav>
  );
}

function MobileMenu() {
  return (
    <Sheet>
      <SheetTrigger asChild>
        <Button variant="ghost" size="icon" className="md:hidden" aria-label="Abrir menu">
          <Menu />
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="flex w-72 flex-col p-0">
        <div className="flex h-16 items-center border-b border-border px-6">
          <BrandLogo />
        </div>
        <SidebarNav />
      </SheetContent>
    </Sheet>
  );
}

export function DashboardShell() {
  return (
    <div className="flex min-h-svh">
      <aside className="hidden w-64 shrink-0 flex-col border-r border-border md:flex">
        <div className="flex h-16 items-center border-b border-border px-6">
          <BrandLogo size="sm" />
        </div>
        <SidebarNav />
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex h-16 items-center justify-between gap-4 border-b border-border px-4 md:px-6">
          <div className="flex items-center gap-2">
            <MobileMenu />
            <span className="text-sm font-medium text-muted-foreground md:hidden">
              Conta
            </span>
          </div>
          <div className="flex items-center gap-2">
            <ThemeToggle />
            <UserMenu />
          </div>
        </header>

        <main className="flex flex-1 flex-col p-6 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}