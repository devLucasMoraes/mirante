import { Navigate, Outlet, useLocation } from "react-router";

import { useAuthStore } from "@/features/auth/auth.store";

export function ProtectedRoute() {
  const isAuthenticated = useAuthStore((state) => state.user !== null);
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  return <Outlet />;
}
