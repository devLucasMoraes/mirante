# AGENTS.md

## Stack
- pnpm (9.0.0) monorepo + Turborepo. Use `pnpm`, never npm/yarn.
- Vite + React 19 + strict TypeScript for the single app `apps/web` (Vite dev server, default port 5173).
- Global/shared state must use **Zustand** (`apps/web/src/features/auth/auth.store.ts` is the reference pattern, with `persist` middleware as needed). **Do not use React Context API for global or shared state** — Context is reserved only for true dependency injection from third-party libraries.
- HTTP is done with **axios** (`apps/web/src/api/client.ts` handles the `Authorization` header and the 401 → refresh-token retry flow) and API boundaries/inputs are validated with **zod**. The web exposes one typed function per endpoint in `apps/web/src/api/<domain>.api.ts` — never call `api.*` directly in pages.
- All non-auth server state in the web app must go through **TanStack Query** (`@tanstack/react-query`, QueryClient in `apps/web/src/app/query-client.ts`, mounted in `providers.tsx`). Every `api/<domain>.api.ts` function is consumed via hooks from `features/<domain>/<domain>.queries.ts` (`queryOptions` + `use<X>Query` + `use<X>Mutation`), with a key factory in `features/<domain>/<domain>.query-keys.ts`; mutations call `queryClient.invalidateQueries({ queryKey: keys.all })` in their `onSuccess`. Auth routes (`login`/`logout`/`refresh`) stay outside TanStack Query (handled by the Zustand auth store and the axios interceptor).
- Authorization rules must always live in **`@repo/authorization`** (CASL + zod) — it is the single source of truth for what each user can do. Never hard-code role checks (e.g. `user.role === "admin"`) in apps; edit rules in the package (`src/ability.ts`) and consume them via `defineAbilityFor` (web) or `getUserAbility`/`requireAbility` (api, `apps/api/src/lib/authorization.ts`).
- No test framework or CI is configured in this repo.

## Commands (run from repo root)
- `pnpm dev` / `pnpm build` / `pnpm lint` / `pnpm check-types` — Turbo-routed across all packages; filter with `--filter=mirante-web`.
- App `lint` runs `eslint . --max-warnings 0` — **warnings fail the lint task**.
- App `check-types` and `build` use `tsc -b` (project references to `tsconfig.app.json` / `tsconfig.node.json`) — don't run bare `tsc` in `apps/*`.

## Workspace layout
- `apps/api` — Fastify + Mongoose API (`apps/api/src`). Layered by concern, every layer has a barrel `index.ts`: `types/` (Fastify/JWT augmentations), `lib/` (errors, authorization bridge), `models/` (Mongoose schemas), `schemas/` (zod), `services/` (business logic — `auth.service.ts` = token lifecycle), `hooks/` (preHandlers like `authenticate`), `plugins/` (Fastify plugins), `routes/` (HTTP handlers, thin). Files are named `<domain>.<layer>.ts` and use only **named exports**; `app.ts` is the single wiring point (plugins → routes) and `config.ts` validates env. Dependency direction: `routes → hooks → services → models`; everything may use `lib/`, `schemas/`, `types/`.
- `apps/web` — Vite + React app. Entrypoints: `src/main.tsx` (mounts `src/App.tsx`), `index.html`, `vite.config.ts`. Its `vite.config.ts` adds `optimizeDeps.exclude: ["@repo/ui"]` so the shared source package is transformed by Vite. Uses **Tailwind CSS v4** (`@tailwindcss/vite` plugin) + **shadcn/ui** components (`new-york` style, `neutral`). Structure: `app/` (route map + providers), `api/` (`<domain>.api.ts` typed HTTP), `features/<domain>/` (vertical slices: store/schemas/queries/query-keys/components/guards), `layouts/`, `pages/<name>.page.tsx` (thin route components), `components/` (shared UI), `lib/` (utils). Files use the same `<domain>.<layer>.ts` naming as the API (`auth.store.ts`, `home.page.tsx`, `protected.route.tsx`) and every folder exposes a barrel `index.ts`; imports use the `@/` alias and are ordered by `simple-import-sort`.
- `apps/web/src/index.css` — Tailwind v4 CSS-first theme (`@import "tailwindcss"` + `tk-animate-css`, `@custom-variant dark`, OKLCH vars in `:root`/`.dark`).
- `packages/ui` (`@repo/ui`) — TypeScript React components. **No build step**: its `exports` map exposes `./components/*` → `./src/components/*.tsx` and `./lib/*` → `./src/lib/*.ts`, so import subpaths directly (e.g. `@repo/ui/components/button`), and editing a component takes effect immediately. The **shadcn/ui primitives live here** (`src/components/*.tsx`, importing `cn` from `../lib/utils`); add/update them with `pnpm dlx shadcn@latest init/add` (`components.json` declares `@repo/ui` aliases) and normalize any `@/...` imports to relative ones afterwards.
- `packages/eslint-config` — shared configs (`base`, `react-internal`); `packages/typescript-config` — shared `tsconfig` presets.
- `packages/authorization` (`@repo/authorization`) — shared CASL abilities and zod subjects (`src/ability.ts` holds the rules). No build step; consumed as source by both `web` (Vite) and `api` (Node 24 type-stripping). Because the API executes it under Node, its relative imports use explicit `.ts` extensions and `package.json` sets `"type": "module"` — preserve both when editing it.

