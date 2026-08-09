# Queries & CRUD

Source: https://mongoosejs.com/docs/queries.html, https://mongoosejs.com/docs/api/query.html, https://mongoosejs.com/docs/api/model.html

## Model static CRUD methods (all return a `Query`)

`find`, `findOne`, `findById`, `findOneAndUpdate`, `findByIdAndUpdate`, `findOneAndDelete`, `findByIdAndDelete`, `findOneAndReplace`, `updateOne`, `updateMany`, `replaceOne`, `deleteOne`, `deleteMany`, `countDocuments`, `estimatedDocumentCount`, `distinct`, `exists`, `create`, `insertMany`, `bulkWrite`, `aggregate`, `populate`, `hydrate`.

## Two equivalent ways to query

```js
// JSON filter object
await Person.find({ occupation: /host/, age: { $gt: 17, $lt: 66 } }).limit(10).sort({ occupation: -1 });

// Chainable query builder
await Person.find({ occupation: /host/ }).where('age').gt(17).lt(66).limit(10).sort('-occupation');
```

## Queries are NOT Promises

A `Query` is a **thenable** (has `.then()` for `await` convenience) but calling `.then()`/`.exec()` **executes** the query. Calling it a **second time throws**:
```
Error: Query was already executed: Test.updateMany({}, {...})
```
Don't store a query in a variable and `await` it twice, and don't both `await` it and separately call `.exec()`/`.then()` on it.

## `.lean()`

`Model.find().lean()` returns plain JS objects instead of hydrated Documents — faster, less memory, good for read-only paths. Bypasses: change tracking, validation, `save()`, getters, defaults, virtuals (incl. populated virtuals). If you need any of those on lean results, use `Model.applyDefaults()` / `Model.applyVirtuals()` or plugins like `mongoose-lean-getters`/`mongoose-lean-virtuals`.

## Casting

Query filter/update values are cast to the schema's types before hitting MongoDB (e.g. a string `_id` → `ObjectId`). This is why `Model.findOne({ _id: idString })` works. **Aggregation pipelines are NOT cast** — you must pass correctly-typed values (e.g. `new mongoose.Types.ObjectId(idString)`) into `$match` yourself, or the stage silently matches nothing.

## Sorting

`sort({ field: 1 | -1 })` or `sort('-field otherField')`. With multiple keys, order determines precedence (first key sorted first, ties broken by the next key).

## Streaming / cursors

```js
const cursor = Person.find({ occupation: /host/ }).cursor();
for (let doc = await cursor.next(); doc != null; doc = await cursor.next()) { /* ... */ }
// or, equivalently:
for await (const doc of Person.find()) { /* ... */ }
```
MongoDB closes idle cursors after 10 min by default (`addCursorFlag('noCursorTimeout', true)` to override), and session idle timeouts can still close a cursor after ~30 min regardless.

## Queries vs. Aggregation

Prefer queries; drop to `Model.aggregate([...])` only when you need pipeline-only features. Key differences:
- Aggregation results are **always plain objects**, never hydrated Documents (no `hydrate()` applied).
- Aggregation pipelines are **not cast** (see above) — a common silent-bug source.

## Update semantics (query-level vs document-level)

- `doc.save()` — diffs against loaded state, sends a targeted `updateOne` with just the modified paths; runs full validation + `save`/`validate` middleware.
- `Model.updateOne()` / `updateMany()` / `findOneAndUpdate()` — direct MongoDB update ops; do **not** run `save` hooks or validation by default (see `validation-and-middleware.md` for `runValidators`).
- `strict` schema option governs whether unknown fields in an update payload get dropped; `strictQuery` is the separate, query-filter-only equivalent — don't confuse the two when debugging "why did my filter/update silently do nothing/too much."

## `Model.create()` vs `new Model()` + `save()`

`create()` is sugar for `new Model(doc); await doc.save()` (and fires the same `save` hooks) — but accepts an array for bulk inserts (`insertMany` is faster for large bulk inserts but skips some middleware; check `references/validation-and-middleware.md`).
