import { defineConfig, mergeConfig } from "vitest/config";

import viteConfig from "./vite.config.ts";

export default mergeConfig(
  viteConfig,
  defineConfig({
    test: {
      environment: "jsdom",
      setupFiles: ["./src/test/setup.ts"],
      include: ["src/**/*.test.{ts,tsx}"],
      restoreMocks: true,
      testTimeout: 10_000,
      coverage: {
        provider: "v8",
        reporter: ["text", "html"],
        exclude: [
          "**/node_modules/**",
          "**/dist/**",
          "**/.turbo/**",
          "**/*.config.*",
          "**/*.test.{ts,tsx}",
          "**/test/**",
        ],
      },
    },
  }),
);