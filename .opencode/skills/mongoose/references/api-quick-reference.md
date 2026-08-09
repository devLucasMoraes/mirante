# API Quick Reference

Condensed member lists for the 9 core classes, with canonical docs URLs. This is NOT exhaustive (Mongoose's full API docs are thousands of lines) — use it to recall the right method name fast, then `web_fetch` the linked page if you need exact signatures/options for something obscure.

## `Mongoose` (the module singleton) — https://mongoosejs.com/docs/api/mongoose.html
`connect()`, `createConnection()`, `disconnect()`, `model(name, schema?)`, `models` (registry object), `Schema`, `Types` (`ObjectId`, `Decimal128`, `Map`, ...), `connection` (default Connection), `set(option, value)` / `get(option)` (global config: `strictQuery`, `autoIndex`, `debug`, ...), `plugin(fn)` (global plugin), `isValidObjectId(v)`, `syncIndexes()`.

## `Schema` — https://mongoosejs.com/docs/api/schema.html
`new Schema(definition, options)`, `.add(obj)`, `.path(name)`, `.pre(hook, fn)`, `.post(hook, fn)`, `.virtual(name)`, `.index(fields, opts)`, `.plugin(fn)`, `.method(name, fn)` / `.methods`, `.static(name, fn)` / `.statics`, `.query` (query helpers), `.set(option, value)`, `.loadClass(cls)`, `.discriminator(name, schema)`.

## `Connection` — https://mongoosejs.com/docs/api/connection.html
`.model(name, schema?)`, `.models`, `.close()`, `.asPromise()`, `.useDb(name, opts)`, `.on(event, fn)`, `.readyState` (0=disconnected,1=connected,2=connecting,3=disconnecting), `.db` (underlying native driver Db), `.startSession()` (transactions), `.dropDatabase()`.

## `Document` — https://mongoosejs.com/docs/api/document.html
`.save(opts?)`, `.validate()` / `.validateSync()`, `.toObject(opts?)` / `.toJSON(opts?)`, `.isModified(path?)`, `.isNew`, `.$getChanges()`, `.set(path, val)` / `.get(path)`, `.populate(path|paths)`, `.populated(path)`, `.depopulate(path?)`, `.invalidate(path, message)`, `.equals(otherDoc)`, `.$isEmpty(path)`, `.$isDeleted()`, `.overwrite(obj)`.

## `Model` (extends `Document`, adds statics) — https://mongoosejs.com/docs/api/model.html
CRUD: `find`, `findOne`, `findById`, `findOneAndUpdate`, `findByIdAndUpdate`, `findOneAndDelete`, `findByIdAndDelete`, `findOneAndReplace`, `updateOne`, `updateMany`, `replaceOne`, `deleteOne`, `deleteMany`, `countDocuments`, `estimatedDocumentCount`, `distinct`, `exists`.
Bulk/lifecycle: `create`, `insertMany`, `bulkWrite`, `hydrate(obj)`, `init()` (wait for index builds), `createCollection()`, `createIndexes()` / `ensureIndexes()`, `syncIndexes()`, `startSession()`, `watch()` (change streams), `aggregate(pipeline)`, `populate(docs, opts)`, `applyDefaults()`, `applyVirtuals()`, `discriminator(name, schema)`.

## `Query` — https://mongoosejs.com/docs/api/query.html
Builder chain: `.where()`, `.equals()`, `.gt/gte/lt/lte()`, `.in/nin()`, `.select()`, `.sort()`, `.limit()`, `.skip()`, `.populate()`, `.lean()`, `.session()`, `.setOptions(opts)`, `.collation()`, `.read(pref)`.
Execution: `.exec()`, `.then()` (thenable, single-use), `.cursor()`.
Introspection (esp. inside middleware, `this` = Query): `.getFilter()`, `.getQuery()`, `.getUpdate()`, `.getOptions()`, `.model` (the Model class).

## `Aggregate` — https://mongoosejs.com/docs/api/aggregate.html
Stage builders mirroring the pipeline: `.match()`, `.group()`, `.project()`, `.sort()`, `.limit()`, `.skip()`, `.unwind()`, `.lookup()`, `.addFields()`, `.replaceRoot()`, `.facet()`, `.count()`. Plus `.pipeline()` (raw array, mutate directly — used a lot in `pre('aggregate')` hooks), `.exec()`, `.option(opts)`, `.session()`, `.cursor(opts)`.
Reminder: results are always POJOs; pipeline values are not auto-cast.

## `SchemaType` (base for `SchemaString`, `SchemaNumber`, `SchemaDate`, `SchemaBoolean`, `SchemaObjectId`, `SchemaArray`, `SchemaMap`, ...) — https://mongoosejs.com/docs/api/schematype.html
`.required(bool|fn)`, `.default(val|fn)`, `.validate(fn, msg)`, `.get(fn)` / `.set(fn)` (path-level getter/setter), `.index(opts)`, `.unique(bool)`, `.sparse(bool)`, `.select(bool)` (default projection inclusion), `.immutable(bool)`.
Type-specific extras worth remembering: String → `.enum()`, `.match()`, `.minLength()`/`.maxLength()`, `.lowercase()`/`.uppercase()`/`.trim()`; Number → `.min()`/`.max()`; Date → `.min()`/`.max()`, `expires` option (TTL index).

## `VirtualType` — https://mongoosejs.com/docs/api/virtualtype.html
`.get(fn)`, `.set(fn)` — defines the computed getter/setter for a virtual created via `schema.virtual(name)`. For populate virtuals, the virtual is instead configured via an options object at creation time: `schema.virtual(name, { ref, localField, foreignField, justOne?, count?, match? })`.

## Full docs index
https://mongoosejs.com/docs/index.html (quick start) · https://mongoosejs.com/docs/guides.html (all guides, incl. Subdocuments, Discriminators, Plugins, Transactions, TypeScript, which are out of scope for this skill but linked here for deep dives) · https://mongoosejs.com/docs/migrating_to_9.html (breaking changes if the user's on an older major version).
