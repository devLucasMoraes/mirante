---
name: fastify
description: Guia de proficiência em Fastify (framework Node.js). Use SEMPRE que o usuário estiver criando, depurando, revisando ou otimizando uma API/servidor Fastify — incluindo tarefas como registrar plugins, escrever rotas, configurar validação/serialização com JSON Schema, conectar bancos de dados, escrever testes, investigar um erro `FST_ERR_*` ou um 500/404 inesperado, ou decidir qual pacote do ecossistema `@fastify/*` usar. Acione esta skill mesmo que o usuário não diga a palavra "Fastify" explicitamente, desde que o código, o stack trace ou o contexto (arquivo `fastify.js`, `app.register`, `reply.send`, erro `FST_ERR_...`) deixe claro que é Fastify.
---

# Fastify — guia de proficiência

Fastify é um framework web para Node.js focado em baixo overhead e alta
performance. A ideia central que rege TUDO no framework: **em Fastify, tudo é
um plugin**, e todo plugin é uma **função com sua própria "encapsulação"** de
escopo. Se você entender `register` + encapsulamento, o resto do framework
faz sentido.

Este SKILL.md cobre o essencial para trabalhar com produtividade. Para
detalhes extensos, siga os ponteiros para `references/`.

## Antes de codar: qual referência abrir

| Tarefa do usuário | Abra |
|---|---|
| Erro em runtime (`FST_ERR_*`, 500, validação, plugin não carrega) | `references/errors-troubleshooting.md` |
| Escrever/organizar plugins, decorators, hooks, register | seção "Modelo mental" abaixo + `references/plugins-and-lifecycle.md` |
| Conectar banco de dados (Postgres, MySQL, Mongo, Redis, Knex, migrações) | `references/database.md` |
| Escrever testes (unitário, injeção HTTP, testar plugin) | `references/testing.md` |
| Deploy, reverse proxy, performance, Kubernetes, capacity planning | `references/production.md` |
| Escolher um pacote do ecossistema (`@fastify/cors`, auth, cache, etc.) | `references/ecosystem.md` |

## Modelo mental central (leia isto primeiro)

### 1. Register cria um novo contexto (encapsulamento)

```js
fastify.register(require('./my-plugin'), { options })
```

Todo plugin é uma função `(fastify, options, done) => {}` (ou `async (fastify,
options) => {}`). Dentro dela, `fastify` é uma **instância filha** — qualquer
`decorate`, hook ou schema declarado ali só é visível para esse plugin e seus
descendentes, nunca para os "irmãos" ou "pais" (ancestrais).

- Isso é uma feature, não uma limitação: permite dividir uma app monolítica em
  módulos independentes sem acoplamento cruzado.
- **Regra prática**: se algo precisa estar disponível em toda a aplicação,
  declare no escopo raiz, ou use `fastify-plugin` (ver abaixo) para "furar" o
  encapsulamento de propósito.
- Fastify só começa a carregar plugins **depois** que `.listen()`, `.inject()`
  ou `.ready()` é chamado — carregamento é assíncrono e respeita a ordem de
  declaração (via `avvio` internamente).

### 2. `fastify-plugin` (fp) — quando você QUER furar o encapsulamento

```js
const fp = require('fastify-plugin')
module.exports = fp(function dbConnector (fastify, opts, done) {
  fastify.decorate('db', someConnection)
  done()
})
```

Use isto para plugins "de infraestrutura" (conexão de banco, autenticação,
utilitários) que devem ficar acessíveis no escopo pai. Sem `fp`, um `decorate`
dentro de `register` só existiria dentro daquele plugin.

### 3. Decorators — como estender fastify/request/reply

- `fastify.decorate('nome', valor)` — adiciona algo na instância do Fastify.
- `fastify.decorateRequest('nome', valor)` — adiciona em `request` (mais
  rápido que decorar `fastify` e usar de dentro do handler).
- `fastify.decorateReply('nome', function () {...})` — adiciona em `reply`;
  use `function` (não arrow) para ter acesso a `this` (a própria reply).
- Erros comuns: `FST_ERR_DEC_ALREADY_PRESENT` (nome duplicado),
  `FST_ERR_DEC_AFTER_START` (decorou depois do `.listen()`/`.ready()`).

### 4. Hooks — plugar-se no ciclo de vida da requisição