## Wingraphex — banco legado (réplica local em Docker)

- Réplica local do ERP Wingraphex (gráfica, MySQL 5.7.26, latin1): **`docker-compose.wingraphex.yml`** (serviço `wingraphex-db`, porta host **3308**). Assets em **`docker/wingraphex/`**: `initdb/01-schema.sql` (557 tabelas, sem dados) + `initdb/02-dados.sql` (amostra real, 42 tabelas), `scripts/extrai-dados.sh` (regenera a amostra) e `.env.example` → `.env` (gitignorado).
- Produção original: `192.168.1.16:3307` (nunca confundir com a réplica 3308). **Acesso ao banco é estritamente somente leitura** (SELECT/SHOW/information_schema — nunca DML/DDL), na réplica e na produção.
- Subir a réplica (1ª vez popula o volume):
  ```sh
  cp docker/wingraphex/.env.example docker/wingraphex/.env   # se ainda não existe
  `pnpm db:wingraphex:up`                                    # demais scripts: db:wingraphex:down / :reset / :logs
  ```
  Aguardar "ready for connections" no `docker logs wingraphex-db`; o healthcheck pode passar antes do initdb terminar.
- Conectar na réplica: `mysql --ssl-mode=DISABLED --default-character-set=utf8 -h 127.0.0.1 -P 3308 -u _consulta wingraphex` (senha em `docker/wingraphex/.env`).
- Regenerar a amostra (somente leitura contra a produção): `docker/wingraphex/scripts/extrai-dados.sh` — le `WINGRAPHEX_READ_PASSWORD` de `docker/wingraphex/.env`.
- Conhecimento de schema/relatórios/fluxos: skill `wingraphex-erp` (`.opencode/skills/wingraphex-erp/`, references + `schema-wingraphex.sql`). Sem FKs declaradas; `EMP_ID` sempre no WHERE; usar `--default-character-set=utf8`.
- `docker/wingraphex/.env` guarda também a senha de produção (`WINGRAPHEX_READ_PASSWORD`) — nunca commitar (`docker/wingraphex/.env` é ignorado pelo `.gitignore`).

### Conexão da API ao Wingraphex (dev vs prod)

- `apps/api` consome o Wingraphex como **somente leitura** através do plugin `wingraphexPlugin` (`plugins/wingraphex.plugin.ts`, `@fastify/mysql` com `promise: true`), que decora `fastify.wingraphex` (pool `MySQLPromisePool`).
- **A escolha dev/prod é automática pelo `NODE_ENV`** em `config.ts`: `development`/`test` → `WINGRAPHEX_DB_HOST=127.0.0.1`, `WINGRAPHEX_DB_PORT=3308` (réplica Docker; subir com `pnpm db:wingraphex:up`); `production` → `192.168.1.16:3307` (banco real da rede da empresa). Qualquer valor pode ser sobrescrito via variáveis `WINGRAPHEX_DB_*` no `.env.<NODE_ENV>`.
- Senha `WINGRAPHEX_DB_PASSWORD`: em dev é o `MYSQL_PASSWORD` (usuário `_consulta` da réplica); em prod é o `WINGRAPHEX_READ_PASSWORD`. Ambas vivem em `docker/wingraphex/.env` — copiar para `.env.<NODE_ENV>` (gitignorado), nunca commitar.
- **Pool é lazy** (a API sobe mesmo com o banco fora do alcance — ex.: prod `192.168.1.16` inacessível da rede doméstica); o `onReady` loga o status com `SELECT 1` e `GET /health` reporta `wingraphex: boolean` em 1,5s.
- **Segurança:** `GET /api/wingraphex/*` exige `authenticate` + `requireAbility("read", "WingraphexOp")` (regra em `@repo/authorization`, válida para **todas** as roles). Só existem as consultas **programadas** em `services/wingraphex.service.ts` (ex.: `queryOpsByDescription` = relatório `consulta-ops-por-descricao`). **Nunca** criar endpoint de query genérica/raw SQL ou deixar o pool acessível a rotas arbitrárias — qualquer outra forma de consulta é bloqueada.

## Gotchas
- TS presets enable `verbatimModuleSyntax`, `strict`, and `noUncheckedIndexedAccess` — use `import type` for type-only imports and narrow nullable array/object access. This applies to `packages/ui` too (typechecked from the app's project references).
- `turbo.json` marks `dev` tasks as persistent and uncached; `build` outputs `dist/**` and consumes `.env*` inputs.
- Tailwind v4 must see the `@repo/ui` source or its classes won't be emitted. `apps/web/src/index.css` keeps `@source "../node_modules/@repo/ui/src";` (resolved from `apps/web`, not from the CSS file). Don't remove it; relative `@source` paths pointing at `../../packages/...` don't work with `@tailwindcss/vite`.
- Theme (light/dark/system) is a **Zustand persisted store** (`apps/web/src/features/theme/theme.store.ts`) synced to `<html>.dark` by `apps/web/src/features/theme/theme.provider.tsx` + an inline anti-FOUC script in `index.html`. There's no Context-based ThemeProvider.