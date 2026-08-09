# Zustand com SSR / Next.js

## O problema

Uma store criada como singleton de módulo (`export const useStore = create(...)`)
é compartilhada entre **todas** as requisições no servidor. Em SSR isso
vaza estado de um usuário/requisição para outro. A solução é criar a
store **por requisição**, geralmente via uma factory + React Context.

## Padrão: factory + Context

```ts
// store.ts
import { createStore } from 'zustand/vanilla'

export type CounterState = {
  count: number
}

export type CounterActions = {
  decrementCount: () => void
  incrementCount: () => void
}

export type CounterStore = CounterState & CounterActions

export const defaultInitState: CounterState = { count: 0 }

export const createCounterStore = (
  initState: CounterState = defaultInitState,
) => {
  return createStore<CounterStore>()((set) => ({
    ...initState,
    decrementCount: () => set((state) => ({ count: state.count - 1 })),
    incrementCount: () => set((state) => ({ count: state.count + 1 })),
  }))
}
```

```tsx
// provider.tsx
'use client'
import { createContext, useContext, useRef, type ReactNode } from 'react'
import { useStore } from 'zustand'
import { type CounterStore, createCounterStore } from './store'

export type CounterStoreApi = ReturnType<typeof createCounterStore>

const CounterStoreContext = createContext<CounterStoreApi | undefined>(undefined)

export const CounterStoreProvider = ({ children }: { children: ReactNode }) => {
  const storeRef = useRef<CounterStoreApi>()
  if (!storeRef.current) {
    storeRef.current = createCounterStore()
  }
  return (
    <CounterStoreContext.Provider value={storeRef.current}>
      {children}
    </CounterStoreContext.Provider>
  )
}

export const useCounterStore = <T,>(selector: (store: CounterStore) => T): T => {
  const store = useContext(CounterStoreContext)
  if (!store) throw new Error('useCounterStore deve estar dentro de CounterStoreProvider')
  return useStore(store, selector)
}
```

O `useRef` garante que a store só é criada uma vez por instância do
Provider (uma vez por request no server, uma vez por sessão no client).

## Inicializando com props

Para popular a store a partir de dados vindos do servidor (props de um
Server Component, por exemplo), passe um `initState` para a factory:

```tsx
export const CounterStoreProvider = ({
  children,
  initialCount,
}: { children: ReactNode; initialCount: number }) => {
  const storeRef = useRef<CounterStoreApi>()
  if (!storeRef.current) {
    storeRef.current = createCounterStore({ count: initialCount })
  }
  return (
    <CounterStoreContext.Provider value={storeRef.current}>
      {children}
    </CounterStoreContext.Provider>
  )
}
```

## Hidratação com persist (`hasHydrated`)

Ao usar `persist` (localStorage) em Next.js, o servidor não tem acesso ao
localStorage — o HTML gerado no servidor não bate com o estado do
cliente após reidratar, causando mismatch. Padrão comum: manter uma flag
`hasHydrated` e não renderizar o valor persistido até ela ser `true`.

```ts
type State = {
  _hasHydrated: boolean
  setHasHydrated: (state: boolean) => void
  // ...demais campos
}

const useStore = create<State>()(
  persist(
    (set) => ({
      _hasHydrated: false,
      setHasHydrated: (state) => set({ _hasHydrated: state }),
      // ...
    }),
    {
      name: 'app-storage',
      onRehydrateStorage: () => (state) => {
        state?.setHasHydrated(true)
      },
    },
  ),
)
```

No componente, renderize um fallback (ou nada) enquanto
`_hasHydrated` for `false`, e só então mostre o valor real.