```js
fastify.addHook('preHandler', (request, reply, done) => {
  request.isHappy = true
  done()
})
```

Hooks comuns, em ordem de execução: `onRequest` → `preParsing` →
`preValidation` → `preHandler` → (handler da rota) → `preSerialization` →
`onSend` → `onResponse`. Também existem `onError`, `onRoute`, `onRegister`,
`onReady`, `onClose`. Hooks registrados dentro de um `register` só rodam para
rotas daquele encapsulamento — é assim que você aplica middleware a um
subconjunto de rotas sem se preocupar em filtrar por path manualmente.

### 5. Rotas, validação e serialização

```js
fastify.post('/animals', {
  schema: {
    body: { type: 'object', required: ['animal'], properties: { animal: { type: 'string' } } },
    response: { 200: { type: 'object', properties: { hello: { type: 'string' } } } }
  }
}, async (request, reply) => { /* ... */ })
```

- Fastify usa **JSON Schema** nativamente (via Ajv) tanto para validar
  `body`/`querystring`/`params`/`headers` de entrada quanto para **serializar**
  a resposta.
- Definir `schema.response` acelera a serialização (2-3x) e evita vazar campos
  não declarados no schema — trate isso como prática padrão, não opcional.
- Em produção, mantenha `ajv.customOptions.allErrors` desligado (padrão)
  exceto quando você realmente precisa de feedback detalhado de validação —
  `allErrors: true` custa mais processamento por requisição e facilita DoS em
  endpoints com input não confiável.

### 6. Erro em runtime → tratamento

Fastify captura automaticamente erros síncronos e `async` lançados em rotas e
os envia ao error handler padrão (500 Internal Server Error). **A mensagem de
erro (`error.message`) é enviada ao cliente literalmente** — se um erro vier
de uma lib profunda (ex: driver de banco), isso pode vazar detalhes internos.
Sempre registre um `setErrorHandler` customizado em produção para filtrar isso.
Detalhes completos e a tabela de códigos `FST_ERR_*` estão em
`references/errors-troubleshooting.md` — **sempre consulte esse arquivo
primeiro quando o usuário colar um erro ou stack trace do Fastify.**

## Fluxo recomendado de organização de código

```
└── plugins de terceiros (ecossistema @fastify/*)
└── plugins próprios (seus módulos internos)
└── decorators
└── hooks
└── suas rotas/serviços
```

Sempre nessa ordem — garante que tudo que uma camada precisa já foi
inicializado pela anterior. Se um subconjunto de rotas precisa de algo isolado
(ex.: um "serviço" com seu próprio plugin+decorator+hook), replique essa mesma
estrutura dentro de um `register` aninhado.

## Instalação e primeiro servidor (referência rápida)

```bash
npm i fastify
```

```js
import Fastify from 'fastify'
const fastify = Fastify({ logger: true })

fastify.get('/', async (request, reply) => {
  return { hello: 'world' }
})

try {
  await fastify.listen({ port: 3000 })
} catch (err) {
  fastify.log.error(err)
  process.exit(1)
}
```

Por padrão o servidor escuta só em `127.0.0.1`. Para containers/Kubernetes,
use `host: '0.0.0.0'` — ver `references/production.md` (isso também resolve
`readinessProbe` que falha silenciosamente no Kubernetes).

## Testes: use `fastify.inject()`, não um servidor HTTP real

Para a maioria dos testes, não é necessário abrir uma porta de verdade —
`fastify.inject()` (via `light-my-request`) simula a requisição inteira,
incluindo o boot de todos os plugins registrados. Detalhes e exemplos
completos com `node:test` em `references/testing.md`.

## Regra de ouro para revisão/depuração de código Fastify

Ao revisar ou depurar código Fastify de terceiros, sempre confira, nesta
ordem:
1. Onde o `register` foi chamado e se o encapsulamento explica por que algo
   "não está disponível" (decorator/hook indisponível fora do escopo).
2. Se plugins de infraestrutura usam `fastify-plugin` quando deveriam vazar
   para o escopo pai.
3. Se rotas mutáveis/sensíveis têm `schema.body`/`schema.response` definidos.
4. Se existe um `setErrorHandler` custom filtrando mensagens de erro internas
   antes de ir para produção.
5. Se o erro relatado bate com algum código `FST_ERR_*` conhecido —
   `references/errors-troubleshooting.md` tem a tabela completa com causa e
   correção.
