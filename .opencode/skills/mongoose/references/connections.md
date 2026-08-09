# Connections

Source: https://mongoosejs.com/docs/connections.html, https://mongoosejs.com/docs/api/connection.html

## Connecting

```js
await mongoose.connect('mongodb://127.0.0.1:27017/myapp'); // default connection
```
- Prefer `127.0.0.1` over `localhost` — Node 18+ resolves `localhost` to IPv6 `::1` first, which can fail to connect if MongoDB isn't listening on IPv6.
- `mongoose.connect()` returns a Promise resolving to the mongoose instance. Always `.catch()`/`try-catch` it — Mongoose does **not** auto-retry a failed *initial* connection.
- For post-connection drops, Mongoose *does* attempt to reconnect, but you must listen for events (see below) — it won't necessarily emit `'error'` on a lost connection; listen for `'disconnected'` too.

## `mongoose.connect()` vs `mongoose.createConnection()`

- `connect()` sets up/reuses the single **default connection** (`mongoose.connection`). Fine for single-DB apps.
- `createConnection(uri, opts)` returns a **new, independent `Connection`** — required for multiple databases/clusters, or per-tenant isolation. Returns the connection object immediately (not a promise); use `await conn.asPromise()` if you need to wait for it to be ready.
- Models are **always scoped to exactly one connection**: `conn.model('User', schema)`.
- If you use multiple connections, **export schemas, not models** (the "export model pattern" only works with the default connection). Create models per-connection in a factory function or a connections module.

## Operation buffering

By default Mongoose queues (buffers) model calls made before the connection is open, so code can `mongoose.model()` + call `.find()` immediately without waiting. This is convenient but the #1 cause of "my query just hangs forever" — see `errors-troubleshooting.md`. Disable with `bufferCommands: false` (globally via `mongoose.set('bufferCommands', false)` or per-schema) to fail fast instead of buffering; if you do, also disable `autoCreate` and call `Model.createCollection()` explicitly if you rely on capped/collated collections.

## Important connect options

| Option | Default | Purpose |
|---|---|---|
| `serverSelectionTimeoutMS` | `30000` | How long the driver retries finding a usable server before throwing `MongooseServerSelectionError`/`MongoTimeoutError`. Governs **both** initial `connect()` and every later operation. Lower it (e.g. `5000`) for standalone servers/serverless to fail fast; keep it higher for replica sets to survive failovers. |
| `bufferCommands` | `true` | Mongoose-specific, see above |
| `autoIndex` | `true` | build indexes on connect |
| `dbName` | — | overrides the DB name in the URI (needed for some `mongodb+srv` strings) |
| `maxPoolSize` | `100` | max sockets per connection; MongoDB does ~1 op/socket, so raise if slow queries block fast ones, lower if hitting Atlas connection limits |
| `minPoolSize` | `0` | keep warm sockets to avoid reconnect latency after idle periods |
| `socketTimeoutMS` | `0` (no timeout) | kills an inactive-but-open socket after this many ms |
| `family` | driver default (tries IPv6 then IPv4) | force `4` if connect is slow/hanging on DNS |
| `authSource` | — | DB that owns the `user`/`pass` credentials; set this if login unexpectedly fails |
| `heartbeatFrequencyMS` | driver default | lower to detect `'disconnected'` faster |

Connection-string query params work for most driver options (not Mongoose-only ones like `bufferCommands`).

## Connection events

`connecting → connected → open`, and `disconnecting → disconnected → close`, plus `reconnected`, `error`. Attach with `mongoose.connection.on(event, fn)` (default connection) or `conn.on(event, fn)` (custom connection).

## Multiple / multi-tenant connections

Two recommended patterns:
1. **Single pool, `useDb()` per tenant** — `mongoose.connection.useDb('tenant_x', { useCache: true })`, then register/reuse models on that db handle. Simple; good for many light tenants; tenants can slow each other down under high load.
2. **One pool per tenant** — `mongoose.createConnection(uri_for_tenant)`, cache connections in a map. More scalable, more ops overhead, and you must respect MongoDB/Atlas's total open-connection limits across all pools.
