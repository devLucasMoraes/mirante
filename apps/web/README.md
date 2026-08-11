# web

Vite + React 19 + TypeScript (strict) + Tailwind CSS v4 + shadcn/ui. Parte do monorepo Turborepo — rode os comandos pela raiz:

- `pnpm dev` — dev server do Vite (porta 5173)
- `pnpm build` — typecheck + build
- `pnpm lint` — ESLint (`--max-warnings 0`)
- `pnpm check-types` — `tsc -b`

## Como o fluxo funciona

```
main.tsx → App.tsx → app/providers.tsx + app/routes.tsx → layouts → pages/features
```

- `main.tsx` — entrypoint: monta o `BrowserRouter` e o `App`.
- `App.tsx` — compõe providers + rotas + `Toaster`. Sem lógica.
- `app/routes.tsx` — **mapa de navegação do app**: todas as rotas, guards e layouts em um arquivo só.
- `app/providers.tsx` — providers globais (theme + CASL ability). Não usa Context manual.
- `layouts/` — shells que envolvem grupos de rotas (`public`, `auth`, `dashboard`).
- `pages/` — componentes de rota, finos: montam estado, dados e UI. Onde há lógica real, ela mora nas `features/` e na camada `api/`.

## Estrutura de pastas

Cada pasta é uma camada/feature e expõe um barrel `index.ts` (o que a camada oferece é visível de relance, sem o modelo/precisar varrer o `src` inteiro).

```
src/
├── main.tsx               # entrypoint (BrowserRouter + App)
├── App.tsx                # composição: providers + rotas + toaster
├── app/                   # wiring do app: routes (mapa de rotas) + providers
├── api/                   # camada HTTP: client (axios/interceptors) + <dominio>.api.ts
├── features/              # fatias verticais: auth, users, theme (store/schemas/ui juntos)
├── layouts/               # shells de layout (public, auth, dashboard)
├── pages/                 # componentes de rota (thin) + conteúdo por página
├── components/            # UI compartilhada entre features (brand-logo)
└── lib/                   # utilidades app-level (error-message)
```

Exemplo de árvore:

```
src/
├── app/
│   ├── routes.tsx         # todas as <Route>
│   └── providers.tsx      # ThemeProvider + AppAbilityProvider
├── api/
│   ├── client.ts          # axios + retry 401/refresh
│   ├── auth.api.ts        # login, logout
│   └── users.api.ts       # list/create/update/delete + parse zod
├── features/
│   ├── auth/
│   │   ├── auth.store.ts  # Zustand persistido
│   │   ├── auth.schemas.ts
│   │   ├── ability.provider.tsx
│   │   ├── protected.route.tsx / public.route.tsx / admin.route.tsx
│   ├── users/
│   │   ├── users.schemas.ts
│   │   ├── users-table.tsx
│   │   └── user-form-sheet.tsx
│   └── theme/
│       ├── theme.store.ts / theme.provider.tsx
│       ├── theme-toggle.tsx / toaster.tsx
├── layouts/               # public.layout / auth.layout / dashboard.layout
├── pages/
│   ├── login.page.tsx, dashboard.page.tsx, users.page.tsx, ...
│   └── home/              # página de marketing quebrada em seções
└── lib/error-message.ts
```

## Convenções

- **Naming**: arquivos de camada seguem `<dominio>.<camada>.ts` (ex.: `auth.store.ts`, `home.page.tsx`, `protected.route.tsx`, `users.api.ts`). Componente visual (JSX sem lógica de camada) leva só o nome kebab-case (`brand-logo.tsx`, `users-table.tsx`). Sempre **named exports** (sem `export default`), exceto `main.tsx`/`App.tsx`.
- **Barrels**: toda pasta tem `index.ts` reexportando o que ela expõe. Fora da camada, importe pelo barrel (`@/features/users`); dentro dela, pelo arquivo direto.
- **Imports**: sempre via alias `@/` (`@/features/...`, `@/api/...`, `@/lib/...`). Ordem de imports é automática via `simple-import-sort` (grupos: side-effect → react → externos → `@repo/` → `@/` → relativos) — não quebre a ordem, rode `eslint --fix`.
- **Tipos**: use `import type` para imports apenas de tipo (`verbatimModuleSyntax`). Narrowing obrigatório em acesso de array/objeto anulável (`noUncheckedIndexedAccess`).
- **Estado global**: Zustand, nunca Context manual. Referência: `features/auth/auth.store.ts` (com `persist`).
- **HTTP**: nunca chame `api.*` direto numa página — crie a função tipada em `api/<dominio>.api.ts` (faz o parse zod) e consuma de lá.
- **Autorização**: regras vivem em `@repo/authorization` (única fonte de verdade). Consuma via `useAbility()`/`<Can>`/`defineAbilityFor`; nunca hard-code `user.role === "admin"` no app. Guards de rota ficam em `features/auth/*.route.tsx`.
- **shadcn/ui**: primitivas vivem em `@repo/ui`; o app importa por subcaminho (`@repo/ui/components/button`).

## Adicionar uma feature nova

1. `features/<dominio>/<dominio>.store.ts` — estado Zustand (se houver).
2. `features/<dominio>/<dominio>.schemas.ts` — validação zod.
3. `api/<dominio>.api.ts` — funções HTTP tipadas (list/create/update/delete + parse).
4. `features/<dominio>/` — componentes da feature (tabela, formulário etc.).
5. `pages/<dominio>.page.tsx` — página fina compondo estado + UI.
6. Registrar a rota em `app/routes.tsx` (com guard/layout se precisar) e reexportar nos barrels.
