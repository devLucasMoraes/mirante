import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "node",
    globalSetup: ["./src/test/global-setup.ts"],
    setupFiles: ["./src/test/setup.ts"],
    include: ["src/**/*.test.ts"],
    restoreMocks: true,
    hookTimeout: 30_000,
    testTimeout: 15_000,
    coverage: {
      provider: "v8",
      reporter: ["text", "html"],
      exclude: [
        "**/node_modules/**",
        "**/dist/**",
        "**/.turbo/**",
        "**/*.config.*",
        "**/*.test.ts",
        "**/test/**",
      ],
    },
  },
});