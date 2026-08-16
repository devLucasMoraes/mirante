# Test Patterns & Practice

## What to test: the contract

Think of a function's **contract**: given its inputs (args, config), what outputs (return values, side effects, errors) does it promise? Test the contract, not the internals.

```js
export function formatPrice(amount, currency) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(amount)
}
```

```js
test('formats USD prices', () => {
  expect(formatPrice(10, 'USD')).toBe('$10.00')
})
test('handles negative amounts', () => {
  expect(formatPrice(-5.5, 'USD')).toBe('-$5.50')
})
```

**Rule of thumb**: if someone refactors the internals but the output stays the same, would the test break? If yes, you're testing implementation details, not behavior. Don't assert on which internal helper was called unless that call *is* the contract (e.g. verifying you called an external API correctly).

## Structuring a test: Arrange / Act / Assert

```js
test('removes an item from the list', () => {
  // Arrange
  const list = new ShoppingList()
  list.add('milk')
  list.add('bread')

  // Act
  list.remove('milk')

  // Assert
  expect(list.getItems()).toEqual(['bread'])
})
```

No comments needed once it's habitual. Keep each test focused on **one behavior** — if the test name needs "and" ("formats price and logs the result"), split it.

### Descriptive names

Names should describe behavior, not implementation, so a failure is self-explanatory from the test name alone:
- Good: `"returns 0 for an empty cart"`, `"throws if the email format is invalid"`
- Bad: `"calls Intl.NumberFormat with correct options"`, `"works correctly"`

## Testing edge cases

After the happy path, test boundaries: zero, negative, min/max, empty string/array, `null`/`undefined`, and error paths.

```js
export function parseAge(input) {
  const age = Number(input)
  if (Number.isNaN(age) || age < 0 || age > 150) {
    throw new Error(`Invalid age: ${input}`)
  }
  return Math.floor(age)
}
```

```js
test('handles the upper boundary', () => {
  expect(parseAge('150')).toBe(150)
})
test('throws for numbers above 150', () => {
  expect(() => parseAge('151')).toThrow('Invalid age: 151')
})
test('throws for non-numeric strings', () => {
  expect(() => parseAge('abc')).toThrow('Invalid age: abc')
})
```

Ask: *could a real caller trigger this input?* If yes, test it. You don't need to test every conceivable input — just the boundaries and realistic error paths.

For functions with a very wide input space, consider **property-based testing** with [fast-check](https://fast-check.dev/) — describe properties that must hold for any input and let the tool search for counterexamples. Advanced technique, worth knowing about but not needed for most tests.

## When to mock (and when not to)

**Mock**: slow dependencies (network, filesystem, DB), non-deterministic values (current time via `vi.useFakeTimers()`/`vi.setSystemTime()`, random IDs).

**Don't mock**: the unit under test itself (if testing `UserService`, don't mock `UserService` — mock its *dependencies*), or anything fast/pure/deterministic (in-memory data structures, pure functions). The closer to real usage, the more confidence the test gives you.

