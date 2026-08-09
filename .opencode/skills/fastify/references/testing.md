# Testes em Fastify

Fastify não impõe um test runner. A documentação oficial usa `node:test`
(nativo do Node.js, com paralelismo e coverage sem dependências extras), mas
qualquer framework funciona (Jest, Vitest, tap, etc.) — a técnica central é
sempre a mesma: `fastify.inject()`.

## Separe a app da inicialização do servidor

Isso é o que torna a app testável sem abrir uma porta real:

**app.js**
```js
'use strict'
const fastify = require('fastify')

function build (opts = {}) {
  const app = fastify(opts)
  app.get('/', async function (request, reply) {
    return { hello: 'world' }
  })
  return app
}

module.exports = build
```

**server.js**
```js
'use strict'
const server = require('./app')({
  logger: { level: 'info', transport: { target: 'pino-pretty' } }
})

server.listen({ port: 3000 }, (err) => {
  if (err) { server.log.error(err); process.exit(1) }
})
```

## `fastify.inject()` — a ferramenta central de teste

Usa `light-my-request` internamente para simular uma requisição HTTP completa
**sem** abrir uma porta de rede. Importante: `.inject()` garante que todos os
plugins registrados já terminaram de bootar antes de rodar a requisição — não
precisa chamar `.ready()` manualmente antes.

```js
const build = require('./app')

const app = build()
const response = await app.inject({ method: 'GET', url: '/' })
console.log(response.statusCode, response.body)
```

`inject` aceita `method`, `url`, `query`, `payload`, `headers`, `cookies`.
Suporta callback, Promise/`async-await`, ou encadeamento:

```js
fastify.inject().get('/').headers({ foo: 'bar' }).query({ foo: 'bar' }).end((err, res) => {
  console.log(res.payload)
})
```

## Exemplo completo com `node:test`

```js
'use strict'
const { test } = require('node:test')
const build = require('./app')

test('requests the "/" route', async t => {
  t.plan(1)
  const app = build()
  const response = await app.inject({ method: 'GET', url: '/' })
  t.assert.strictEqual(response.statusCode, 200, 'returns a status code of 200')
})
```

Rode com `node --test --watch` (configure isso no script `test` do
`package.json`).

Padrão mais completo, sempre fechando a instância no fim do teste:

```js
const { test } = require('node:test')
const buildFastify = require('./app')

test('GET `/` route', t => {
  t.plan(4)
  const fastify = buildFastify()
  t.after(() => fastify.close()) // sempre feche pra liberar conexões externas

  fastify.inject({ method: 'GET', url: '/' }, (err, response) => {
    t.assert.ifError(err)
    t.assert.strictEqual(response.statusCode, 200)
    t.assert.strictEqual(response.headers['content-type'], 'application/json; charset=utf-8')
    t.assert.deepStrictEqual(response.json(), { hello: 'world' })
  })
})
```

## Testando com um servidor real ligado (`listen`/`ready`)

Às vezes você quer testar com uma porta de fato aberta (ex.: testar
comportamento de rede real, ou usar uma lib de teste HTTP existente). Nesse
caso, use `fastify.listen()` ou `fastify.ready()`:

**Com `undici`:**
```js
const { Client } = require('undici')
const fastify = buildFastify()
await fastify.listen()
const client = new Client('http://localhost:' + fastify.server.address().port, {
  keepAliveTimeout: 10, keepAliveMaxTimeout: 10
})
t.after(() => { fastify.close(); client.close() })
const response = await client.request({ method: 'GET', path: '/' })
```

**Com `fetch` nativo (Node 18+), sem dependências extras:**
```js
const fastify = buildFastify()
t.after(() => fastify.close())
await fastify.listen()
const response = await fetch('http://localhost:' + fastify.server.address().port)
```

**Com `supertest`, usando `.ready()` em vez de `.listen()`:**
```js
const supertest = require('supertest')
const fastify = buildFastify()
t.after(() => fastify.close())
await fastify.ready()
const response = await supertest(fastify.server).get('/').expect(200)
```

## Testando um plugin isoladamente

```js
// plugin/myFirstPlugin.js
const fp = require('fastify-plugin')
async function myPlugin (fastify, options) {
  fastify.decorateRequest('helloRequest', 'Hello World')
  fastify.decorate('helloInstance', 'Hello Fastify Instance')
}
module.exports = fp(myPlugin)
```

```js
// test/myFirstPlugin.test.js
const Fastify = require('fastify')
const { test } = require('node:test')
const myPlugin = require('../plugin/myFirstPlugin')

test('Test the Plugin Route', async t => {
  t.plan(5)
  const fastify = Fastify()
  fastify.register(myPlugin)
  fastify.get('/', async (request, reply) => {
    t.assert.ifError(request.helloRequest)
    t.assert.ok(request.helloRequest, 'Hello World')
    t.assert.ok(fastify.helloInstance, 'Hello Fastify Instance')
    return { message: request.helloRequest }
  })

  const res = await fastify.inject({ method: 'GET', url: '/' })
  t.assert.strictEqual(res.statusCode, 200)
  t.assert.deepStrictEqual(JSON.parse(res.body), { message: 'Hello World' })
})
```

## Debugar um teste específico

1. Isole com `{ only: true }`:
   ```js
   test('should ...', { only: true }, t => { /* ... */ })
   ```
2. Rode com o inspector:
   ```bash
   node --test --test-only --inspect-brk test/<arquivo>.test.js
   ```
3. No VS Code, use a config "Node.js: Attach" para debugar passo a passo.
