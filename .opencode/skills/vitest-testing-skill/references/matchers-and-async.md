# Matchers, Async Testing & Snapshots

## Matchers in depth

### Equality
- `toBe(x)` — exact identity via `Object.is`. Use for primitives (numbers, strings, booleans). For objects, checks it's the *same object in memory*, not same shape.
- `toEqual(x)` — recursive structural equality, ignores object identity, **ignores `undefined` properties**.
- `toStrictEqual(x)` — like `toEqual` but also: checks `undefined` properties, distinguishes sparse arrays from arrays with `undefined` holes, and verifies matching object *types* (a plain object won't strict-equal a class instance with the same fields).

```js
expect({ a: 1 }).toEqual({ a: 1, b: undefined })       // passes — toEqual ignores undefined
expect({ a: 1 }).not.toStrictEqual({ a: 1, b: undefined }) // strict catches it
class User { constructor(name) { this.name = name } }
expect(new User('Alice')).toEqual({ name: 'Alice' })         // passes
expect(new User('Alice')).not.toStrictEqual({ name: 'Alice' }) // fails — different type
```

Negate any matcher with `.not`: `expect(x).not.toBe(y)`.

### Truthiness
`toBeNull` (only `null`), `toBeUndefined` (only `undefined`), `toBeDefined` (anything but `undefined`), `toBeTruthy`/`toBeFalsy` (JS truthiness). **Gotcha**: `toBeTruthy()` where you mean `toBeDefined()` hides bugs — `0` and `""` are defined but falsy.

### Numbers
`toBeGreaterThan`, `toBeGreaterThanOrEqual`, `toBeLessThan`, `toBeLessThanOrEqual`. **Floating point gotcha**: `0.1 + 0.2 !== 0.3` exactly in JS — use `toBeCloseTo(0.3)` instead of `toBe(0.3)` for any float arithmetic.

### Strings & collections
- `toMatch(regexOrSubstring)` — string against pattern.
- `toContain(item)` — array/Set/iterable includes item (uses `===`, good for primitives).
- `toContainEqual(obj)` — array contains an object with matching structure (like `toEqual` per-item).
- `toMatchObject({...})` — object contains *at least* these fields (ignores extras) — great for asserting on a subset of a large object.
- `toHaveProperty('a.b.c', value)` — dot-path property check, value arg optional.

### Exceptions
```js
// Must wrap in a function so Vitest can catch it — the call itself must not throw before expect() runs
expect(() => compileCode('')).toThrow()
expect(() => compileCode('')).toThrow('Cannot compile empty string')  // substring match
expect(() => compileCode('')).toThrow(/empty string/)                  // regex match
```
Common mistake: `expect(compileCode('')).toThrow()` — this throws *before* `expect` can catch it, crashing the test instead of failing it cleanly.

### Asymmetric matchers
Use inside `toEqual`/`toMatchObject` when you know shape but not exact value:
```js
expect(user).toEqual({
  id: expect.any(Number),
  email: expect.stringContaining('@'),
  roles: expect.arrayContaining(['viewer']),
})
```
Available: `expect.any(Ctor)`, `expect.stringContaining(str)`, `expect.stringMatching(regex)`, `expect.arrayContaining(arr)` (order-independent, extras OK), `expect.objectContaining(obj)`.

### Soft assertions
`expect.soft(x).toBe(y)` records a failure but keeps running the test, so you see *all* failing fields at once instead of stopping at the first — useful for validating many fields of an API response in one test.

---

## Async testing

### Preferred pattern: async/await
```js
test('fetches user by id', async () => {
  const user = await fetchUser(1)
  expect(user.name).toBe('Alice')
})
```

### `.resolves` / `.rejects`
```js
await expect(fetchUser(1)).resolves.toMatchObject({ name: 'Alice' })
await expect(fetchInvalidUser()).rejects.toThrow('User not found')
```
**Never forget the `await`** before `expect(promise).resolves/.rejects` — Vitest warns about unawaited assertions at test end, but an unawaited one can let a test pass even when the underlying promise actually rejected.

### Assertion counting (for callbacks/loops where an assertion might never run)
```js
test('callback is invoked', async () => {
  expect.hasAssertions() // fails the test if zero assertions ran
  const data = await fetchData()
  data.items.forEach(item => expect(item.id).toBeDefined())
})
```
Use `expect.assertions(n)` when you know the exact expected count. Enable `expect.requireAssertions` globally in config to require this everywhere without per-test boilerplate.

### Callback-based APIs
Wrap in a `Promise`:
```js
test('the data is peanut butter', async () => {
  const data = await new Promise(resolve => fetchData(resolve))
  expect(data).toBe('peanut butter')
})
```

### Timeouts
Default is 5s per test. Third arg to `test()`, or globally via `testTimeout` in config:
```js
test('long-running operation', async () => { await someSlowOperation() }, 10_000)
```

### Unhandled rejections fail the run
By default, an unhandled promise rejection anywhere during a test **fails the test run**, even if all assertions passed — this is intentional (usually a missing `await` or fire-and-forget bug). Fix by awaiting/catching, or filter specific known-safe rejections via `onUnhandledError` config (last resort: `dangerouslyIgnoreUnhandledErrors`).

---

## Snapshot testing

### Basic
```js
test('generates a greeting', () => {
  expect(generateGreeting('Alice')).toMatchSnapshot()
})
```
First run creates `__snapshots__/example.test.js.snap`. Every subsequent run compares against it and fails with a diff on any change. **Commit snapshot files to version control** — they're reviewable test assertions.

### Inline snapshots
`toMatchInlineSnapshot()` — Vitest auto-fills the expected value as a string argument directly in your test file on first run. Best for small values (keeps expectation next to the assertion, no separate file to manage). For large output (full HTML pages), prefer external or file snapshots instead.

### File snapshots
`await expect(html).toMatchFileSnapshot('./fixtures/component.html')` — writes to a real file with the given extension, viewable with syntax highlighting / diffable with standard tools. Good for HTML/SVG/CSS/generated code. Note: **async**, must `await`.

### Updating snapshots
- Watch mode: press `u`
- CLI: `vitest -u` or `vitest --update`
- **Always review the diff before accepting** — it's easy to blindly `u` past a real bug.

### Dynamic values (timestamps, random IDs)
Pin volatile fields with property matchers, passed as the first arg to the snapshot call:
```js
expect(user).toMatchSnapshot({
  id: expect.any(Number),
  createdAt: expect.any(Date),
})
```

### When to use vs. not use snapshots
Use for large structured output you want protected against *any* change (rendered markup, complex config objects, formatted multi-line error/CLI output). **Don't** use snapshots when output changes every run without pinning (timestamps/random IDs unaccounted for) — you'll spend more time updating than the snapshot saves you. If you only care about 1-2 fields, a targeted `toMatchObject`/`toHaveProperty` assertion is clearer intent than a snapshot of everything.

### Error snapshots
`toThrowErrorMatchingInlineSnapshot()` combines `toThrow` + inline snapshot for capturing exact error messages:
```js
expect(() => parse('')).toThrowErrorMatchingInlineSnapshot(
  `[Error: Unexpected end of input at position 0]`
)
```

## Sources

- <https://vitest.dev/guide/learn/matchers>
- <https://vitest.dev/guide/learn/async>
- <https://vitest.dev/guide/learn/snapshots>
- <https://vitest.dev/guide/snapshot> (advanced: custom serializers/matchers)
- <https://vitest.dev/api/expect> (complete matcher API reference)
