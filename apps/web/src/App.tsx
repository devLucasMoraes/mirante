import { Route, Routes } from "react-router";
import { ProtectedRoute } from "./routes/ProtectedRoute";
import { PublicRoute } from "./routes/PublicRoute";
import { AdminRoute } from "./routes/AdminRoute";
import { HomePage } from "./pages/HomePage";
import { LoginPage } from "./pages/LoginPage";
import { DashboardPage } from "./pages/DashboardPage";
import { UsersPage } from "./pages/UsersPage";
import { UnauthorizedPage } from "./pages/UnauthorizedPage";
import { NotFoundPage } from "./pages/NotFoundPage";
import { PublicLayout } from "./components/layout/public-layout";
import { AuthLayout } from "./components/layout/auth-layout";
import { DashboardShell } from "./components/layout/dashboard-shell";
import { ThemeProvider } from "./theme/theme-provider";
import { Toaster } from "./components/theme/toaster";

function App() {
  return (
    <ThemeProvider>
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
          <Route element={<DashboardShell />}>
            <Route path="/dashboard" element={<DashboardPage />} />
            <Route element={<AdminRoute />}>
              <Route path="/dashboard/usuarios" element={<UsersPage />} />
            </Route>
          </Route>
        </Route>
      </Routes>
      <Toaster />
    </ThemeProvider>
  );
}

export default App;
