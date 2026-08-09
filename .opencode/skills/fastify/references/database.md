# Banco de dados em Fastify

Fastify é agnóstico a banco de dados. O time mantém plugins oficiais para os
engines mais comuns; para qualquer outro (Prisma, TypeORM, Knex, etc.),
escreve-se um plugin fino seguindo o mesmo padrão.

## Plugins oficiais por engine

| Engine | Pacote | Instância exposta |
|---|---|---|
| MySQL | `@fastify/mysql` | `fastify.mysql` |
| Postgres | `@fastify/postgres` (requer `pg`) | `fastify.pg` |
| Redis | `@fastify/redis` | `fastify.redis` |
| MongoDB | `@fastify/mongodb` | `fastify.mongo` |

### MySQL
```js
fastify.register(require('@fastify/mysql'), {
  connectionString: 'mysql://root@localhost/mysql'
})
fastify.get('/user/:id', (req, reply) => {
  fastify.mysql.query('SELECT id, username FROM users WHERE id=?', [req.params.id],
    (err, result) => reply.send(err || result))
})
```

### Postgres
```js
fastify.register(require('@fastify/postgres'), {
  connectionString: 'postgres://postgres@localhost/postgres'
})
fastify.get('/user/:id', (req, reply) => {
  fastify.pg.query('SELECT id, username FROM users WHERE id=$1', [req.params.id],
    (err, result) => reply.send(err || result))
})
```

### Redis
```js
fastify.register(require('@fastify/redis'), { host: '127.0.0.1' })
// ou: fastify.register(require('@fastify/redis'), { url: 'redis://127.0.0.1' })

fastify.get('/foo', (req, reply) => {
  fastify.redis.get(req.query.key, (err, val) => reply.send(err || val))
})
```
Por padrão `@fastify/redis` **não fecha** a conexão do client quando o
Fastify desliga. Para habilitar isso: `fastify.register(require('@fastify/redis'), { client: redis, closeClient: true })`.

### MongoDB
```js
fastify.register(require('@fastify/mongodb'), {
  forceClose: true, // fecha a conexão quando a app para (padrão: false)
  url: 'mongodb://mongo/mydb'
})
fastify.get('/user/:id', async function (req, reply) {
  const users = this.mongo.db.collection('users')
  const id = this.mongo.ObjectId(req.params.id)
  return users.findOne({ id })
})
```

## Escrevendo seu próprio plugin de banco (quando não existe pacote oficial)

Padrão: sempre envolva com `fastify-plugin`, decore a instância, e registre
um hook `onClose` para fechar a conexão graciosamente.

**Para uma lib/query-builder (ex.: Knex):**
```js
'use strict'
const fp = require('fastify-plugin')
const knexLib = require('knex')

function knexPlugin (fastify, options, done) {
  if (!fastify.knex) {
    const knex = knexLib(options)
    fastify.decorate('knex', knex)
    fastify.addHook('onClose', (fastify, done) => {
      if (fastify.knex === knex) fastify.knex.destroy(done)
    })
  }
  done()
}

module.exports = fp(knexPlugin, { name: 'fastify-knex-example' })
```

**Para um driver de baixo nível (ex.: MySQL do zero):**
```js
const fp = require('fastify-plugin')
const mysql = require('mysql2/promise')

function fastifyMysql (fastify, options, done) {
  const connection = mysql.createConnection(options)
  if (!fastify.mysql) fastify.decorate('mysql', connection)
  fastify.addHook('onClose', (fastify, done) => connection.end().then(done).catch(done))
  done()
}

module.exports = fp(fastifyMysql, { name: 'fastify-mysql-example' })
```

O padrão `if (!fastify['nome']) decorate(...)` evita `FST_ERR_DEC_ALREADY_PRESENT`
se o plugin acabar sendo registrado mais de uma vez no mesmo escopo.

## Migrações de schema

Fastify não prescreve uma ferramenta — qualquer tool de migração do
ecossistema Node.js funciona. A recomendação oficial:
- **SQL (Postgres, MySQL, SQL Server, SQLite)**: [Postgrator](https://www.npmjs.com/package/postgrator)
- **MongoDB**: [migrate-mongo](https://www.npmjs.com/package/migrate-mongo)

### Padrão de arquivo de migração (Postgrator)

`[versão].[ação].[descrição-opcional].sql`
- **versão**: número incremental (ex.: `001`) ou timestamp.
- **ação**: `do` (aplica) ou `undo` (reverte) — equivalente a `up`/`down` de
  outras tools.
- **descrição**: opcional, mas recomendado para clareza.

```sql
-- 001.do.create-users-table.sql
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY NOT NULL,
  created_at DATE NOT NULL DEFAULT CURRENT_DATE,
  firstName TEXT NOT NULL,
  lastName TEXT NOT NULL
);
```

```js
const pg = require('pg')
const Postgrator = require('postgrator')
const path = require('node:path')

async function migrate () {
  const client = new pg.Client({ host: 'localhost', port: 5432, database: 'example', user: 'example', password: 'example' })
  try {
    await client.connect()
    const postgrator = new Postgrator({
      migrationPattern: path.join(__dirname, '/migrations/*'),
      driver: 'pg',
      database: 'example',
      schemaTable: 'migrations',
      currentSchema: 'public', // só Postgres e MS SQL Server
      execQuery: (query) => client.query(query)
    })
    const result = await postgrator.migrate()
    if (result.length === 0) console.log('Nenhuma migração pendente.')
    process.exitCode = 0
  } catch (err) {
    console.error(err)
    process.exitCode = 1
  }
  await client.end()
}
migrate()
```
