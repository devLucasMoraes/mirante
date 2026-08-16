# Browser Mode & Component Testing

Browser Mode runs tests in a **real browser** (via Playwright, WebdriverIO, or a lightweight `preview` provider) instead of simulating one with jsdom/happy-dom. It provides real DOM/CSS rendering, real browser API behavior, and real event handling — catches issues jsdom simulation can miss. Trade-offs: slower init, still maturing (per official docs), recommended to pair with Playwright/WebdriverIO for CI reliability rather than the `preview` provider.

Use Browser Mode (not jsdom `environment`) when testing actual UI components (React/Vue/Svelte/etc.) where CSS layout, focus management, or precise event semantics matter.

## Setup

```bash
npx vitest init browser    # scaffolds config + installs deps
```

Manual config (Playwright, recommended over WebdriverIO for parallelism):
```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import { playwright } from '@vitest/browser-playwright'

export default defineConfig({
  test: {
    browser: {
      provider: playwright(),
      enabled: true,
      instances: [{ browser: 'chromium' }],  // firefox, webkit also supported
    },
  },
})
```

If you need **both** Node-based unit tests and browser component tests in one project, use `projects` to split them by `include` glob rather than forcing everything through one config:
```ts
export default defineConfig({
  test: {
    projects: [
      { test: { include: ['tests/unit/**/*.test.ts'], name: 'unit', environment: 'node' } },
      { test: { include: ['tests/browser/**/*.test.ts'], name: 'browser', browser: { enabled: true, provider: playwright(), instances: [{ browser: 'chromium' }] } } },
    ],
  },
})
```

Headless mode for CI: `browser: { headless: true }` or `--browser.headless` flag (requires Playwright/WebdriverIO, not available with `preview`).

## Core API (framework-agnostic)

```js
import { expect, test } from 'vitest'
import { page } from 'vitest/browser'
import { render } from './my-render-function.js'

test('properly handles form inputs', async () => {
  render()
  await expect.element(page.getByText('Hi, my name is Alice')).toBeInTheDocument()

  const usernameInput = page.getByLabelText(/username/i)
  await usernameInput.fill('Bob')   // fills AND validates the fill succeeded

  await expect.element(page.getByText('Hi, my name is Bob')).toBeInTheDocument()
})
```

- `page.getByRole`, `page.getByText`, `page.getByLabelText`, `page.getByTestId`, etc. — same query philosophy as Testing Library.
- `await expect.element(locator).toBeInTheDocument()` — **must `await`**, auto-retries until found (or times out with a helpful error) — this is the standard "wait for X to appear" pattern, don't reach for manual polling.
- `userEvent` (from `vitest/browser`) for interactions: `userEvent.fill(...)`, `userEvent.keyboard('{Tab}')`, etc. — or the shorthand `locator.fill(...)`/`locator.click()`.
- **Don't** use `@testing-library/user-event` directly — it simulates events; Vitest's own `userEvent` actually drives the real browser via CDP/WebDriver.

## Framework render helpers

Official packages exist for popular frameworks — install and use instead of raw DOM manipulation:
- `vitest-browser-react`, `vitest-browser-vue`, `vitest-browser-svelte`, `vitest-browser-angular` (community)
- Community: `vitest-browser-lit`, `vitest-browser-preact`, `vitest-browser-qwik`

```tsx
// React example
import { render } from 'vitest-browser-react'
import Fetch from './fetch'

test('loads and displays greeting', async () => {
  const screen = render(<Fetch url="/greeting" />)
  await screen.getByText('Load Greeting').click()
  const heading = screen.getByRole('heading')
  await expect.element(heading).toHaveTextContent('hello there')
})
```

For unsupported frameworks (Solid, Marko), use their `@testing-library/*` packages and bridge with `page.elementLocator(baseElement)` to get access to Vitest's query/assertion API on Testing-Library-rendered output.

## Component testing patterns

### Isolation vs. integration
- **Isolate**: mock child components/API calls to test one component's logic in isolation.
- **Integration**: render the real component tree, verify data flow and collaboration between components (e.g. parent passes correct filtered data to child).

### Mocking API calls in browser tests
Prefer **MSW (Mock Service Worker)** over manually mocking `fetch` — it intercepts at the network layer, works identically for Node and browser tests:
```js
import { http, HttpResponse } from 'msw'
import { setupWorker } from 'msw/browser'

const worker = setupWorker(
  http.get('/api/users/:id', ({ params }) =>
    HttpResponse.json({ id: params.id, name: 'John Doe' }))
)
beforeAll(() => worker.start())
afterEach(() => worker.resetHandlers())
afterAll(() => worker.stop())
```

### Testing accessibility
```tsx
const modal = getByRole('dialog')
await expect.element(modal).toHaveFocus()               // focus management on open
await expect.element(modal).toHaveAttribute('aria-modal', 'true')
await userEvent.keyboard('{Escape}')
await expect.element(modal).not.toBeInTheDocument()      // closes on Escape
```

## Limitations to know before writing browser tests

### Blocking dialogs
`alert()`/`confirm()` block the page thread, which would hang Vitest's communication with it — Vitest auto-mocks these with default return values so execution doesn't hang, but you should mock them explicitly for real assertions.

### Can't `vi.spyOn` a module's named export
Browser Mode serves real ESM with a sealed module namespace (can't be reconfigured), unlike Node tests where Vitest patches the module runner:
```ts
import * as module from './module.js'
vi.spyOn(module, 'method')  // ❌ throws in Browser Mode
```
Fix: use `vi.mock('./module.js', { spy: true })` to auto-spy every export without replacing them. To mock an exported *variable* specifically, export a setter function instead (`export function changeMode(newMode) { MODE = newMode }`) — direct reassignment of a live binding from outside the module isn't possible.

## Debugging browser/component tests

- Real DevTools work — open with F12 during test run, or set `headless: false` temporarily to watch it run.
- `vitest --ui` gives a visual dashboard of browser test runs too.
- If a query fails, try alternate query strategies (`getByRole` → `getByTestId` → `getByText`) chained with `.or(...)` for auto-retrying fallback, and log `page.getByRole('button').all()` to see what's actually in the DOM.
- Common migration gotcha from Jest+Testing Library: use `await expect.element(x)` instead of bare `expect(x)` for DOM assertions, and `vitest/browser`'s `userEvent` instead of `@testing-library/user-event`.

## Sources

- <https://vitest.dev/guide/browser/why>
- <https://vitest.dev/guide/browser/>
- <https://vitest.dev/guide/browser/component-testing>
- <https://vitest.dev/guide/browser/multiple-setups>
- <https://vitest.dev/guide/browser/visual-regression-testing>
- <https://vitest.dev/guide/browser/aria-snapshots>
- <https://vitest.dev/api/browser/context> (Context API)
- <https://vitest.dev/api/browser/interactivity> (userEvent)
- <https://vitest.dev/api/browser/locators> (page.getBy* query API)
- <https://vitest.dev/api/browser/assertions> (expect.element matchers)
- <https://vitest.dev/api/browser/react> / <https://vitest.dev/api/browser/vue> / <https://vitest.dev/api/browser/svelte>
- <https://github.com/vitest-tests/browser-examples>
