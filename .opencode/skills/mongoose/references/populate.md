# Populate (references / joins)

Source: https://mongoosejs.com/docs/populate.html

## Basics

```js
const storySchema = Schema({
  author: { type: Schema.Types.ObjectId, ref: 'Person' },
  fans: [{ type: Schema.Types.ObjectId, ref: 'Person' }]
});

const story = await Story.findOne({ title: 'Casino Royale' }).populate('author');
story.author.name; // populated document, not just the ObjectId
```
- `ref` names the model Mongoose queries to resolve the reference. Works with `ObjectId`, `Number`, `String`, `Buffer` path types (ObjectId strongly recommended).
- No document found → the populated path becomes `null` (single ref) or `[]` (array ref) — this mirrors a SQL LEFT JOIN, it does not throw.
- `doc.populated('path')` checks if a path is currently populated; `doc.depopulate('path')` reverses it.
- `story.author._id` works whether or not `author` is populated (Mongoose adds an `_id` getter to ObjectId).

## Field selection & filtering

```js
.populate('author', 'name')                                   // projection shorthand
.populate({ path: 'fans', match: { age: { $gte: 21 } }, select: 'name -_id' })
```
`match` filters the *populated* sub-documents, not the parent documents — a `Story` with zero matching `fans` still comes back, just with an empty `fans` array. You cannot filter parent docs by a populated field's properties in the same query (`{'author.name': ...}` + `.populate('author')` won't work) — denormalize the field you need to filter on instead.

## `limit` vs `perDocumentLimit`

Populate's `limit` option is **applied across all parent documents combined** (`numDocuments * limit`), NOT per-document — a classic gotcha that silently starves later documents in the result set of their expected number of populated items. Use `perDocumentLimit` (extra query per parent doc, slower but correct) when you need a true per-document cap.

## Populating multiple paths

```js
await Story.find().populate('fans').populate('author');
```
Calling `.populate()` twice on the **same path** overwrites the first call rather than merging — the last one wins.

## Populate virtuals (for one-to-many where the FK lives on the "many" side)

```js
authorSchema.virtual('posts', { ref: 'BlogPost', localField: '_id', foreignField: 'author' });
const author = await Author.findOne().populate('posts');
```
- Use this instead of storing an array of child IDs on the parent (anti-pattern for large fan-out — the *Principle of Least Cardinality*: one-to-many refs belong on the "many" side).
- Virtuals (including populate virtuals) are excluded from `toJSON()`/`toObject()` by default — set `{ virtuals: true }` on those schema options or they silently vanish from API responses.
- If using `select` alongside a populate virtual, you must keep the `foreignField` in the selected fields or the populate silently returns nothing.
- `count: true` on the virtual returns a count instead of the documents.

## Cross-database populate

Pass the **actual Model class** (not a string) as `ref`, or pass `{ model: OtherModel }` to `.populate()`, when the referenced model lives on a different `Connection`/database — string `ref` only resolves models on the *same* connection.

## Dynamic references

- `refPath: 'fieldName'` — Mongoose reads a sibling field's *value* on each document to decide which model to populate from (polymorphic refs, e.g. comments on either `BlogPost` or `Product`).
- `refPath`/`ref` can also be a **function** returning the model name — needed for array-of-subdocuments refs, since a static path string like `'items.targetModel'` won't work per-array-element (you need `'items.0.targetModel'`); use `refPath: (doc, path) => path.replace(/\.target$/, '.targetModel')`.

## Populating in middleware — infinite recursion trap

```js
schema.pre('find', function () {
  if (this.options._recursed) return;
  this.populate({ path: 'followers following', options: { _recursed: true } });
});
```
Populating multiple space-separated paths from inside a `pre('find')` hook without the `_recursed` guard causes an infinite loop, because each populate call re-triggers the same `find` hook.
