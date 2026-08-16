# Setup, Teardown, Fixtures & Mocking

## Hooks

- `beforeEach(fn)` / `afterEach(fn)` — run before/after **every test** in scope. `afterEach` runs even if the test fails. Use to guarantee clean state per test.
- `beforeAll(fn)` / `afterAll(fn)` — run **once** per file/suite. Use for expensive setup (DB connections, servers) too costly to repeat per test.
- Hooks defined inside `describe(...)` are scoped to that suite only; top-level hooks apply to the whole file.
- `beforeEach`/`beforeAll` can **return a cleanup function** instead of needing a separate `afterEach`/`afterAll`:
  ```js
  beforeEach(() => {
    const server = startServer()
    return () => server.close()  // cleanup, paired automatically
  })
  ```

### Execution order (top-level vs. nested describe)

Outer hooks wrap inner hooks. For one top-level `beforeEach`/`afterEach` plus one inside a `describe`, per test the order is:
```
beforeAll (once)
  beforeEach (outer)
    beforeEach (inner, i.e. inside describe)
      <test>
    afterEach (inner)
  afterEach (outer)
  ... repeats per test ...
afterAll (once)
```
i.e., setup narrows from outer→inner before the test; teardown widens from inner→outer after.

### `aroundEach` / `aroundAll` (advanced — wrapping context)
Use when a test needs to run **inside** a wrapping context (DB transaction, tracing span, `AsyncLocalStorage`) rather than just before/after:
```js
aroundEach(async (runTest) => {
  await db.transaction(runTest)  // must call runTest()
})
test('insert user', async () => {
  await db.insert({ name: 'Alice' })
  // transaction auto-rolled-back after the test
})
```
`aroundAll` is the suite-level equivalent, receiving `runSuite`. Both **must call** their `run*()` callback or the test/suite fails/is skipped. If you just need ordinary before/after code, prefer plain `beforeEach`/`beforeAll` with a returned cleanup function — simpler.

### Test-scoped cleanup hooks
- `onTestFinished(fn)` — always runs after a test finishes (even on failure, after `afterEach`). Good for pairing resource creation + cleanup inline, and for reusable helper functions:
  ```js
  test('performs a query', () => {
    const db = connectDb()
    onTestFinished(() => db.close())
    db.query('SELECT * FROM users')
  })
  ```
- `onTestFailed(fn)` — only runs if the test failed; useful for debug logging (`console.log(task.result.errors)`).
- **With `test.concurrent`, use the context-bound versions** (`({ onTestFinished }) => {...}`) — global hooks don't reliably track which concurrent test they belong to.

### Setup files (project-wide, before every test file)
```js
// vitest.config.js
export default defineConfig({ test: { setupFiles: ['./test/setup.js'] } })
```
```js
// test/setup.js — runs before EACH test file (not once globally)
import { expect } from 'vitest'
import { customMatchers } from './custom-matchers.js'
expect.extend(customMatchers)
```
Right place for `expect.extend`, polyfills, global config. Different from `beforeAll` (which runs once per file, from *inside* that file) — setup files run in a separate phase before collection even starts, once per test file.

## Fixtures with `test.extend` (preferred over `let` + `beforeEach` for reusable state)

```js
// my-test.js
import { test as baseTest } from 'vitest'

export const test = baseTest
  .extend('db', async ({}, { onCleanup }) => {
    const db = await createDatabase()
    onCleanup(() => db.close())
    return db
  })
  .extend('user', async ({ db }) => {
    return await db.createUser({ name: 'Alice' })
  })
```
```js
// my-test.test.js
import { expect } from 'vitest'
import { test } from './my-test.js'

test('user is created', ({ db, user }) => {
  expect(user.name).toBe('Alice')
})
```
Fixtures init lazily (only when destructured in a test), can depend on each other, and auto-clean-up. Prefer this over module-level `let` variables + `beforeEach`, which are prone to leaking state across tests if you forget to reset something. See the Vitest "Test Context" guide for scoping/override details beyond this summary.

---

## Mocking with `vi`

### Creating mocks
```js
const getApples = vi.fn()               // bare mock, returns undefined by default
getApples.mockReturnValue(10)             // always returns 10
getApples.mockReturnValueOnce(20)         // returns 20 once, then falls back
getApples.mockImplementation((a, b) => a + b)  // full custom logic
const add = vi.fn((a, b) => a + b)         // shorthand: implementation inline
```
Async variants: `mockResolvedValue(x)`, `mockRejectedValue(err)`.

