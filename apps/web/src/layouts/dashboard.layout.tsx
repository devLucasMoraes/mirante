import { NavLink, Outlet, useNavigate } from "react-router";

import { useAbility } from "@casl/react";
import {
  ClipboardList,
  LogOut,
  Menu,
  Settings,
  UserRound,
  Users,
  Workflow,
} from "lucide-react";

import { Avatar, AvatarFallback } from "@repo/ui/components/avatar";
import { Badge } from "@repo/ui/components/badge";
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
import { cn } from "@repo/ui/lib/utils";

import { BrandLogo } from "@/components/brand-logo";
import { useAuthStore } from "@/features/auth/auth.store";
import { ThemeToggle } from "@/features/theme/theme-toggle";

function getInitials(name: string, username: string): string {
  const source = name.trim() || username.trim();
  return source.slice(0, 2).toUpperCase() || "A";
}

function UserMenu() {
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);
  const ability = useAbility();
  const navigate = useNavigate();

  const username = user?.username ?? "";
  const name = user?.name ?? username;
  const isAdmin = ability.can("manage", "User");

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
              {getInitials(name, username)}
            </AvatarFallback>
          </Avatar>
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        <DropdownMenuLabel className="flex flex-col gap-0.5">
          <span className="flex items-center gap-2 text-sm font-medium text-foreground">
            {name}
            {isAdmin ? <Badge variant="secondary">Admin</Badge> : null}
          </span>
          <span className="text-xs font-normal text-muted-foreground">
            @{username}
          </span>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem onClick={() => navigate("/dashboard/perfil")}>
          <UserRound />
          Meu perfil
        </DropdownMenuItem>
        <DropdownMenuItem
          variant="destructive"
          onClick={() => void handleLogout()}
        >
          <LogOut className="text-destructive" />
          Sair
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

function SidebarNav({
  isAdmin,
  canUpdateSettings,
}: {
  isAdmin: boolean;
  canUpdateSettings: boolean;
}) {
  const items = [
    {
      label: "Ordens de produção",
      href: "/dashboard",
      icon: ClipboardList,
    },
    {
      label: "PCP",
      href: "/dashboard/pcp",
      icon: Workflow,
    },
    { label: "Perfil", href: "/dashboard/perfil", icon: UserRound },
    ...(isAdmin
      ? [{ label: "Usuários", href: "/dashboard/usuarios", icon: Users }]
      : []),
    ...(canUpdateSettings
      ? [
          {
            label: "Configurações",
            href: "/dashboard/configuracoes",
            icon: Settings,
          },
        ]
      : []),
  ];

  return (
    <nav className="flex-1 space-y-1 p-4">
      {items.map((item) => (
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

function SidebarCredit() {
  return (
    <p className="border-t border-border px-4 py-3 text-xs text-muted-foreground">
      Mirante · desenvolvido por devLucasMoraes
    </p>
  );
}

function MobileMenu({
  isAdmin,
  canUpdateSettings,
}: {
  isAdmin: boolean;
  canUpdateSettings: boolean;
}) {
  return (
    <Sheet>
      <SheetTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="md:hidden"
          aria-label="Abrir menu"
        >
          <Menu />
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="flex w-72 flex-col p-0">
        <div className="flex h-16 items-center border-b border-border px-6">
          <BrandLogo />
        </div>
        <SidebarNav isAdmin={isAdmin} canUpdateSettings={canUpdateSettings} />
        <SidebarCredit />
      </SheetContent>
    </Sheet>
  );
}

export function DashboardLayout() {
  const ability = useAbility();
  const isAdmin = ability.can("manage", "User");
  const canUpdateSettings = ability.can("update", "CompanySettings");

  return (
    <div className="flex min-h-svh">
      <aside className="hidden w-64 shrink-0 flex-col border-r border-border md:flex">
        <div className="flex h-16 items-center border-b border-border px-6">
          <BrandLogo size="sm" />
        </div>
        <SidebarNav isAdmin={isAdmin} canUpdateSettings={canUpdateSettings} />
        <SidebarCredit />
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex h-16 items-center justify-between gap-4 border-b border-border px-4 md:px-6">
          <div className="flex items-center gap-2">
            <MobileMenu isAdmin={isAdmin} canUpdateSettings={canUpdateSettings} />
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
