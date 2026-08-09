---
name: zustand-state-management
description: Criar, revisar ou refatorar stores Zustand em projetos React/TypeScript — criação de store, atualização de estado, padrão de slices, seletores com useShallow, middlewares (persist, devtools, immer) e SSR/Next.js. Use sempre que o usuário mencionar Zustand, "store", "gerenciamento de estado global" em React, ou arquivos como useXStore.ts / store.ts.
license: MIT
compatibility: opencode
metadata:
  source: https://zustand.docs.pmnd.rs/learn/index
  language: pt-BR
---

# Zustand — gerenciamento de estado para React

Zustand é uma biblioteca pequena, rápida e não opinativa de gerenciamento de
estado para React, baseada em hooks. Não exige Provider, não tem boilerplate
de Redux, e o `set` faz merge raso (shallow merge) do estado por padrão.

Este skill cobre o fluxo do dia a dia. Para tópicos avançados, carregue os
arquivos em `references/` conforme a tarefa (indicado em cada seção abaixo).

## Quando usar este skill

- Criar uma nova store Zustand (JS ou TypeScript)
- Adicionar/editar actions que atualizam estado
- Dividir uma store grande em slices
- Corrigir re-renders desnecessários em componentes que consomem a store
- Adicionar persistência (localStorage/sessionStorage), devtools, ou Immer
- Configurar Zustand em apps Next.js (SSR/hidratação)
- Escrever testes para stores e componentes que as consomem

## Instalação

```bash
pnpm add zustand
```

## 1. Criar a primeira store

A store é um hook. Pode conter primitivos, objetos e funções. `set` faz
merge raso com o estado existente — não é preciso espalhar (`...state`)
campos de nível superior que não mudam.

```ts
import { create } from 'zustand'

type State = {
  bears: number
}

type Actions = {
  increasePopulation: () => void
  removeAllBears: () => void
  updateBears: (newBears: number) => void
}

const useBearStore = create<State & Actions>()((set) => ({
  bears: 0,
  increasePopulation: () => set((state) => ({ bears: state.bears + 1 })),
  removeAllBears: () => set({ bears: 0 }),
  updateBears: (newBears) => set({ bears: newBears }),
}))
```

**Regra de ouro em TypeScript**: use `create<T>()(...)` com parênteses
duplos. Um único par de parênteses (`create<T>(...)`) quebra a inferência de
tipos ao combinar com middlewares. Veja `references/typescript.md` para
padrões avançados (slices tipados, stacks de middleware).

## 2. Consumir a store em componentes

Sem Provider. Selecione apenas o pedaço de estado que o componente precisa
— isso é o que evita re-renders desnecessários, porque o componente só
re-renderiza quando o valor selecionado muda.

```tsx
function BearCounter() {
  const bears = useBearStore((state) => state.bears)
  return <h1>{bears} ursos por aqui...</h1>
}

function Controls() {
  const increasePopulation = useBearStore((state) => state.increasePopulation)
  return <button onClick={increasePopulation}>+1</button>
}
```

Evite `const state = useBearStore()` sem seletor — isso re-renderiza o
componente em qualquer mudança da store.

## 3. Atualizando estado

`set` faz merge raso. Para estado aninhado, ver `references/updating-nested-state.md`
(spread manual, Immer, optics-ts, Ramda).

```ts
updateFirstName: (firstName) => set(() => ({ firstName })),
```

Actions assíncronas funcionam normalmente — Zustand não se importa se a
action é async:

```ts
fetchUsers: async () => {
  set({ loading: true, error: null })
  try {
    const res = await fetch('/api/users')
    set({ users: await res.json(), loading: false })
  } catch (e) {
    set({ error: String(e), loading: false })
  }
},
```

## 4. Evitando re-renders (useShallow)

Ao selecionar **múltiplos** valores ou um objeto/array computado, use
`useShallow` para comparar por igualdade rasa em vez de referência —
senão o componente re-renderiza a cada mudança de estado, mesmo que o
valor selecionado seja "igual".

```tsx
import { useShallow } from 'zustand/react/shallow'

const { bears, fishes } = useBearStore(
  useShallow((state) => ({ bears: state.bears, fishes: state.fishes })),
)
```

