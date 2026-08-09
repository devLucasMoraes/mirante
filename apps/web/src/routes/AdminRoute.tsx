import { Navigate, Outlet } from "react-router";
import { useAuthStore } from "../auth/authStore";

export function AdminRoute() {
  const isAdmin = useAuthStore((state) => state.user?.role === "admin");

  if (!isAdmin) {
    return <Navigate to="/dashboard" replace />;
  }

  return <Outlet />;
}
