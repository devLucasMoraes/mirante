# Validation & Middleware (hooks)

Source: https://mongoosejs.com/docs/validation.html, https://mongoosejs.com/docs/middleware.html

## Validation ground rules

- Validation is defined on the `SchemaType` and runs as **middleware** — registered as the **first** `pre('save')` hook by default, so changes made in *other* `pre('save')` hooks are not re-validated.
- Disable auto-validation-before-save with the schema option `validateBeforeSave: false`; run manually with `doc.validate()` (async) or `doc.validateSync()`.
- Validators do **not** run on `undefined` values, except `required`.
- Built-ins: `required` (all types), `min`/`max` (Number), `enum`/`match`/`minLength`/`maxLength` (String).
- `unique: true` is an **index**, not a validator — see `errors-troubleshooting.md`.

## Custom validators

```js
phone: {
  type: String,
  validate: {
    validator: v => /\d{3}-\d{3}-\d{4}/.test(v),
    message: props => `${props.value} is not a valid phone number!`
  }
}
```
Async validators: return a Promise (or use `async function`). A rejected promise or a promise resolving to `false` both count as failed validation.

## Validation vs. Cast errors

- **Casting** happens first (coercing input to the schema type). A bad cast does **not** throw immediately on assignment — it's deferred and surfaces as a `CastError` nested inside the `ValidationError.errors` map when you `validate()`/`save()`.
- Overwriting a bad value before validating clears the pending cast error (last value wins).
- Customize the cast error message via the `cast` schema-type option (string template with `{PATH}`/`{VALUE}`/`{KIND}`, or a function).

## Update validators (`runValidators`)

Off by default for `updateOne`/`updateMany`/`findOneAndUpdate`. Turn on with `{ runValidators: true }`. Gotchas:
- Inside a custom validator during an update, `this` is the **Query**, not the document — use `this.get('field')`, not `this.field`.
- Update validators only run on paths actually present in the update payload — a missing `required` field is **not** flagged unless you explicitly `$unset` it.
- Only apply to `$set`, `$unset`, `$push`, `$addToSet`, `$pull`, `$pullAll` — NOT `$inc`, and array-element validators from `$push`/`$addToSet` don't validate the array as a whole, only new elements.

## Required on nested (non-schema) objects

A bare nested object (`{ name: { first: String, last: String } }`) is **not a full path** — `.required(true)` on it throws. To require a nested group, make it a sub-schema: `name: { type: nameSchema, required: true }`.

## Middleware (hooks) — 4 types

| Type | Hooked functions | `this` refers to |
|---|---|---|
| Document | `validate`, `save`, `updateOne` (doc-mode), `deleteOne` (doc-mode), `init` (sync only) | the document |
| Query | `find`, `findOne`, `findOneAndUpdate`, `updateOne`, `updateMany`, `deleteOne`, `deleteMany`, `countDocuments`, `distinct`, etc. | the Query |
| Aggregate | `aggregate` | the Aggregate object (`this.pipeline()` to mutate stages) |
| Model | `insertMany`, `bulkWrite`, `createCollection` | the Model |

**Register hooks before compiling the model** (`mongoose.model(...)`) — hooks added afterward are silently ignored. This is the single most common "my `pre('save')` never fires" bug.

```js
schema.pre('save', function () { /* `this` = doc */ });
schema.pre('save', async function () { await doStuff(); }); // Mongoose awaits it
schema.post('save', function (doc) { /* runs after save + all its pre hooks */ });
```

### `updateOne`/`deleteOne` naming ambiguity

Mongoose registers `updateOne`/`deleteOne` as **query** middleware by default — `Model.updateOne()` triggers them with `this` = Query, but `doc.updateOne()`/`doc.deleteOne()` do **not** trigger them unless you explicitly register document-mode:
```js
schema.pre('updateOne', { document: true, query: false }, function () { /* this = doc */ });
```

### `save()` also runs `validate()` hooks first
Order is always: `pre('validate')` → `post('validate')` → `pre('save')` → (actual save) → `post('save')`.

### You cannot see the pre-update document in query middleware
`pre('updateOne')`/`pre('findOneAndUpdate')` query middleware has `this` = Query, with **no reference to the document being updated**. If you need it: `const doc = await this.model.findOne(this.getQuery())` inside the hook.

### Error-handling middleware
A `post()` hook with an extra leading `error` parameter (3 params total: `(error, doc/res, next)`) runs only when the operation failed — useful for translating `MongoServerError` E11000 into a friendlier error:
```js
schema.post('save', function (error, doc, next) {
  if (error.name === 'MongoServerError' && error.code === 11000) next(new Error('Duplicate key'));
  else next();
});
```
It can transform the error but **cannot swallow it** — the call still ultimately errors.

### `save()` hooks do NOT run on `update()`/`findOneAndUpdate()`
These have their own distinct query middleware instead — don't expect `pre('save')` logic to apply to direct updates.

### `insertMany()`/`bulkWrite()` run model middleware, not document `save` middleware
If your `pre('save')` hook does important defaulting/normalization, it will **not** run for bulk inserts — replicate that logic in a `pre('insertMany')` hook or avoid bulk methods when that logic matters.

### Skipping middleware deliberately
```js
await doc.save({ middleware: false });                 // skip all user pre/post hooks
await Model.find({}, null, { middleware: { post: false } }); // skip only post hooks
```
Built-in Mongoose middleware (timestamps, validation) always runs regardless.

### Query middleware does not run on subdocuments
`childSchema.pre('findOneAndUpdate', ...)` will never fire — only the top-level document's schema hooks fire for query-level operations.
