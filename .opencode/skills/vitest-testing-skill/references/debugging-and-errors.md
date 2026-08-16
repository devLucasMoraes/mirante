# Debugging Failing Tests & Common Errors

Read this file whenever a Vitest test fails and the cause isn't immediately obvious. Don't guess-and-check blindly — work the checklist below in order.

## Step 1: Read the failure output carefully

```
 FAIL src/user.test.js > createUser > sets the default role
AssertionError: expected { name: 'Alice', role: 'viewer' } to deeply equal { name: 'Alice', role: 'member' }

- Expected
+ Received

  {
    "name": "Alice",
-   "role": "member",
+   "role": "viewer",
  }

 ❯ src/user.test.js:8:22
      6|   test('sets the default role', () => {
      7|     const user = createUser('Alice')
      8|     expect(user).toEqual({ name: 'Alice', role: 'member' })
                          ^
      9|   })
```

- **Header** (`FAIL file > describe > test`) — exact location in the test tree.
- **Assertion message** — which matcher failed and the two values compared.
- **Diff** — `-` lines are expected, `+` lines are what you actually got.
- **Code snippet + caret** — exact failing line, usually clickable in terminal/IDE.

Ask: did the *source code* change intentionally (update the test), or is this a real regression (fix the code)? Go read the actual implementation before assuming either way.

## Step 2: Isolate the failure

```bash
vitest src/user.test.js                              # only this file
vitest -t "sets the default role"                      # only tests matching name
vitest src/user.test.js -t "sets the default role"      # both, max precision
```
Or add `.only` directly: `test.only('sets the default role', () => {...})`.

If many tests are failing and you want to focus on the first: `vitest --bail 1`.

**Critical diagnostic**: if a test **passes alone** but **fails when run with the full suite**, this is a test-isolation problem — go straight to "Shared State" below, not the test's own logic. If it fails even in isolation, the bug is in the test or the code it tests.

## Step 3: Check the common-cause list

### Shared state between tests
The single most common flaky-test cause. Some other test mutates module-level/global state and doesn't clean up.
```js
// ❌ `users` is shared across every test in the file
const users = []
test('adds a user', () => { users.push('Alice'); expect(users).toEqual(['Alice']) })
test('starts empty', () => { expect(users).toEqual([]) })  // fails — Alice is still there!
```
Fix: reset in `beforeEach`, or better, use a `test.extend` fixture that creates fresh state per test (see `setup-and-mocking.md`).

### Missing `await`
```js
// ❌ test always passes even if fetchUser rejects — finishes before promise settles
test('fetches user', () => {
  expect(fetchUser(1)).resolves.toMatchObject({ name: 'Alice' })
})
// ✅
test('fetches user', async () => {
  await expect(fetchUser(1)).resolves.toMatchObject({ name: 'Alice' })
})
```
Vitest prints a warning about unawaited assertions at test end — take that warning seriously, it usually points at exactly this bug. If a test **hangs and times out**, that also usually means a promise never resolves — check for missing callbacks or deadlocks.

### Stale snapshots
Expected if you intentionally changed output — review the diff, then `vitest -u`. Not a bug by itself, but **always review before accepting** the update.

### Wrong test environment
Error like `document is not defined` or `window is not defined` → your code expects browser globals but tests run in the default `node` environment. Fix: set `environment: 'jsdom'` (or `'happy-dom'`) in config, per-file with a `// @vitest-environment jsdom` comment at the top of the file, or — for real DOM/CSS accuracy — switch to Browser Mode (see `browser-mode.md`).

### Leaked / uncleaned mocks
A `vi.spyOn` override from one test persists into the next test if not restored. Fix globally:
```js
// vitest.config.js
export default defineConfig({ test: { restoreMocks: true } })
```
This is the single highest-leverage config change for eliminating "worked alone, fails in suite" mock bugs.

### Unhandled promise rejections
By default these **fail the run** even if assertions passed — usually a missing `await`/`.catch()` somewhere in the code under test, not the test itself. See `matchers-and-async.md`.

## Step 4: Debugging tools

- **`console.log`** — perfectly fine, shown inline with the relevant test's results.
- **`vitest --ui`** — visual dashboard with per-test status, output, and a module dependency graph (useful for "why does changing file A break tests in file B"). Requires `@vitest/ui` installed.
- **VS Code extension** (official Vitest extension) — run/debug individual tests from the editor, set breakpoints, step through.
- **Verbose reporter**: `vitest --reporter=verbose` — shows every individual test, not just collapsed per-file summaries; helps spot patterns across many failures.
- **Attach a real debugger**:
  ```bash
  vitest --inspect-brk --no-file-parallelism
  ```
  `--no-file-parallelism` forces the main thread so breakpoints work reliably. Attach from VS Code, IntelliJ, or `chrome://inspect`.

## Step 5: Still stuck

- The official **Common Errors** page (`vitest.dev/guide/common-errors`) documents specific error messages and fixes — search it for the exact error text before assuming it's project-specific.
- Check GitHub Issues (`github.com/vitest-dev/vitest/issues`) for known bugs/workarounds if the error looks like a Vitest internals problem rather than a test-writing mistake.
- The Discord community (`chat.vitest.dev`) for live help as a last resort.

## Config-driven fixes worth knowing

| Symptom | Likely fix |
|---|---|
| Mocks leak between tests | `restoreMocks: true` |
| Need browser globals (`window`, `document`) | `environment: 'jsdom'` or `'happy-dom'` (or Browser Mode) |
| Test hangs past 5s legitimately | raise `testTimeout` (globally or per-test 3rd arg) |
| Hook (`beforeAll`/`afterEach`) takes too long | raise `hookTimeout` |
| `expect.extend`/polyfills needed everywhere | put them in a `setupFiles` entry, not a per-file import |
| Tests silently pass despite bad async code | add `expect.hasAssertions()` or enable `expect.requireAssertions` globally |
| Process never exits when run by a script/agent | use `vitest run` (or `--no-watch`), never bare `vitest` |

## Sources

- <https://vitest.dev/guide/learn/debugging-tests>
- <https://vitest.dev/guide/common-errors> (specific error messages and fixes — check here first for anything not covered above)
- <https://vitest.dev/guide/debugging> (editor-specific debugger setup: VS Code, IntelliJ, Chrome DevTools)
- <https://vitest.dev/guide/ui>
- <https://github.com/vitest-dev/vitest/issues>
- <https://chat.vitest.dev>
