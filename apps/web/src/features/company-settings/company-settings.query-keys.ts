export const companySettingsKeys = {
  all: ["company-settings"] as const,
  lists: () => [...companySettingsKeys.all, "list"] as const,
  list: () => [...companySettingsKeys.lists()] as const,
};