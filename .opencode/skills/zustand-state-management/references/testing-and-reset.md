# Reset de estado e testes

## Resetando a store para o estado inicial

Guarde uma cópia do estado inicial fora do `create`, e crie uma action
`reset` que usa a forma de dois argumentos de `set` — o segundo `true`
substitui o estado inteiro em vez de fazer merge:

```ts
import { create } from 'zustand'

type State = {
  salmon: number
  tuna: number
}

type Actions = {
  addSalmon: (qty: number) => void
  addTuna: (qty: number) => void
  reset: () => void
}

const initialState: State = { salmon: 0, tuna: 0 }

const useSlice = create<State & Actions>()((set) => ({
  ...initialState,
  addSalmon: (qty) => set((state) => ({ salmon: state.salmon + qty })),
  addTuna: (qty) => set((state) => ({ tuna: state.tuna + qty })),
  reset: () => set(initialState, true), // true = substitui, não mescla
}))
```

Para resetar **múltiplas** stores de uma vez (ex: ao fazer logout), crie
um registro de todas as stores resetáveis e itere chamando `reset()` em
cada uma.

## Testando a store isoladamente

Não é necessário renderizar componentes para testar lógica da store —
acesse diretamente via `getState()`/`setState()`:

```ts
import { useBearStore } from './bearStore'

beforeEach(() => {
  useBearStore.setState(useBearStore.getInitialState())
})

test('increasePopulation incrementa bears', () => {
  useBearStore.getState().increasePopulation()
  expect(useBearStore.getState().bears).toBe(1)
})
```

`getInitialState()` (Zustand v4.5+) devolve o estado tal como definido na
criação da store, útil para resetar entre testes sem duplicar o objeto
inicial manualmente.

## Testando componentes que consomem a store

Normalmente não é preciso mockar a store — use-a de verdade com Testing
Library, e resete o estado entre testes:

```tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { useBearStore } from './bearStore'
import { BearCounter, Controls } from './Bear'

beforeEach(() => {
  useBearStore.setState(useBearStore.getInitialState())
})

test('incrementa ao clicar', () => {
  render(<><BearCounter /><Controls /></>)
  fireEvent.click(screen.getByRole('button'))
  expect(screen.getByText(/1 ursos/)).toBeInTheDocument()
})
```

Mock a store apenas quando o componente depender de uma parte cara/externa
(ex: fetch dentro de uma action) — nesse caso, mocke o `fetch`, não a
store inteira.
