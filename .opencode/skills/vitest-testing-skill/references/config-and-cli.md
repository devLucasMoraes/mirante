# Config, CLI & Lifecycle

## Config file setup

Vitest reads `vite.config.*` by default. For test-only settings, create a dedicated `vitest.config.ts` — it **overrides** (not merges with) `vite.config.ts` entirely if both exist and vitest.config is used, unless you explicitly merge:

```ts
// vitest.config.ts — standalone
import { defineConfig } from 'vitest/config'
export default defineConfig({
  test: { /* options here */ },
})
```

```ts
// merging with an existing vite.config.ts
import { defineConfig, mergeConfig } from 'vitest/config'
import viteConfig from './vite.config'

export default mergeConfig(viteConfig, defineConfig({
  test: { exclude: ['packages/template/*'] },
}))
```

```ts
// adding test types to a plain vite.config.js (no separate vitest config file)
/// <reference types="vitest/config" />
import { defineConfig } from 'vite'
export default defineConfig({
  test: { /* ... */ },
})
```

All Vite config options (plugins, resolve.alias, define, etc.) go at the **top level**, not nested inside `test:`.

## Most commonly touched options

| Option | Purpose |
|---|---|
| `environment` | `'node'` (default) \| `'jsdom'` \| `'happy-dom'` \| `'edge-runtime'` |
| `globals` | `true` → use `test`/`expect`/`vi` etc. without importing (Jest-style). Add `"types": ["vitest/globals"]` to tsconfig for TS support. |
| `setupFiles` | array of files run before **each test file** (polyfills, `expect.extend`, global config) |
| `include` / `exclude` | override default `**/*.{test,spec}.{ts,js,mjs,cjs,tsx,jsx}` glob |
| `testTimeout` / `hookTimeout` | default 5000ms / 10000ms |
| `restoreMocks` | `true` → auto `mockRestore()` after every test (strongly recommended default) |
| `clearMocks` / `mockReset` | weaker/different auto-cleanup levels — see `setup-and-mocking.md` for the distinction |
| `coverage` | enable + configure coverage (`provider: 'v8'` or `'istanbul'`) |
| `globalSetup` | array of files with one-time `setup()`/`teardown()` before/after the *entire* run (different scope from `setupFiles` — see lifecycle below) |
| `pool` | `'forks'` (default) \| `'threads'` \| `'vmForks'` \| `'vmThreads'` — process/thread isolation strategy |
| `sequence` | control test/file ordering, shuffle, concurrency |
| `browser` | Browser Mode config — see `browser-mode.md` |
| `projects` | run multiple named configs in one invocation (e.g. unit tests in Node + component tests in browser) |

Full alphabetical reference: `vitest.dev/config/` (each option has its own page with type + example).

### Environment variables
Vitest only auto-loads `.env` vars prefixed `VITE_` (Vite convention). To load everything:
```ts
import { loadEnv } from 'vite'
import { defineConfig } from 'vitest/config'
export default defineConfig(({ mode }) => ({
  test: { env: loadEnv(mode, process.cwd(), '') },
}))
```

## CLI reference

```bash
vitest                       # watch mode (default outside CI)
vitest run                    # run once and exit — use for CI/scripts/agents
vitest run path/to/file.test.ts
vitest run path/to/dir/
vitest -t "name pattern"       # filter by test name (regex-ish substring)
vitest run -u                  # update snapshots, run once
vitest --reporter=verbose       # per-test output instead of per-file summary
vitest --reporter=blob          # for sharding, merge later with --merge-reports
vitest --ui                     # visual dashboard (needs @vitest/ui)
vitest --coverage                # run with coverage report
vitest --bail 1                  # stop after N failures
vitest --inspect-brk --no-file-parallelism   # attach a debugger
vitest --standalone               # keep running in background, only test on change
vitest --shard=1/2                # for distributed CI runs
vitest --browser=chromium          # force browser mode with a specific browser
```

**Agent/CI critical rule**: bare `vitest` never exits (watch mode). Always use `vitest run` when invoking Vitest programmatically or in a script that needs to complete.

Full flag list: `npx vitest --help` or `vitest.dev/guide/cli`.

## Test run lifecycle (phase order)

Understanding this order helps place setup code correctly and diagnose "why did X run at the wrong time" bugs.

1. **Initialization** — config loaded, CLI args parsed (main process).
2. **Global Setup** — `globalSetup` files' `setup()` runs once, before any test worker exists. Runs in a separate scope from tests — **cannot** share variables directly with tests (use `project.provide('key', value)` + `inject('key')` in tests instead).
3. **Worker Creation** — workers spawned per `pool` config; isolated per file by default.
4. **Test File Setup** — `setupFiles` run before **each** test file (same process as the tests, unlike global setup).
5. **Test Collection & Execution** — per file: file-level code runs immediately (collection) → `describe` blocks register tests → `aroundAll` → `beforeAll` → for each test: `aroundEach` → `beforeEach` → test body → `afterEach` (reverse-registration order by default) → `onTestFinished` (always reverse order) → `onTestFailed` if failed → `afterAll`.
6. **Reporting** — reporters receive events throughout, produce summaries/coverage.
7. **Global Teardown** — `globalSetup` files' `teardown()` runs once, after everything, in **reverse** order of their setup.

```ts
// globalSetup.ts
export function setup(project) {
  console.log('runs once before all tests')
  project.provide('apiUrl', 'http://localhost:3000')
}
export function teardown() {
  console.log('runs once after all tests')
}
```

### Where to put expensive setup
- **`globalSetup`**: one-time, expensive, whole-run resources (spin up a test server, seed a shared DB) — main process, separate scope.
- **`setupFiles`**: per-test-file, cheaper repeated setup (polyfills, matcher extensions) — same process as tests, can access test context indirectly via hooks registered inside.
- **`beforeAll`**: per-suite-within-a-file expensive setup that doesn't need isolation between tests in that file.
- **`beforeEach`** or a `test.extend` fixture: per-test isolation (default choice unless setup is provably expensive).

### Watch mode differences
On file change: only affected test files rerun, their `setupFiles` rerun, but `globalSetup` does **not** rerun (use `project.onTestsRerun` for rerun-specific logic if needed). Global teardown only fires on process exit, not between reruns.

## Sources

- <https://vitest.dev/config/> (index — links to every option's own page)
- <https://vitest.dev/guide/cli>
- <https://vitest.dev/guide/lifecycle>
- <https://vitest.dev/guide/environment>
- <https://vitest.dev/guide/projects>
- <https://vitest.dev/guide/parallelism>
- <https://vitest.dev/guide/filtering>
- <https://vitest.dev/guide/coverage>
