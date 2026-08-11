import { Navigate, Outlet } from "react-router";

import { useAbility } from "@casl/react";

export function AdminRoute() {
  const ability = useAbility();

  if (ability.cannot("manage", "User")) {
    return <Navigate to="/dashboard" replace />;
  }

  return <Outlet />;
}