For HTTP specifically, prefer [Mock Service Worker (MSW)](https://mswjs.io/) over mocking `fetch` directly — it intercepts at the network layer and works the same in Node and browser tests.

## Fixing bugs with tests

When you find a bug: write a **failing test that reproduces it first**, confirm it fails, then fix the code and watch it turn green. This proves the bug was real, documents what broke, and becomes a permanent regression test.

```js
// bug report: parseAge crashes on " 25" (leading space)
test('handles leading spaces', () => {
  expect(parseAge(' 25')).toBe(25)
})
// run → confirm it fails → fix with input.trim() → run again → passes
```

If an agent is asked to fix a bug, it should follow this same principle rather than "fixing" the bug by editing the test to match broken output.

## Organizing test files

- Default: one test file next to its source (`utils.js` / `utils.test.js`), or a dedicated `__tests__/` directory — either works, Vitest's default `include` glob matches both. Consistency within a project matters more than which convention.
- Group with `describe` per exported function/method; avoid nesting `describe` more than 1–2 levels deep (a sign the source module does too much).
- Split test files that grow past a few hundred lines by feature/theme (`userService.creation.test.js`, `userService.auth.test.js`).

## Full worked example

```js
// todoList.js
let nextId = 1
export function createTodoList() {
  const items = []
  return {
    add(text) {
      if (!text.trim()) throw new Error('Todo text cannot be empty')
      const todo = { id: nextId++, text, completed: false }
      items.push(todo)
      return todo
    },
    remove(id) {
      const index = items.findIndex(item => item.id === id)
      if (index === -1) throw new Error(`Todo with id ${id} not found`)
      items.splice(index, 1)
    },
    toggle(id) { /* ... */ },
    getAll() { return items },
    getCompleted() { return items.filter(i => i.completed) },
  }
}
```

```js
// todoList.test.js
import { describe, expect, test } from 'vitest'
import { createTodoList } from './todoList.js'

describe('add', () => {
  test('adds a new todo', () => {
    const list = createTodoList()
    const todo = list.add('Buy groceries')
    expect(todo.text).toBe('Buy groceries')
    expect(todo.completed).toBe(false)
    expect(list.getAll()).toHaveLength(1)
  })

  test('throws when text is empty', () => {
    const list = createTodoList()
    expect(() => list.add('')).toThrow('Todo text cannot be empty')
  })
})

describe('remove', () => {
  test('removes a todo by ID', () => {
    const list = createTodoList()
    const todo = list.add('Buy groceries')
    list.remove(todo.id)
    expect(list.getAll()).toHaveLength(0)
  })

  test('throws when ID does not exist', () => {
    const list = createTodoList()
    expect(() => list.remove(999)).toThrow('Todo with id 999 not found')
  })
})
```

Note: create a **fresh** `createTodoList()` in every test — keeps tests independent so order doesn't matter. If setup repeats across tests, that's a signal to use `beforeEach` or a `test.extend` fixture (see `setup-and-mocking.md`). Watch out for module-level shared state (like `nextId` here) — tests should only assert on *relative* properties of such state (`first.id !== second.id`), never an absolute value, since execution order isn't guaranteed.

---

## Reviewing AI-generated tests (or writing tests as an agent)

AI-generated Vitest tests commonly have these problems — check for them before considering a test suite done:

### 1. Assertions that don't actually verify anything
```js
// ❌ Weak — passes for almost any return value
test('creates a user', () => {
  const user = createUser('Alice', 'alice@example.com')
  expect(user).toBeDefined()
})

// ✅ Strong — checks actual contract
test('creates a user with the correct fields', () => {
  const user = createUser('Alice', 'alice@example.com')
  expect(user).toMatchObject({ name: 'Alice', email: 'alice@example.com' })
  expect(user.id).toBeTypeOf('string')
})
```

### 2. Over-mocking / testing implementation, not behavior
If every dependency is mocked and the test asserts specific internal call order, it will break on any refactor even if behavior is unchanged. Ask: would this test survive a correctness-preserving refactor? If not, rewrite to assert on outputs/errors only.

### 3. Wrong API surface (Jest muscle memory)
Because most training data is Jest, agents often emit `jest.fn()` / `jest.mock()` instead of `vi.fn()` / `vi.mock()` — these fail immediately in Vitest. Always use the `vi` object. Also prefer `vi.mock(import('./x.js'), ...)` over the bare-string form.

### 4. Tests that were never actually run
Always execute `vitest run path/to/file.test.ts` after generating tests — import errors, nonexistent functions, and incorrect matcher usage are common and only surface at run time.

### 5. Happy-path-only coverage
Generated tests often skip empty input, `null`/`undefined`, network failure, and empty-list cases. Explicitly add these if missing (see "Testing edge cases" above).

### 6. Verbose test names
Prefer `"formats USD prices"` over `"should correctly return the formatted price string when given a valid positive number and a supported currency code"`. Short, scannable names.

### Prompting tips (if generating tests from a spec/description)
- Name the specific function/scenarios to cover rather than "write tests for X.js".
- State explicitly if code is async ("returns a Promise") so `async`/`await` and `.resolves`/`.rejects` get used correctly.
- State what *not* to do: "don't mock any modules, test against the real implementation" prevents unwanted over-mocking.
- Reference an existing test file's style ("follow the same conventions as auth.test.js") for consistent structure.
- Always run with `vitest run` (not the default watch mode) so the process exits — critical when tests are run non-interactively.

## Sources

- <https://vitest.dev/guide/learn/testing-in-practice>
- <https://vitest.dev/guide/learn/writing-tests-with-ai>
