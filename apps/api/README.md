# Mirante · API

Fastify + Mongoose API with cookie-only authentication (httpOnly signed cookies, refresh-token rotation).

## Como o fluxo funciona

```
server.ts → app.ts → plugins (mongoose, auth) → routes → hooks → services → models
```

- `server.ts` — entrypoint: cria o app e escuta na porta do `config.ts`.
- `app.ts` — **único ponto de wiring**: registra plugins e rotas, em ordem legível. É o mapa do projeto.
- `config.ts` — valida env vars com zod e exporta `config` + `mongoUri`.

## Estrutura de pastas

Cada pasta é uma camada e expõe um barrel `index.ts` (exportações centralizadas — o que a camada oferece é visível de relance).

```
src/
├── app.ts                  # wiring: plugins → rotas (o "fluxo" do projeto)
├── server.ts               # entrypoint (listen)
├── config.ts               # env zod + config + mongoUri
├── seed.ts                 # script: cria/atualiza o admin
├── types/                  # augmentations do Fastify/JWT (JwtUser, AuthService) + barrel
├── lib/                    # infra transversal: errors (AppError), authorization (CASL bridge)
├── models/                 # Mongoose schemas (user.model, refresh-token.model) + DTOs
├── schemas/                # validação zod por domínio (auth.schema, user.schema)
├── services/               # regra de negócio (auth.service = ciclo de tokens, password, cookie)
├── hooks/                  # preHandlers (authenticate)
├── plugins/                # plugins Fastify (auth, mongoose)
└── routes/                 # handlers HTTP, finos (auth, health, user)
```

## Convenções

- **Naming**: arquivos são `<dominio>.<camada>.ts` (ex.: `user.model.ts`, `auth.service.ts`, `authenticate.hook.ts`). Sempre **named exports** (sem `export default`).
- **Barrels**: toda camada tem `index.ts` reexportando o que ela expõe. Importe de fora via barrel; dentro da camada, importe do arquivo direto.
- **Dependência (de cima para baixo, sem ciclos)**: `routes → hooks → services → models`. Tudo pode usar `lib/`, `schemas/`, `types/` e `config.ts`. Camadas inferiores nunca importam camadas superiores.
- **Handlers finos**: rota valida (schema zod) → autoriza (hook) → chama service → devolve DTO. Regra de negócio vive nos services.
- **Imports**: relativos com extensão `.ts` explícita (NodeNext). Use `import type` para imports apenas de tipo (`verbatimModuleSyntax`).
- **Tipos compartilhados** (`JwtUser`, `AuthService`) e augmentations de módulo ficam em `types/fastify.ts`.

## Adicionar uma feature nova

1. `models/<dominio>.model.ts` — schema Mongoose + DTO.
2. `schemas/<dominio>.schema.ts` — validação zod de entrada/saída.
3. `services/<dominio>.service.ts` — regra de negócio (fábrica `createXxxService`).
4. `routes/<dominio>.route.ts` — endpoints finos chamando o service.
5. Registrar a rota no `app.ts` e reexportar no barrel da camada.
