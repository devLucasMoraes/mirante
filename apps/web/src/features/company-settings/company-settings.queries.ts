import {
  queryOptions,
  useMutation,
  useQuery,
  useQueryClient,
} from "@tanstack/react-query";

import {
  getCompanySettings,
  updateCompanySettings,
} from "@/api/company-settings.api";

import { companySettingsKeys } from "./company-settings.query-keys";

export const companySettingsQueryOptions = queryOptions({
  queryKey: companySettingsKeys.list(),
  queryFn: getCompanySettings,
});

export function useCompanySettingsQuery() {
  return useQuery(companySettingsQueryOptions);
}

export function useUpdateCompanySettingsMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: updateCompanySettings,
    onSuccess: () => {
      void queryClient.invalidateQueries({
        queryKey: companySettingsKeys.all,
      });
    },
  });
}