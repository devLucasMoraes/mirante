---
name: mongoose
description: Proficiency working with Mongoose (the MongoDB ODM for Node.js/TypeScript) — defining schemas and models, connecting to MongoDB, writing queries, validation, middleware/hooks, population (refs/joins), and diagnosing Mongoose/MongoDB errors (CastError, ValidationError, E11000 duplicate key, MongooseServerSelectionError, buffering timeouts, etc). Always consult this skill whenever the user is writing, reviewing, or debugging any code that imports `mongoose`, defines a `Schema`/`model()`, runs a query against a Mongoose model, or hits a Mongoose/MongoDB stack trace — even if they don't say the word "Mongoose" explicitly (e.g. "why is my save() hanging", "add a unique index", "populate this field", "my update isn't validating").
---

# Mongoose

Working knowledge of Mongoose v9.x (current stable line as of this skill's creation), distilled from the official docs at https://mongoosejs.com/docs/. Everything here is essential-only: full API dumps are NOT reproduced — use `references/api-quick-reference.md` for pointers and fetch the live docs for exhaustive signatures when needed.

## How to use this skill

1. **Always start here.** This file has the mental model and the most common patterns inline — most tasks can be done from this file alone.
2. **Load a reference file only when the task needs that depth.** Each reference below is scoped to one concern so you don't burn context on unrelated material.
3. **When something breaks, go straight to `references/errors-troubleshooting.md`.** It maps error names/messages to root causes and fixes — this is the fastest path to resolving a bug report.

| Reference file | Load it when... |
|---|---|
| `references/schemas-and-models.md` | Defining/editing a `Schema`, choosing schema options (`timestamps`, `strict`, `versionKey`, indexes...), adding methods/statics/virtuals, compiling a model |
| `references/connections.md` | Setting up `mongoose.connect()`/`createConnection()`, connection pooling, multi-tenant or multi-db setups, connection events not firing |
| `references/queries-and-crud.md` | Writing `find`/`update`/`delete` operations, query chaining, `.lean()`, cursors/streaming, aggregation vs. query |
| `references/validation-and-middleware.md` | Adding validators, custom/async validators, `runValidators` on updates, `pre`/`post` hooks, hook ordering, skipping middleware |
| `references/populate.md` | Referencing documents across collections, `ref`/`refPath`, virtual populate, cross-database populate |
| `references/errors-troubleshooting.md` | **Anything is failing or behaving unexpectedly.** Error-name → cause → fix lookup table |
| `references/api-quick-reference.md` | You need the exact method/option name across `Mongoose`, `Schema`, `Connection`, `Document`, `Model`, `Query`, `Aggregate`, `SchemaType`, `VirtualType` and a link to the canonical docs page |

## Mental model (read this once)

Mongoose has 5 core building blocks, and almost every bug traces back to confusing two of them:

1. **`Schema`** — defines shape, types, validators, middleware, indexes. Just a blueprint; not connected to the DB.
2. **`Model`** — a compiled `Schema`, bound to one `Connection` and one collection. Created via `mongoose.model('Name', schema)` or `connection.model('Name', schema)`. Has static methods (`find`, `create`, `updateOne`, ...).
3. **`Document`** — a single instance of a `Model` (`new Model({...})` or a query result). Has instance methods (`save`, `validate`, `populate`, `toObject`, ...) and change tracking.
4. **`Query`** — a *thenable builder* returned by most `Model` static methods (`Model.find()`, etc). Not a Promise — chain builder methods, then `await`/`.exec()`/`.then()` **once**.
5. **`Connection`** — the actual socket pool to MongoDB. `mongoose.connect()` creates/uses the *default* connection (`mongoose.connection`); `mongoose.createConnection()` makes an independent one. Models are always scoped to exactly one connection.

Key things that trip people up (full detail in the troubleshooting reference):
- Mongoose **buffers** model calls before a connection is open — so code "works" even with no `await mongoose.connect()` yet, until it silently times out later (`bufferCommands`).
- A `Query` is not a Promise: calling `.then()`/`.exec()` a second time throws.
- `save()` runs validation + `pre('save')`/`pre('validate')` hooks; `updateOne()`/`findOneAndUpdate()` do **not**, unless you set `runValidators: true`, and they never run `save` hooks at all.
- `strict` (schema) governs whether unknown fields are dropped on **write**; `strictQuery` (separate option) governs whether unknown fields are stripped from **query filters**.
- `unique: true` is **not a validator** — it's a MongoDB index. Race conditions and `E11000` duplicate-key errors are a driver-level `MongoServerError`, not a `ValidationError`.
- Casting happens before validation; a bad cast (`CastError`) is caught inside a `ValidationError.errors` map, it doesn't throw immediately on assignment.

## Fast-start snippet (connect → schema → model → CRUD)

```js
import mongoose from 'mongoose';
const { Schema } = mongoose;

// 1. Connect (do this once, at app startup)
await mongoose.connect('mongodb://127.0.0.1:27017/myapp', {
  serverSelectionTimeoutMS: 5000, // fail fast instead of the 30s default
});
mongoose.connection.on('error', (err) => console.error('MongoDB error:', err));

// 2. Schema
const userSchema = new Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  age: { type: Number, min: 0 },
}, { timestamps: true }); // adds createdAt / updatedAt

userSchema.methods.greet = function () { return `Hi, ${this.name}`; }; // instance method
userSchema.statics.findByEmail = function (email) { return this.findOne({ email }); }; // static

// 3. Model (must define pre/post hooks & plugins BEFORE this line)
const User = mongoose.model('User', userSchema);

// 4. CRUD
const user = await User.create({ name: 'Ada', email: 'ada@example.com', age: 30 });
const found = await User.findOne({ email: 'ada@example.com' });
await User.updateOne({ _id: user._id }, { $set: { age: 31 } }, { runValidators: true });
await User.deleteOne({ _id: user._id });
```

## Version note

Docs were pulled from mongoose v9.9.1 (mongoosejs.com/docs, current at skill-authoring time). Core concepts (Schema/Model/Document/Query/Connection, validation, middleware, populate) have been stable across v6/v7/v8/v9. If the user's `package.json` pins an older major version (6.x/7.x/8.x), the same mental model applies — flag any version-specific option (e.g. `strictQuery` default changed in v7) rather than assuming v9 defaults.
