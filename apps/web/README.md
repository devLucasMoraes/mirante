# web

This is the [Vite](https://vite.dev) + [React](https://react.dev) + TypeScript app in the Turborepo monorepo. Run from the repo root:

- `pnpm dev` — start the Vite dev server (port 5173)
- `pnpm build` — typecheck and build
- `pnpm lint` — ESLint
- `pnpm check-types` — `tsc -b`

It consumes the shared `@repo/ui` package (imported as source, e.g. `@repo/ui/components/button`).