import { Navigate, Outlet } from "react-router";
import { useAuthStore } from "../auth/authStore";

export function PublicRoute() {
  const isAuthenticated = useAuthStore((state) => state.user !== null);

  if (isAuthenticated) {
    return <Navigate to="/dashboard" replace />;
  }

  return <Outlet />;
}
