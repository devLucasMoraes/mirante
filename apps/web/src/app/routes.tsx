import { Route, Routes } from "react-router";

import { AdminRoute } from "@/features/auth/admin.route";
import { ProtectedRoute } from "@/features/auth/protected.route";
import { PublicRoute } from "@/features/auth/public.route";
import { AuthLayout } from "@/layouts/auth.layout";
import { DashboardLayout } from "@/layouts/dashboard.layout";
import { PublicLayout } from "@/layouts/public.layout";
import { DashboardPage } from "@/pages/dashboard.page";
import { HomePage } from "@/pages/home/home.page";
import { LoginPage } from "@/pages/login.page";
import { NotFoundPage } from "@/pages/not-found.page";
import { PcpPage } from "@/pages/pcp.page";
import { ProfilePage } from "@/pages/profile.page";
import { UnauthorizedPage } from "@/pages/unauthorized.page";
import { UsersPage } from "@/pages/users.page";

export function AppRoutes() {
  return (
    <Routes>
      <Route element={<PublicLayout />}>
        <Route path="/" element={<HomePage />} />
        <Route path="/unauthorized" element={<UnauthorizedPage />} />
        <Route path="*" element={<NotFoundPage />} />
      </Route>

      <Route element={<AuthLayout />}>
        <Route element={<PublicRoute />}>
          <Route path="/login" element={<LoginPage />} />
        </Route>
      </Route>

      <Route element={<ProtectedRoute />}>
        <Route element={<DashboardLayout />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/dashboard/pcp" element={<PcpPage />} />
          <Route path="/dashboard/perfil" element={<ProfilePage />} />
          <Route element={<AdminRoute />}>
            <Route path="/dashboard/usuarios" element={<UsersPage />} />
          </Route>
        </Route>
      </Route>
    </Routes>
  );
}
