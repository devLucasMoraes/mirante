# my-monorepo

A [Turborepo](https://turborepo.dev) monorepo powered by [pnpm](https://pnpm.io).

## Apps and Packages

- `apps/web` — a [Vite](https://vite.dev) + [React](https://react.dev) + TypeScript app
- `apps/mock-server` — a Node [json-server](https://github.com/typicode/json-server) with JWT auth endpoints (`:3333/api`)
- `packages/ui` (`@repo/ui`) — a React component library (no build step; imported as TSX source)
- `packages/eslint-config` — shared ESLint configs (`base`, `react-internal`)
- `packages/typescript-config` — shared `tsconfig` presets

The app and library packages are 100% TypeScript (the mock server is plain Node).

## Getting Started

```sh
pnpm install
pnpm dev
```

Run `pnpm dev` from the repo root to start the Vite dev server at <http://localhost:5173>.

## Scripts

Run from the repo root. Tasks are routed through Turborepo; filter with `--filter=<package>`.

| Command             | Description                                              |
| ------------------- | -------------------------------------------------------- |
| `pnpm dev`          | Start the Vite dev server                                |
| `pnpm build`        | Build all packages                                       |
| `pnpm lint`         | ESLint for all packages (`--max-warnings 0`)             |
| `pnpm check-types`  | Typecheck all packages (`tsc --noEmit` / `tsc -b`)       |
| `pnpm format`       | Prettier across the repo                                 |