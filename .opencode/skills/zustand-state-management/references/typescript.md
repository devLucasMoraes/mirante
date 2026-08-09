# Zustand + TypeScript avançado

## Regra básica

Sempre use `create<T>()(...)` — parênteses duplos (curry). O primeiro
`<T>()` é uma função "identidade" que só existe para o TypeScript inferir
corretamente os tipos ao empilhar middlewares.

```ts
interface BearState {
  bears: number
  increase: (by: number) => void
}

const useBearStore = create<BearState>()((set) => ({
  bears: 0,
  increase: (by) => set((state) => ({ bears: state.bears + by })),
}))
```

Sem os parênteses duplos (`create<BearState>(...)`), tipos de middlewares
como `persist` ou `devtools` não se propagam corretamente.

## Separe interface de State e de Actions

Ajuda legibilidade e reuso:

```ts
type State = {
  firstName: string
  lastName: string
}

type Actions = {
  updateFirstName: (firstName: State['firstName']) => void
  updateLastName: (lastName: State['lastName']) => void
}

const usePersonStore = create<State & Actions>()((set) => ({
  firstName: '',
  lastName: '',
  updateFirstName: (firstName) => set(() => ({ firstName })),
  updateLastName: (lastName) => set(() => ({ lastName })),
}))
```

## Slices tipados

Cada slice usa `StateCreator` com os 4 parâmetros de tipo:

1. Tipo do estado completo combinado
2. Array de mutators de middleware (vazio `[]` se não houver)
3. Array de mutators adicionais (vazio `[]`)
4. A interface específica que este slice implementa (retorno)

```ts
import { StateCreator } from 'zustand'

interface BearSlice {
  bears: number
  addBear: () => void
}

interface FishSlice {
  fishes: number
  addFish: () => void
}

const createBearSlice: StateCreator<
  BearSlice & FishSlice,
  [],
  [],
  BearSlice
> = (set) => ({
  bears: 0,
  addBear: () => set((state) => ({ bears: state.bears + 1 })),
})

const createFishSlice: StateCreator<
  BearSlice & FishSlice,
  [],
  [],
  FishSlice
> = (set) => ({
  fishes: 0,
  addFish: () => set((state) => ({ fishes: state.fishes + 1 })),
})

export const useBoundStore = create<BearSlice & FishSlice>()((...a) => ({
  ...createBearSlice(...a),
  ...createFishSlice(...a),
}))
```

Com muitos slices (15-20+), considere um arquivo central que só faz o
merge de tipos (`type Store = SliceA & SliceB & ...`) para não repetir a
união em cada slice.

## Slices + middleware

Quando a store combinada usa middleware (ex: `persist`, `immer`), o
segundo parâmetro de tipo do `StateCreator` de cada slice precisa listar
os mutators daquele middleware, por exemplo `['zustand/immer', never]`
para Immer. Isso garante que `set` dentro do slice tenha a assinatura
correta (ex: aceitando uma função "recipe" do Immer).

## Auto-gerando seletores

Para evitar escrever `useStore((state) => state.campo)` toda vez, é
possível gerar automaticamente um objeto de seletores tipados a partir da
store — útil em stores grandes. Ver a página oficial "Auto Generating
Selectors" em https://zustand.docs.pmnd.rs/learn/guides/auto-generating-selectors
para o helper `createSelectors`.
