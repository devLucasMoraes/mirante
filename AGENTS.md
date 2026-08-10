# AGENTS.md

## Stack
- pnpm (9.0.0) monorepo + Turborepo. Use `pnpm`, never npm/yarn.
- Vite + React 19 + strict TypeScript for the single app `apps/web` (Vite dev server, default port 5173).
- Global/shared state must use **Zustand** (`apps/web/src/auth/authStore.ts` is the reference pattern, with `persist` middleware as needed). **Do not use React Context API for global or shared state** — Context is reserved only for true dependency injection from third-party libraries.
- HTTP is done with **axios** (`apps/web/src/auth/apiClient.ts` handles the `Authorization` header and the 401 → refresh-token retry flow) and API boundaries/inputs are validated with **zod** (`apps/web/src/auth/schemas.ts`).
- Authorization rules must always live in **`@repo/authorization`** (CASL + zod) — it is the single source of truth for what each user can do. Never hard-code role checks (e.g. `user.role === "admin"`) in apps; edit rules in the package (`src/ability.ts`) and consume them via `defineAbilityFor` (web) or `getUserAbility`/`requireAbility` (api, `apps/api/src/authorization.ts`).
- No test framework or CI is configured in this repo.

## Commands (run from repo root)
- `pnpm dev` / `pnpm build` / `pnpm lint` / `pnpm check-types` — Turbo-routed across all packages; filter with `--filter=web`.
- App `lint` runs `eslint . --max-warnings 0` — **warnings fail the lint task**.
- App `check-types` and `build` use `tsc -b` (project references to `tsconfig.app.json` / `tsconfig.node.json`) — don't run bare `tsc` in `apps/*`.

## Workspace layout
- `apps/web` — Vite + React app. Entrypoints: `src/main.tsx` (mounts `src/App.tsx`), `index.html`, `vite.config.ts`. Its `vite.config.ts` adds `optimizeDeps.exclude: ["@repo/ui"]` so the shared source package is transformed by Vite. Uses **Tailwind CSS v4** (`@tailwindcss/vite` plugin) + **shadcn/ui** components (`new-york` style, `neutral`).
- `apps/web/src/index.css` — Tailwind v4 CSS-first theme (`@import "tailwindcss"` + `tk-animate-css`, `@custom-variant dark`, OKLCH vars in `:root`/`.dark`).
- `packages/ui` (`@repo/ui`) — TypeScript React components. **No build step**: its `exports` map exposes `./components/*` → `./src/components/*.tsx` and `./lib/*` → `./src/lib/*.ts`, so import subpaths directly (e.g. `@repo/ui/components/button`), and editing a component takes effect immediately. The **shadcn/ui primitives live here** (`src/components/*.tsx`, importing `cn` from `../lib/utils`); add/update them with `pnpm dlx shadcn@latest init/add` (`components.json` declares `@repo/ui` aliases) and normalize any `@/...` imports to relative ones afterwards.
- `packages/eslint-config` — shared configs (`base`, `react-internal`); `packages/typescript-config` — shared `tsconfig` presets.
- `packages/authorization` (`@repo/authorization`) — shared CASL abilities and zod subjects (`src/ability.ts` holds the rules). No build step; consumed as source by both `web` (Vite) and `api` (Node 24 type-stripping). Because the API executes it under Node, its relative imports use explicit `.ts` extensions and `package.json` sets `"type": "module"` — preserve both when editing it.

## Gotchas
- TS presets enable `verbatimModuleSyntax`, `strict`, and `noUncheckedIndexedAccess` — use `import type` for type-only imports and narrow nullable array/object access. This applies to `packages/ui` too (typechecked from the app's project references).
- `turbo.json` marks `dev` tasks as persistent and uncached; `build` outputs `dist/**` and consumes `.env*` inputs.
- Tailwind v4 must see the `@repo/ui` source or its classes won't be emitted. `apps/web/src/index.css` keeps `@source "../node_modules/@repo/ui/src";` (resolved from `apps/web`, not from the CSS file). Don't remove it; relative `@source` paths pointing at `../../packages/...` don't work with `@tailwindcss/vite`.
- Theme (light/dark/system) is a **Zustand persisted store** (`apps/web/src/theme/theme-store.ts`) synced to `<html>.dark` by `apps/web/src/theme/theme-provider.tsx` + an inline anti-FOUC script in `index.html`. There's no Context-based ThemeProvider.