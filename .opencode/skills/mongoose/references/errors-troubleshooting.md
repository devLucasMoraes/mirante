# Errors & Troubleshooting

Purpose: fast error-name/message → cause → fix lookup. Read this file whenever the user pastes a stack trace, describes unexpected behavior, or asks "why isn't this working."

## `ValidationError`
- **What**: thrown by `doc.validate()`/`save()` when one or more paths fail validation. `.errors` is a map of `path -> ValidatorError | CastError`.
- **Look at**: `error.errors['<path>'].message`, `.kind`, `.value`, and (if a custom validator threw) `.reason`.
- **Common causes**: missing `required` field, `enum` mismatch, custom validator returned `false`/threw, a nested `CastError` (see below), min/max violation.
- **Note**: an empty string/buffer on a `required` field DOES fail validation; an empty **array** on a required field does NOT.

## `CastError` (usually nested inside a `ValidationError`)
- **What**: a value couldn't be coerced to the schema type (e.g. `"not a number"` into a `Number` path, or an invalid string into `ObjectId`).
- **Message pattern**: `Cast to <Type> failed for value "<value>" at path "<path>"`.
- **Fix**: validate/sanitize input before assignment, or check `mongoose.isValidObjectId(id)` before querying by `_id`. Customize the message with the schema type's `cast` option if the default is confusing to API consumers.
- **Reminder**: casting happens BEFORE validation, and assigning a bad value does not throw synchronously — it only surfaces on `validate()`/`save()`.

## `MongoServerError: E11000 duplicate key error`
- **What**: a raw MongoDB driver error, NOT a Mongoose `ValidationError` — `error.errors` will be undefined, check `error.message`/`error.code === 11000` instead.
- **Cause**: `unique: true` schema option is an index constraint, not a validator; concurrent inserts before the unique index finishes building can both "succeed" from Mongoose's perspective and only fail at the DB layer (race condition) — call `await Model.init()` if you need to guarantee the index exists first (e.g. in tests that drop the DB between runs).
- **Fix pattern**: catch and translate in a `post('save')`/`post('updateOne')` error-handling middleware (3-arg `(error, doc, next)` — see `validation-and-middleware.md`), or check `error.code === 11000` at the call site.

## `MongooseServerSelectionError` / `MongoTimeoutError: Server selection timed out after 30000 ms`
- **What**: the driver couldn't find a usable MongoDB server within `serverSelectionTimeoutMS` (default 30s). Fires for BOTH `mongoose.connect()` and any later operation (`find`, `save`, ...) if connectivity drops.
- **Check**: `error.reason` — often contains the real cause (`Authentication failed`, DNS failure, `ECONNREFUSED`, etc). For replica sets, `error.reason.servers` is a Map describing each member's perceived state — inspect it to see which node(s) are unreachable.
- **Common root causes**: MongoDB not running/wrong host-port, firewall/network ACL blocking access, wrong credentials (check `authSource` too), replica set member reporting `localhost` as its hostname when accessed remotely (check `rs.conf()`), or a genuinely slow/down cluster.
- **Fix**: lower `serverSelectionTimeoutMS` (e.g. `5000`) for standalone/serverless setups to fail fast in tests/dev; keep it higher (or default) for replica sets so failovers don't cause spurious errors.

## Query/`save()`/`find()` just hangs forever, no error
- **Cause almost always**: `bufferCommands` (default `true`) is queuing the operation because Mongoose never successfully connected (bad URI, `await` missing on `mongoose.connect()`, connect() rejected and was swallowed). Buffering waits up to `bufferTimeoutMS` (default 10s) before finally throwing — if that's also disabled or very high, it can look like an infinite hang.
- **Fix**: ensure `await mongoose.connect(...)` actually resolves before app traffic starts; add `mongoose.connection.on('error', ...)` and `.on('disconnected', ...)` listeners; temporarily set `bufferCommands: false` to convert the silent hang into an immediate, debuggable error.

## `Query was already executed: <description>`
- **Cause**: a `Query` object's `.then()`/`.exec()` was called more than once (queries are thenables, not Promises — awaiting the same query variable twice, or mixing `await query` with a later `query.exec()`).
- **Fix**: build the full query with chaining, then resolve it exactly once.

## `StrictModeError`
- **Cause**: schema `strict: 'throw'` (writes) or `strictQuery: 'throw'` (query filters) and the payload contains a field not defined in the schema.
- **Distinguish**: `strict` = write paths (`save`, `create`, `update` bodies); `strictQuery` = filter objects passed to `find`/`updateOne`/etc. Mixing these up is a common source of "why did this field get silently dropped/kept" confusion — re-check which option actually governs the operation in question.
- **Related non-throwing gotcha**: with `strictQuery: false` (Mongoose 7+ default), an unknown filter key is sent to MongoDB as-is and typically matches nothing; with `strictQuery: true`, Mongoose strips it, which can make a filter unexpectedly match everything.

