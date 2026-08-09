# Middlewares do Zustand

Middlewares envolvem a função criadora da store para adicionar
comportamento (persistência, devtools, logs, etc). Em stores com slices,
aplique middlewares **apenas na store combinada final**, nunca dentro de
um slice individual.

## persist — salvar em storage

```ts
import { create } from 'zustand'
import { persist, createJSONStorage } from 'zustand/middleware'

const useStore = create(
  persist(
    (set, get) => ({
      fishes: 0,
      addAFish: () => set({ fishes: get().fishes + 1 }),
    }),
    {
      name: 'food-storage', // chave única no storage — obrigatório
      storage: createJSONStorage(() => sessionStorage), // padrão: localStorage
    },
  ),
)
```

Combinado com slices:

```ts
export const useBoundStore = create(
  persist(
    (...a) => ({
      ...createBearSlice(...a),
      ...createFishSlice(...a),
    }),
    { name: 'bound-store' },
  ),
)
```

Opções úteis: `partialize` (persistir só parte do estado), `version` +
`migrate` (migração de schema entre versões), `onRehydrateStorage`
(callback pós-hidratação — importante em Next.js, ver `nextjs-ssr.md`).

## devtools — Redux DevTools

```ts
import { devtools } from 'zustand/middleware'

const useStore = create(
  devtools((set) => ({
    bears: 0,
    increase: () => set((state) => ({ bears: state.bears + 1 })),
  })),
)
```

Dá nomes de action legíveis passando um segundo argumento em `set`:

```ts
increase: () =>
  set((state) => ({ bears: state.bears + 1 }), false, 'bear/increase'),
```

## subscribeWithSelector

Permite `store.subscribe(selector, callback)` — reagir a mudanças de um
campo específico fora de componentes React:

```ts
import { subscribeWithSelector } from 'zustand/middleware'

const useStore = create(
  subscribeWithSelector((set) => ({ paw: true, snout: true, fur: true })),
)

useStore.subscribe(
  (state) => state.paw,
  (paw, previousPaw) => console.log(paw, previousPaw),
)
```

## combine

Infere o tipo do estado inicial automaticamente, evitando anotar `State`
manualmente (útil em stores pequenas/JS):

```ts
import { combine } from 'zustand/middleware'

const useStore = create(
  combine({ bears: 0 }, (set) => ({
    increase: () => set((state) => ({ bears: state.bears + 1 })),
  })),
)
```

## Middleware customizado

Um middleware é uma função que recebe o criador da store (`f`) e retorna
outro criador. Exemplo simples de logger:

```ts
const logger = (f, name) => (set, get, store) => {
  const loggedSet = (...args) => {
    set(...args)
    console.log(`[${name}]`, get())
  }
  return f(loggedSet, get, store)
}

const useStore = create(logger((set) => ({ bears: 0 }), 'bearStore'))
```

## Ordem de composição

Middlewares se aninham como funções — a ordem importa. Um padrão comum e
seguro:

```ts
create(devtools(persist(immer(storeCreator), { name: '...' })))
```
