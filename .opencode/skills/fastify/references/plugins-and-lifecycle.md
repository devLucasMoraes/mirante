# Plugins, decorators, hooks e encapsulamento (a fundo)

Baseado em "The hitchhiker's guide to plugins" e "How to write a good plugin"
da documentação oficial. Leia isto quando o usuário estiver escrevendo um
plugin novo, tiver dúvida sobre por que algo "não está disponível" em
determinado escopo, ou precisar decidir a arquitetura de um plugin
distribuível.

## Assinatura de um plugin

```js
module.exports = function (fastify, options, done) {
  // registre rotas, decorators, hooks, ou nested registers
  done() // OBRIGATÓRIO chamar quando terminar
}
```

Ou com `async`:

```js
module.exports = async function (fastify, options) {
  fastify.get('/plugin', async (request, reply) => ({ hello: 'world' }))
}
```

Se `done()` nunca é chamado (nem a Promise resolve), o boot trava e depois de
um tempo você recebe `FST_ERR_PLUGIN_TIMEOUT`.

## Encapsulamento na prática

```js
fastify.register((instance, opts, done) => {
  instance.decorate('util', (a, b) => a + b)
  console.log(instance.util('a', 'b')) // OK

  instance.register((instance, opts, done) => {
    console.log(instance.util('a', 'b')) // OK — filhos herdam do pai
    done()
  })
  done()
})

fastify.register((instance, opts, done) => {
  console.log(instance.util('a', 'b')) // ERRO — irmãos não compartilham
  done()
})
```

Regra: encapsulamento se aplica a ancestrais e irmãos, **não** aos filhos.
Um plugin registrado dentro de outro herda tudo do pai.

## `fastify-plugin` — furando o encapsulamento de propósito

Quando você quer que um `decorate`/hook feito dentro de um `register` "vaze"
para o escopo pai (típico em plugins de infraestrutura: conexão de DB, auth,
utilitários compartilhados):

```js
const fp = require('fastify-plugin')
const dbClient = require('db-client')

function dbPlugin (fastify, opts, done) {
  dbClient.connect(opts.url, (err, conn) => {
    fastify.decorate('db', conn)
    done()
  })
}

module.exports = fp(dbPlugin)
```

`fastify-plugin` também permite checar a versão instalada do Fastify, se o
plugin depender de uma API específica.

### Passando dados de um plugin anterior para o próximo via `register`

Como plugins carregam de forma assíncrona e só "existem" completamente depois
do boot, se um plugin precisa de algo que um `register` anterior decorou, use
uma função como segundo argumento (em vez de um objeto estático):

```js
fastify.register(fp(dbPlugin), { url: 'https://fastify.example' })

fastify.register(require('your-plugin'), parent => {
  return { connection: parent.db, otherOption: 'foo-bar' }
})
```

`parent` é uma cópia da instância externa no ponto em que o `register` foi
declarado — dá acesso a tudo que foi injetado por plugins anteriores.

## Decorators: `decorate` vs `decorateRequest` vs `decorateReply`

- `fastify.decorate('nome', valor)` — utilitário de instância, acessível como
  `fastify.nome` (ou `this.nome` dentro de hooks/handlers com `this` ligado à
  instância).
- `fastify.decorateRequest('nome', valor)` — vai para o **prototype** do
  objeto `request`, é a forma mais rápida de anexar estado por requisição.
- `fastify.decorateReply('nome', function (...) { this.type(...); this.send(...) })`
  — sempre use `function`, nunca arrow function, porque você precisa de
  `this` apontando para o objeto `reply`.

Prefira decorar `request`/`reply` em vez de fazer
`fastify.util(request, ...)` toda vez — é mais idiomático e mais rápido.

## Hooks — plugue-se no lifecycle sem duplicar código

Em vez de repetir lógica em cada handler, use um hook:

```js
fastify.decorate('util', (request, key, value) => { request[key] = value })
fastify.addHook('preHandler', (request, reply, done) => {
  fastify.util(request, 'timestamp', new Date())
  done()
})
```

Hooks respeitam encapsulamento — registrados dentro de um `register`, só
rodam para as rotas daquele contexto. Para aplicar um hook só a rotas
marcadas explicitamente (útil quando você distribui o plugin), use o hook
`onRoute` para inspecionar/mutar `routeOptions` dinamicamente:

```js
instance.addHook('onRoute', (routeOptions) => {
  if (routeOptions.config?.useUtil === true) {
    const handler = (request, reply, done) => { /* ... */ done() }
    if (!routeOptions.preHandler) routeOptions.preHandler = [handler]
    else if (Array.isArray(routeOptions.preHandler)) routeOptions.preHandler.push(handler)
    else routeOptions.preHandler = [routeOptions.preHandler, handler]
  }
})
```

Ordem do lifecycle de uma requisição (visão simplificada): `onRequest` →
`preParsing` → `preValidation` → `preHandler` → handler da rota →
`preSerialization` → `onSend` → `onResponse` (mais `onError` quando algo dá
errado, e hooks de nível de aplicação como `onRoute`, `onRegister`, `onReady`,
`onClose`).

## Tratamento de erro dentro de um plugin (`after`)

`after` registra um callback executado logo depois de um `register`, útil
quando o plugin pode falhar no boot e você quer lógica customizada:

```js
fastify
  .register(require('./database-connector'))
  .after(err => { if (err) throw err })
```

## Erros e warnings customizados de um plugin

```js
// erro customizado consistente
const createError = require('@fastify/error')
const CustomError = createError('ERROR_CODE', 'message')

// warning (para deprecar uma API do seu plugin, por exemplo)
const warning = require('process-warning')()
warning.create('MyPluginWarning', 'MP_ERROR_CODE', 'message')
warning.emit('MP_ERROR_CODE')
```

## ESM

Suportado desde Node.js v13.3.0+. Basta exportar como módulo ESM:

```js
// plugin.mjs
export default async function plugin (fastify, opts) {
  fastify.get('/', async () => ({ hello: 'world' }))
}
```

## Checklist para um plugin "publicável" (padrão da comunidade Fastify)

Ao escrever um plugin que será distribuído/reusado, a documentação oficial
recomenda:
- Documentação clara (plugins sem docs boas não entram na lista oficial de
  ecossistema).
- Um arquivo de exemplo no repositório.
- Testes de verdade — sem eles, não há confiança de que o plugin continua
  funcionando entre versões de dependências. A biblioteca `node:test` é a
  recomendação padrão do time Fastify (paralelismo e coverage nativos), mas
  qualquer test runner serve.
- Um linter de código (o time Fastify usa `standard`).
- CI (GitHub Actions/CircleCI são gratuitos para open source) + Dependabot
  para manter dependências atualizadas.
- Licença — qualquer uma serve; o time recomenda MIT.

## Ordem de organização recomendada em uma aplicação

```
└── plugins do ecossistema (@fastify/*)
└── plugins próprios
└── decorators
└── hooks
└── suas rotas/serviços
```

Isso garante que qualquer camada sempre tem acesso ao que a anterior já
inicializou. Se um subconjunto de rotas precisa de isolamento (ex.: um
"serviço" com seu próprio decorator/hook), replique a mesma estrutura dentro
de um `register` aninhado — é assim que se migra de monólito para
microsserviços sem reescrever tudo.
