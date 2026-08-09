# Ecossistema Fastify — pacotes oficiais por categoria

O Fastify é deliberadamente minimalista ("não vem com baterias inclusas") e
depende do ecossistema `@fastify/*` para tudo que não é o núcleo HTTP. Esta
é uma lista **curada** dos pacotes oficiais (mantidos pelo time Fastify) mais
usados, organizados por necessidade — para a lista completa (incluindo
centenas de pacotes da comunidade), consulte
https://fastify.dev/docs/latest/Guides/Ecosystem/.

> Regra prática: **prefira sempre pacotes `@fastify/*` (Core) a alternativas
> da comunidade(muitas vezes os plugins da comunidade são desatualizadas)** quando existir um oficial para o que você precisa — eles
> passam por revisão do time e são a opção default segura.

## Segurança e auth
- `@fastify/helmet` — headers de segurança HTTP importantes.
- `@fastify/cors` — habilita CORS.
- `@fastify/csrf-protection` — proteção CSRF.
- `@fastify/jwt` — utilitários JWT (usa `fast-jwt` internamente).
- `@fastify/auth` — roda múltiplas funções de autenticação em conjunto.
- `@fastify/basic-auth` / `@fastify/bearer-auth` — auth básica/bearer.
- `@fastify/oauth2` — wrapper para `simple-oauth2`.
- `@fastify/rate-limit` — rate limiter de baixo overhead por rota.
- `@fastify/secure-session` — cookie de sessão seguro e stateless.
- `@fastify/session` — plugin de sessão completo.

## Parsing e body
- `@fastify/formbody` — parse de `application/x-www-form-urlencoded`.
- `@fastify/multipart` — suporte a multipart/form-data (upload de arquivos).
- `@fastify/cookie` — parse/set de cookies.
- `@fastify/compress` — compressão de resposta.

## Bancos de dados e conexões (ver também `references/database.md`)
- `@fastify/postgres`, `@fastify/mysql`, `@fastify/mongodb`, `@fastify/redis`.
- `@fastify/awilix` — injeção de dependência baseada em `awilix`.

## Documentação de API
- `@fastify/swagger` — geração de spec Swagger/OpenAPI a partir das rotas.
- `@fastify/swagger-ui` — UI do Swagger.

## Observabilidade e operação
- `@fastify/under-pressure` — mede carga do processo e responde "Service
  Unavailable" automaticamente sob pressão.
- `@fastify/otel` — instrumentação OpenTelemetry.
- `@fastify/one-line-logger` — formata os logs do Fastify em uma linha.
- `@fastify/env` — carrega e valida configuração/variáveis de ambiente.

## Arquivos, templates e front-end
- `@fastify/static` — serve arquivos estáticos.
- `@fastify/view` — renderização de templates (ejs, pug, handlebars, marko).
- `@fastify/vite` — integração com Vite (SPA/MPA/SSR).
- `@fastify/nextjs` — SSR com Next.js.

## Tipagem / type providers (TypeScript)
- `@fastify/type-provider-typebox` — type provider para Typebox.
- `@fastify/type-provider-json-schema-to-ts` — type provider para
  `json-schema-to-ts`.
- Comunidade: `fastify-type-provider-zod` (Zod) — muito usado, mas não é
  mantido pelo time Fastify.

## Infraestrutura de plugins/rotas
- `@fastify/autoload` — carrega automaticamente todos os plugins de um
  diretório (essencial em apps grandes, evita `register` manual repetido).
- `@fastify/middie` — engine de compatibilidade com middleware estilo
  Express/Connect (use apenas quando não dá para reescrever como plugin/hook
  nativo — ver `references/production.md` sobre custo de performance).
- `@fastify/http-proxy` — proxy de requisições HTTP para outro servidor.
- `@fastify/reply-from` — encaminha a requisição atual para outro servidor.

## Serverless
- `@fastify/aws-lambda` — roda Fastify em AWS Lambda + API Gateway.

## WebSocket / real-time
- `@fastify/websocket` — suporte a WebSocket (baseado em `ws`).
- `@fastify/sse` — Server-Sent Events.

## Utilitário geral
- `@fastify/sensible` — decorators e assertions "default sensatos" (erros
  HTTP prontos, métodos extras de request/reply) que a maioria dos projetos
  acaba reimplementando na mão.

## Como escrever um plugin próprio se não existir um pacote pronto

Ver `references/plugins-and-lifecycle.md` e `references/database.md` para o
padrão (`fastify-plugin` + `decorate` + hook `onClose`). Antes de escrever do
zero, procure na lista completa do ecossistema — é grande o suficiente que
"não existe plugin pra isso" raramente é verdade para necessidades comuns
(fila, cache, sessão, ORM específico, i18n, etc.).
