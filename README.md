# Mirante

Consultas rápidas e inteligentes sobre o ERP legado (Wingraphex) da gráfica, com uma UI/UX moderna e sem mexer no banco de origem — acesso estritamente somente leitura.

A [Turborepo](https://turborepo.dev) monorepo powered by [pnpm](https://pnpm.io).

## Apps and Packages

- `apps/web` — a [Vite](https://vite.dev) + [React](https://react.dev) + TypeScript app (see [its README](apps/web/README.md) for the folder/flow conventions)
- `apps/api` — a [Fastify](https://fastify.dev) + [Mongoose](https://mongoosejs.com) API (`:3000/api`) with cookie-only auth
- `packages/ui` (`@repo/ui`) — a React component library (no build step; imported as TSX source)
- `packages/eslint-config` — shared ESLint configs (`base`, `react-internal`); includes `simple-import-sort` for consistent import ordering
- `packages/typescript-config` — shared `tsconfig` presets

Every package is 100% TypeScript.

## Getting Started

```sh
pnpm install
pnpm dev
```

Run `pnpm dev` from the repo root to start the Fastify API (`:3000`) and the Vite dev server at <http://localhost:5173>. The API requires MongoDB (see `docker compose up -d`).

## Scripts

Run from the repo root. Tasks are routed through Turborepo; filter with `--filter=<package>`.

| Command             | Description                                              |
| ------------------- | -------------------------------------------------------- |
| `pnpm dev`          | Start the Vite dev server                                |
| `pnpm build`        | Build all packages                                       |
| `pnpm lint`         | ESLint for all packages (`--max-warnings 0`)             |
| `pnpm check-types`  | Typecheck all packages (`tsc --noEmit` / `tsc -b`)       |
| `pnpm format`       | Prettier across the repo                                 |