### Spying on existing methods (keeps real behavior unless overridden)
```js
const spy = vi.spyOn(calculator, 'add')
calculator.add(1, 2)          // still runs the real implementation
expect(spy).toHaveBeenCalledWith(1, 2)

spy.mockReturnValue(42)        // now overrides
expect(calculator.add(1, 2)).toBe(42)
```

### Inspecting calls
```js
expect(fn).toHaveBeenCalledTimes(2)
expect(fn).toHaveBeenCalledWith('Alice')
expect(fn).toHaveBeenNthCalledWith(1, 'Alice')
expect(fn).toHaveBeenLastCalledWith('Bob', 'Charlie')
fn.mock.calls    // [[arg1, arg2], ...] — raw call history
fn.mock.results  // [{ type: 'return'|'throw', value }, ...]
```
**Gotcha**: `.mock.calls` stores *references* to arguments, not copies. If you pass an object and mutate it later, the recorded call reflects the *mutated* state. Fix: clone at call time (`structuredClone(obj)` inside a `mockImplementation`) or assert before mutating.

### Resetting mocks — the three levels
- `mockClear()` — clears call history/results, keeps custom implementation.
- `mockReset()` — clears everything *and* removes custom implementation (back to bare mock).
- `mockRestore()` — for `vi.spyOn` mocks specifically: restores the **original** method entirely (for `vi.fn()`, behaves like `mockReset`).

**Best practice**: enable globally instead of manual cleanup:
```js
// vitest.config.js
export default defineConfig({ test: { restoreMocks: true } })
```
This calls `mockRestore()` after every test automatically — the single most effective fix for "mock leaked into the next test" bugs. See `debugging-and-errors.md`.

### Mocking modules
```js
import { getUser } from './db.js'

vi.mock(import('./db.js'), () => ({
  getUser: vi.fn(),
}))

test('mock a module', () => {
  vi.mocked(getUser).mockReturnValue({ name: 'Alice' })
  const user = getUser(1)
  expect(user.name).toBe('Alice')
})
```
- **`vi.mock` calls are hoisted** to the top of the file, before imports run — the mock is already active by the time your test code executes.
- **Prefer `vi.mock(import('./db.js'), ...)`** over the bare-string form `vi.mock('./db.js', ...)` — the `import()` form gives you type inference on the factory's return value and `importOriginal`, and IDE refactors (rename/move file) update the path automatically. This is also the #1 thing AI-generated tests get wrong (they often use the string form).
- In Browser Mode specifically, `vi.spyOn` on a module's named export throws (sealed ESM namespace) — use `vi.mock('./module.js', { spy: true })` instead. See `browser-mode.md`.

### Other mocking guides (consult only if the task needs them — don't guess syntax)
- **Timers**: `vi.useFakeTimers()`, `vi.advanceTimersByTime(ms)`, `vi.useRealTimers()`.
- **Dates**: `vi.setSystemTime(date)` (note: `vi.useFakeTimers()` also affects `Date`).
- **Globals**: `vi.stubGlobal(name, value)` or assign directly to `globalThis`.
- **Requests**: prefer [MSW](https://mswjs.io/) over mocking `fetch` directly — see `requests` guide in official docs if setting up.
- **File system, Classes**: dedicated official guides exist (`guide/mocking/file-system`, `guide/mocking/classes`) — fetch if the task specifically requires them.

## Sources

- <https://vitest.dev/guide/learn/setup-teardown>
- <https://vitest.dev/guide/learn/mock-functions>
- <https://vitest.dev/api/hooks> (beforeEach/afterEach/beforeAll/afterAll/aroundEach/aroundAll/onTestFinished/onTestFailed — full signatures)
- <https://vitest.dev/guide/test-context> (test.extend fixtures, scoping, overrides — full detail)
- <https://vitest.dev/guide/mocking> (vi.mock deep dive, dates, globals)
- <https://vitest.dev/guide/mocking/timers>
- <https://vitest.dev/guide/mocking/dates>
- <https://vitest.dev/guide/mocking/globals>
- <https://vitest.dev/guide/mocking/modules>
- <https://vitest.dev/guide/mocking/requests>
- <https://vitest.dev/guide/mocking/file-system>
- <https://vitest.dev/guide/mocking/classes>
- <https://vitest.dev/api/mock> (mockClear/mockReset/mockRestore and all `.mock` properties — full reference)
- <https://vitest.dev/api/vi> (the full `vi` object API)