Selecionar um único primitivo (`state.bears`) **não** precisa de
`useShallow` — a comparação padrão (`Object.is`) já resolve.

## 5. Padrão de slices (stores grandes)

Divida a store em "fatias" por domínio, cada uma sua própria função
criadora, e combine tudo com spread. Cada slice tem acesso ao estado
combinado (merged), então pode referenciar campos de outros slices.

```ts
// bearSlice.ts
export const createBearSlice = (set) => ({
  bears: 0,
  addBear: () => set((state) => ({ bears: state.bears + 1 })),
})

// fishSlice.ts
export const createFishSlice = (set) => ({
  fishes: 0,
  addFish: () => set((state) => ({ fishes: state.fishes + 1 })),
})

// useBoundStore.ts
import { create } from 'zustand'
export const useBoundStore = create((...a) => ({
  ...createBearSlice(...a),
  ...createFishSlice(...a),
}))
```

Para uma action que mexe em múltiplos slices, use `get()`:

```ts
export const createBearFishSlice = (set, get) => ({
  addBearAndFish: () => {
    get().addBear()
    get().addFish()
  },
})
```

**Importante**: aplique middlewares (persist, devtools, immer) apenas na
store combinada final, nunca dentro de um slice individual — isso causa
comportamento inesperado. Detalhes de tipagem de slices em
`references/typescript.md`.

## 6. Middlewares comuns

### persist (salvar em localStorage/sessionStorage)

```ts
import { persist, createJSONStorage } from 'zustand/middleware'

const useFishStore = create(
  persist(
    (set, get) => ({
      fishes: 0,
      addAFish: () => set({ fishes: get().fishes + 1 }),
    }),
    {
      name: 'food-storage', // chave única no storage
      storage: createJSONStorage(() => sessionStorage), // padrão: localStorage
    },
  ),
)
```

### immer (atualizar estado aninhado por mutação)

```ts
import { produce } from 'immer'

immerInc: () =>
  set(produce((state) => {
    state.deep.nested.obj.count++
  })),
```

Mais middlewares (devtools, subscribeWithSelector, redux, combine,
middleware customizado) em `references/middlewares.md`.

## 7. Next.js / SSR

Em apps server-rendered, criar a store como singleton de módulo causa
vazamento de estado entre requisições/usuários. Use um padrão de fábrica
de store por request + Context, ou veja o guia completo (hidratação,
`hasHydrated`, `initializeStore`) em `references/nextjs-ssr.md`.

## 8. Reset de estado e testes

- Reset: guarde o `initialState` fora do `create` e faça
  `set(initialState, true)` (substitui em vez de mesclar) numa action
  `reset()`. Detalhes em `references/testing-and-reset.md`.
- Testes: teste a store isoladamente via `useStore.getState()` /
  `setState()`, e componentes normalmente via Testing Library — a store
  real funciona sem mocks na maioria dos casos. Detalhes no mesmo arquivo.

## Boas práticas (checklist rápido)

- ✅ `create<T>()(...)` (parênteses duplos) em TypeScript
- ✅ Selecione o mínimo de estado necessário por componente
- ✅ `useShallow` ao selecionar múltiplos campos/objetos computados
- ✅ Middlewares só na store combinada, nunca dentro de um slice
- ✅ Nomes de storage únicos no `persist`
- ✅ Actions puras: seu único efeito colateral é atualizar o estado
- ❌ Não mutar o estado diretamente fora do Immer (`state.count++`)
- ❌ Não criar objetos novos dentro do seletor sem `useShallow`
- ❌ Não usar `create<T>(...)` com parênteses simples + middleware

## Referências completas

- `references/typescript.md` — tipagem avançada, slices tipados, stacks de middleware
- `references/updating-nested-state.md` — spread manual, Immer, optics-ts, Ramda
- `references/middlewares.md` — persist, devtools, subscribeWithSelector, redux, combine, middleware customizado
- `references/nextjs-ssr.md` — SSR, hidratação, inicialização por props
- `references/testing-and-reset.md` — reset de estado e testes

Fonte oficial: https://zustand.docs.pmnd.rs/learn/index