---
name: vitest-testing
description: Use this skill whenever writing, editing, running, or debugging tests with Vitest (files matching *.test.ts, *.spec.ts, *.test.js, etc., or any project with "vitest" in package.json/devDependencies). Covers writing tests (test/it, describe, matchers), async testing, setup/teardown hooks and fixtures, mocking (vi.fn, vi.spyOn, vi.mock), snapshots, config (vitest.config.ts), CLI usage, and — critically — diagnosing test failures and common errors (wrong environment, leaked mocks, unhandled rejections, stale snapshots, shared state between tests). Trigger this proactively any time the user asks to "write a test", "fix this failing test", "why is this test failing", "mock this function/module", or mentions Vitest, vi.fn, vi.mock, toMatchSnapshot, or similar Vitest-specific APIs.
---

# Vitest Testing

Vitest is a Vite-native test framework with a Jest-compatible API (`describe`, `test`/`it`, `expect`, and a `vi` object instead of `jest`). This skill gives you the core mental model plus fast paths to deeper references when needed.

## Core mental model

- Import from `vitest`: `import { describe, test, expect, vi, beforeEach } from 'vitest'` (unless the project has `test.globals: true` in config, in which case no import is needed).
- `test` and `it` are identical aliases. `describe` groups tests into named suites.
- Test files match `**/*.{test,spec}.{ts,js,mjs,cjs,tsx,jsx}` by default, anywhere in the tree.
- Default environment is `node`. Browser-like globals (`window`, `document`) require `environment: 'jsdom'` or `'happy-dom'` in config, or Browser Mode.
- Files run in parallel (isolated processes); tests **within** one file run sequentially by default unless marked `.concurrent`.
- Default timeouts: 5s per test (`testTimeout`), 10s per hook (`hookTimeout`).

## Writing a test — minimal shape

```js
import { describe, expect, test } from 'vitest'
import { formatPrice } from './formatPrice.js'

describe('formatPrice', () => {
  test('formats USD prices', () => {
    expect(formatPrice(10, 'USD')).toBe('$10.00')
  })
})
```

Always ask: does this test verify *behavior* (inputs → outputs/errors), not implementation details? If a refactor that preserves output would break the test, it's testing the wrong thing. See `references/patterns.md` for structuring tests, edge cases, and a full worked example.

## Matchers cheat sheet

| Need | Matcher |
|---|---|
| Exact primitive equality | `toBe` |
| Deep object/array equality | `toEqual` |
| Deep equality + type/undefined strictness | `toStrictEqual` |
| Truthy/falsy/null/undefined | `toBeTruthy`/`toBeFalsy`/`toBeNull`/`toBeDefined` |
| Numbers, ranges | `toBeGreaterThan`, `toBeCloseTo` (floats!) |
| String against regex | `toMatch` |
| Array/Set contains item | `toContain` |
| Array contains object | `toContainEqual` |
| Object has subset of fields | `toMatchObject` |
| Nested property (dot path) | `toHaveProperty('a.b', val)` |
| Function throws | `toThrow` — **must wrap**: `expect(() => fn()).toThrow()` |
| Promise resolves/rejects | `await expect(p).resolves.toBe(x)` / `.rejects.toThrow()` |
| Unknown shape/type | `expect.any(Ctor)`, `expect.stringContaining`, `expect.objectContaining` |

Full detail and gotchas (e.g. `toBeCloseTo` for floats, soft assertions with `expect.soft`) in `references/matchers-and-async.md`.

## Async testing — key rules

- Prefer `async`/`await` test functions over returning promises manually.
- Never forget `await` before `expect(promise).resolves/.rejects` — an unawaited assertion can make a test falsely pass.
- Use `expect.hasAssertions()` / `expect.assertions(n)` when assertions live inside callbacks/loops that might not run.
- Unhandled promise rejections **fail the test run** by default — this is intentional; find and await/catch the offending promise.

Details in `references/matchers-and-async.md`.

## Setup/teardown & fixtures

- `beforeEach`/`afterEach`: run per test. `beforeAll`/`afterAll`: run once per file/suite (use for expensive setup like DB connections).
- Hooks inside `describe` are scoped to that suite; top-level hooks apply file-wide.
- Prefer `test.extend()` fixtures over `let` + `beforeEach` for reusable, auto-cleaned-up state — see `references/setup-and-mocking.md`.
- `onTestFinished(fn)` registers cleanup right where a resource is created (runs even if a later assertion fails) — more robust than remembering `afterEach`.

## Mocking — key rules

- `vi.fn()` creates a bare mock; `vi.spyOn(obj, 'method')` wraps an *existing* method (keeps real behavior unless you override it).
- Control output: `mockReturnValue`, `mockResolvedValue`/`mockRejectedValue` (async), `mockImplementation`.
- Inspect calls: `toHaveBeenCalledWith(...)`, `.mock.calls`, `.mock.results`.
- **Always clean up mocks between tests** — set `restoreMocks: true` in config (best default) or call `vi.restoreAllMocks()` in `afterEach`. Leaked mocks are one of the most common sources of flaky/confusing failures.
- Module mocking: `vi.mock(import('./db.js'), () => ({ ... }))` — prefer the `import()` form over a bare string for type-safety and hoisting correctness. `vi.mock` calls are hoisted above imports.
- Only mock what's slow/flaky/non-deterministic (network, fs, DB, time, random). Don't mock the unit under test itself.

