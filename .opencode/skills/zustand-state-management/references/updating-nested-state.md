# Atualizando estado aninhado

`set` só faz merge raso (nível superior). Para estado aninhado profundo,
há várias opções.

## Spread manual

```ts
type State = {
  deep: {
    nested: {
      obj: { count: number }
    }
  }
}

// dentro da store
normalInc: () =>
  set((state) => ({
    deep: {
      ...state.deep,
      nested: {
        ...state.deep.nested,
        obj: {
          ...state.deep.nested.obj,
          count: state.deep.nested.obj.count + 1,
        },
      },
    },
  })),
```

Funciona, mas fica verboso rapidamente conforme a profundidade aumenta.

## Immer (recomendado para estado aninhado)

```ts
import { produce } from 'immer'

immerInc: () =>
  set(produce((state: State) => {
    state.deep.nested.obj.count++
  })),
```

Muito mais enxuto. Atenção aos "gotchas" do Immer (ex: não retornar E
mutar ao mesmo tempo dentro do produce, cuidado com classes e `Map`/`Set`
sem suporte a proxy habilitado). Também é possível usar o middleware
`zustand/middleware/immer` para aplicar Immer a todas as actions da store
de uma vez, em vez de envolver `set` manualmente em cada uma.

## optics-ts

Alternativa sem proxies/mutação, baseada em "optics" (lentes) tipados:

```ts
import * as O from 'optics-ts'

opticsInc: () =>
  set(O.modify(O.optic<State>().path('deep.nested.obj.count'))((c) => c + 1)),
```

## Ramda

```ts
import * as R from 'ramda'

ramdaInc: () =>
  set(R.over(R.lensPath(['deep', 'nested', 'obj', 'count']), (c) => c + 1)),
```

Tanto `optics-ts` quanto Ramda funcionam bem tipados. Immer costuma ser a
escolha mais comum por já ser familiar de Redux Toolkit/React.
