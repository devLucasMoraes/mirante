# Schemas & Models

Source: https://mongoosejs.com/docs/guide.html, https://mongoosejs.com/docs/api/schema.html, https://mongoosejs.com/docs/api/mongoose.html

## Defining a schema

```js
const blogSchema = new Schema({
  title: String,                 // shorthand for { type: String }
  author: String,
  comments: [{ body: String, date: Date }],
  date: { type: Date, default: Date.now },
  meta: { votes: Number, favs: Number } // nested object: only leaves become real paths
});
```

- Permitted SchemaTypes: `String`, `Number`, `Date`, `Buffer`, `Boolean`, `Mixed`, `ObjectId`, `Array`, `Decimal128`, `Map`, `UUID`, `Double`, `Int32`.
- A plain nested object (no `type` key) only creates schema paths for its leaves (`meta.votes`, `meta.favs`) — `meta` itself has no validation of its own. For validation on the parent path, use a **sub-schema** (see Subdocuments in official docs) instead of a bare nested object.
- Add keys later with `schema.add({...})`.

## `_id`

- Every schema gets an `_id: ObjectId` path by default. Disable only on **subdocuments** with `{ _id: false }`.
- If you override `_id` with a custom type, you are responsible for setting it — Mongoose refuses to save a top-level doc without an `_id`.

## Instance methods, statics, query helpers

```js
const animalSchema = new Schema({ name: String, type: String }, {
  methods: { findSimilarTypes(cb) { return mongoose.model('Animal').find({ type: this.type }, cb); } },
  statics: { findByName(name) { return this.find({ name: new RegExp(name, 'i') }); } },
  query: { byName(name) { return this.where({ name: new RegExp(name, 'i') }); } },
});
```
- Equivalent to assigning `schema.methods.fn = ...`, `schema.statics.fn = ...`, `schema.query.fn = ...`.
- **Never use arrow functions** for methods/statics/validators — arrow functions don't bind `this`, so `this` won't be the document/model.
- Query helpers extend the chainable query builder: `Animal.find().byName('fido')`.

## Virtuals & aliases

- Virtuals are computed properties that are **not** persisted. `schema.virtual('fullName').get(fn).set(fn)`, or via the `virtuals` schema option.
- Virtuals are excluded from `toJSON()`/`toObject()`/`JSON.stringify()` **by default** — pass `{ virtuals: true }` or set the `toJSON`/`toObject` schema option to include them. This is the #1 cause of "my virtual is missing from the API response" bugs.
- Virtual setters run **before** other validation.
- You cannot query on a virtual (not stored in MongoDB) — except *populate virtuals*, see `populate.md`.
- Aliases (`alias: 'name'` on a schema path) are a virtual shortcut for renaming a short DB field to a friendly API name.

## Indexes

```js
animalSchema.index({ name: 1, type: -1 }); // schema-level, needed for compound indexes
tags: { type: [String], index: true }       // path-level
```
- Mongoose auto-builds indexes on connect via `autoIndex` (default `true`). **Disable in production** (`autoIndex: false`) — index builds can degrade performance; build them out-of-band instead, e.g. `mongoose.set('autoIndex', process.env.NODE_ENV !== 'production')`.
- Listen for build errors: `Animal.on('index', (err) => ...)`.
- `unique: true` on a path is **shorthand for a unique index**, not a validator — see `errors-troubleshooting.md` for the E11000 implications.

## Key schema options (pass as 2nd arg to `new Schema({...}, options)`)

| Option | Default | Notes |
|---|---|---|
| `autoIndex` | `true` | disable in prod |
| `autoCreate` | `true` | auto-calls `createCollection()`; can't retroactively change an existing collection's options (e.g. `capped`) |
| `bufferCommands` | `true` | queue model calls until connected; disable to fail fast instead of hanging |
| `bufferTimeoutMS` | `10000` | how long buffered ops wait before erroring |
| `capped` | — | capped collection size in bytes |
| `collection` | pluralized model name | override collection name |
| `discriminatorKey` | `__t` | field storing discriminator type |
| `id` | `true` | adds a string `id` virtual getter for `_id` |
| `minimize` | `true` | strips empty nested objects on save |
| `strict` | `true` | drop fields not in schema on **write**; `'throw'` errors instead of dropping |
| `strictQuery` | `false` (Mongoose 7+) | same idea but for **query filters** — `true` silently strips unknown filter keys (can widen a query unexpectedly), `false` leaves them (query then matches nothing), `'throw'` errors |
| `timestamps` | `false` | adds `createdAt`/`updatedAt`; also applied to `bulkWrite()` |
| `versionKey` | `'__v'` | optimistic-ish array versioning; set `false` to disable (not recommended blindly) |
| `optimisticConcurrency` | `false` | true optimistic concurrency on `save()`; throws `VersionError` on conflicting concurrent saves |
| `toJSON` / `toObject` | `{}` | pass `{ virtuals: true, getters: true }` to include them in serialized output |
| `typeKey` | `'type'` | change if your schema legitimately needs a field literally named `type` (e.g. GeoJSON) |
| `validateBeforeSave` | `true` | disable to allow saving invalid docs (validate manually) |
| `collation` | — | default collation for queries/aggregations on this schema |
| `selectPopulatedPaths` | `true` | auto-`select()`s any path you `populate()` |

## Compiling a model

```js
const Blog = mongoose.model('Blog', blogSchema);
```

**Critical rule:** all `pre()`/`post()` hooks, `plugin()` calls, and schema edits **must happen before** `mongoose.model()` is called on that schema. Anything registered after compiling the model is silently ignored — this is one of the most common "my hook never fires" bugs. See `errors-troubleshooting.md`.

### `OverwriteModelError` / "Cannot overwrite `X` model once compiled"
Happens when `mongoose.model('Name', schema)` is called twice for the same name (common with hot-reload / tests re-importing a model file). Guard with:
```js
const User = mongoose.models.User || mongoose.model('User', userSchema);
```

## ES6 classes

`schema.loadClass(MyClass)` converts class methods → Mongoose methods, static methods → statics, getters/setters → virtuals.

## Plugins

`schema.plugin(fn)` applies reusable schema-modifying functions; `mongoose.plugin(fn)` applies a plugin globally to every schema (must be called before schemas are compiled into models). Use `pluginTags` + `plugin(fn, { tags: [...] })` to scope global plugins to specific schemas.