Full patterns (timers, dates, globals, modules, classes) in `references/setup-and-mocking.md`.

## Snapshots — when to use

Use `toMatchSnapshot()` / `toMatchInlineSnapshot()` for large structured output you want to protect against *any* unintended change (rendered HTML, complex config objects, formatted error messages). Don't use snapshots for output with timestamps/random IDs unless you pin those fields with `expect.any(...)` matchers passed into the snapshot call. Update deliberately with `vitest -u`, always reviewing the diff first. Details in `references/matchers-and-async.md`.

## Running tests (CLI)

```bash
vitest                 # watch mode (default in dev)
vitest run              # run once and exit — USE THIS for CI / agent / scripted runs
vitest run path/to/file.test.ts
vitest -t "test name pattern"
vitest run -u            # update snapshots
vitest --reporter=verbose
vitest --ui               # visual dashboard (needs @vitest/ui)
vitest --inspect-brk --no-file-parallelism   # attach a debugger
```

**Critical for agent/automated use**: Vitest defaults to watch mode and will not exit. Always use `vitest run` (or `vitest --no-watch`) when running tests programmatically, so the process actually terminates.

## When a test fails — diagnostic checklist

Read `references/debugging-and-errors.md` before guessing. Quick triage order:

1. **Read the diff carefully.** Vitest shows expected vs. received plus a code snippet with a caret at the failing line — the header (`file > describe > test`) tells you exactly where.
2. **Isolate it**: `vitest run path/to/file.test.ts -t "test name"` or add `.only`. If it passes alone but fails with the suite, it's a **shared-state/isolation bug**, not a logic bug.
3. **Check the common-cause list** in `references/debugging-and-errors.md`: shared module-level state, missing `await`, stale snapshots, wrong test environment (`document is not defined`), leaked mocks (add `restoreMocks: true`).
4. **Still stuck?** Check `references/debugging-and-errors.md`'s pointers to `Common Errors` docs and Vitest UI/`--inspect-brk` for deep debugging.

## Config essentials

Config lives under `test:` in `vitest.config.ts` (or reuses `vite.config.ts`). Most commonly touched options: `environment`, `globals`, `setupFiles`, `include`/`exclude`, `testTimeout`, `restoreMocks`, `coverage`. Full option index and how project/browser config works in `references/config-and-cli.md`.

## Browser Mode (component testing)

For testing real DOM/CSS/component behavior (React/Vue/Svelte/etc.) in an actual browser instead of jsdom simulation, use Browser Mode. It's a different testing style (`page`, `userEvent`, `expect.element(...).toBeInTheDocument()`) — read `references/browser-mode.md` before writing browser tests, don't guess the API from jsdom habits.

## Writing tests with / for AI agents

If you (the agent) are asked to generate tests, or the user is reviewing AI-written tests: avoid the two classic failure modes — (1) using Jest APIs (`jest.fn`, `jest.mock`) instead of `vi.fn`/`vi.mock`, and (2) generating shallow tests that only assert `toBeDefined()`. See `references/patterns.md` for the full checklist on writing meaningful, behavior-focused tests and reviewing generated ones.

## Reference index

- `references/patterns.md` — test structure (Arrange/Act/Assert), what to test, edge cases, file organization, a full worked example, and AI-generated-test review checklist.
- `references/matchers-and-async.md` — complete matcher list with gotchas, async patterns, assertion counting, snapshot details (inline vs file vs dynamic values).
- `references/setup-and-mocking.md` — hooks execution order, `test.extend` fixtures, all `vi.*` mocking APIs, module/timer/date mocking, mock cleanup strategies.
- `references/debugging-and-errors.md` — reading failure output, isolating failures, the full common-causes list, debugging tools (console, UI, VS Code, `--inspect-brk`), and where to look for specific error messages.
- `references/config-and-cli.md` — config file setup, key options reference, full CLI flag list, test lifecycle phases (setup/global-setup/teardown order).
- `references/browser-mode.md` — Browser Mode setup, `page`/`userEvent`/`expect.element` API, component-testing patterns and best practices, framework render helpers (React/Vue/Svelte).

## Official documentation

This skill is a distillation of the official Vitest docs (v4.1.10). Each `references/*.md` file ends with a "Sources" list linking the exact pages it was built from — open those directly for anything not covered here or if something looks outdated. Starting points:

- Guide index: <https://vitest.dev/guide/>
- Full config reference: <https://vitest.dev/config/>
- Full API reference: <https://vitest.dev/api/test>
- Common Errors page: <https://vitest.dev/guide/common-errors>
- GitHub issues (known bugs/workarounds): <https://github.com/vitest-dev/vitest/issues>
- Discord community: <https://chat.vitest.dev>

Tip: most docs pages also expose an LLM-optimized `.md` version at the same path (e.g. `https://vitest.dev/guide/learn/writing-tests.md`) — fetch that instead of the HTML page when reading directly.