## `VersionError: No matching document found for id "..." version N`
- **Cause**: `optimisticConcurrency: true` on the schema, and two `save()` calls raced on stale in-memory copies of the same document.
- **Fix**: reload the document and retry the business logic, or scope `optimisticConcurrency` to only the fields that need it (array-of-field-names or `{ exclude: [...] }` form) if unrelated concurrent edits are false-triggering it.

## `OverwriteModelError: Cannot overwrite \`X\` model once compiled`
- **Cause**: `mongoose.model('X', schema)` called twice for the same name — typical with hot-reload (nodemon/webpack HMR), or a test file re-importing a model module that isn't cached the way you expect.
- **Fix**: `const X = mongoose.models.X || mongoose.model('X', schema);`

## `MissingSchemaError: Schema hasn't been registered for model "X"`
- **Cause**: calling `mongoose.model('X')` (getter form, no schema arg) or `.populate('path')` with a `ref: 'X'` before a model named `X` has actually been compiled on that connection — classic multi-file import-order bug, or using a different `Connection` than the one `X` was registered on.
- **Fix**: ensure the model file that calls `mongoose.model('X', schema)` is imported/required before any code that references it; for `populate()`, confirm the ref'd model exists on the SAME connection (cross-db populate needs the explicit `model`/Model-class form — see `populate.md`).

## My `pre('save')`/`pre('validate')`/plugin never runs
- **Cause**: registered AFTER `mongoose.model()` was called for that schema. Hooks/plugins added post-compile are silently ignored (no error).
- **Fix**: reorder so all `schema.pre/post(...)` and `schema.plugin(...)` calls happen before the `mongoose.model(...)` line, ideally by keeping model compilation as the very last line of the schema's file.

## Update (`updateOne`/`findOneAndUpdate`) isn't validating / isn't running my `pre('save')` logic
- **Two separate causes, check both**:
  1. Update validators are **off by default** — pass `{ runValidators: true }`.
  2. `save`-hook logic (document middleware) never runs for query-style updates by design — Mongoose has entirely separate `updateOne`/`findOneAndUpdate` **query** middleware; port relevant logic there, or load-modify-`save()` the document instead of using a direct update.

## `doc.updateOne()`/`doc.deleteOne()` hook not firing, but `Model.updateOne()`'s does (or vice versa)
- **Cause**: Mongoose registers `updateOne`/`deleteOne` as **query** middleware by default, so `Model.X()` fires it but `doc.X()` does not (and `this` in the hook is the Query, not the doc). To hook the document-instance call specifically: `schema.pre('updateOne', { document: true, query: false }, fn)`.

## Data looks wrong after `JSON.stringify(doc)` / `res.json(doc)` — virtuals or populated fields missing
- **Cause**: virtuals (including populate virtuals) are excluded from `toJSON()`/`toObject()` output by default.
- **Fix**: schema option `toJSON: { virtuals: true }` (and `toObject: { virtuals: true }` if you also `console.log()`/manually convert), or call `doc.toObject({ virtuals: true })` explicitly.

## `{ ...doc }` / `Object.keys(doc)` / `delete doc.field` behave weirdly
- Documents are class instances, not POJOs:
  - `delete doc.field` does NOT unset the DB field — set `doc.field = undefined` then `save()`.
  - Spread (`{ ...doc }`) doesn't clone the data — you get internal state incl. an `_doc` property. Use `doc.toObject()`.
  - `Object.keys/values/entries(doc)` inspect the instance, not the data — use `Object.keys(doc.toObject())`.
  - `'field' in doc` is always `true` for any schema path regardless of whether it has a value — check `doc.field !== undefined` instead.
  - `(doc.nested ??= {}).name = 'x'` is a silent no-op on a Mongoose document — use `doc.set('nested.name', 'x')`.

## Aggregation pipeline returns nothing / wrong type errors, even though the equivalent `find()` works
- **Cause**: `aggregate()` does not cast pipeline values the way queries cast filters — e.g. a string `_id` in `$match` won't be auto-converted to `ObjectId`.
- **Fix**: explicitly construct `new mongoose.Types.ObjectId(idString)` (or the correct type) before putting it in the pipeline. Also remember `aggregate()` results are always plain objects, never hydrated Documents.

## General debugging tools
- `mongoose.set('debug', true)` — logs every executed MongoDB command (great first step for "why is this query doing something unexpected").
- `doc.$getChanges()` — see exactly what `save()` will send as its update payload.
- `doc.isModified('path')` — check dirty-tracking before deciding whether to run expensive derived-field logic.
- Error `.name` field is the fastest triage signal: `ValidationError`, `CastError`, `MongoServerError`, `MongooseServerSelectionError`, `VersionError`, `StrictModeError`, `OverwriteModelError`, `MissingSchemaError`, `DocumentNotFoundError`.
