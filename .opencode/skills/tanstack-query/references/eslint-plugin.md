# @tanstack/eslint-plugin-query

## Instalação

```bash
npm i -D @tanstack/eslint-plugin-query
```

## Flat config (eslint.config.js) — recomendado

```js
import pluginQuery from '@tanstack/eslint-plugin-query'

export default [
  ...pluginQuery.configs['flat/recommended'],
  // resto da config...
]
```

Versão mais rígida (`flat/recommended-strict`) — extends `recommended` com regras adicionais mais opinativas:

```js
export default [
  ...pluginQuery.configs['flat/recommended-strict'],
]
```

Setup custom (só as regras desejadas):

```js
export default [
  {
    plugins: { '@tanstack/query': pluginQuery },
    rules: { '@tanstack/query/exhaustive-deps': 'error' },
  },
]
```

## Legacy config (.eslintrc)

```json
{ "extends": ["plugin:@tanstack/query/recommended"] }
```

ou versão estrita: `"plugin:@tanstack/query/recommendedStrict"`.

## Regras disponíveis

| Regra | O que pega |
|---|---|
| `exhaustive-deps` | `queryKey` que não inclui todas as variáveis usadas dentro de `queryFn` — causa de bugs de cache "colado" (dados errados aparecendo porque a key não mudou quando deveria) |
| `no-rest-destructuring` | Destructuring com rest (`const { data, ...rest } = useQuery(...)`) que quebra a otimização de tracking de propriedades do React Query |
| `stable-query-client` | `QueryClient` instanciado dentro do corpo do componente (recriado a cada render) — ver `troubleshooting.md` |
| `no-unstable-deps` | Dependências instáveis (objetos/funções recriados a cada render) passadas onde deveriam ser estáveis |
| `infinite-query-property-order` | Ordem incorreta de propriedades em `useInfiniteQuery` (algumas dependem de outras estarem definidas antes) |
| `no-void-query-fn` | `queryFn` que não retorna nada (void) — quebra a expectativa de que a função resolve dados |
| `mutation-property-order` | Ordem incorreta de propriedades em `useMutation` |
| `prefer-query-options` | Sugere extrair para `queryOptions()` quando apropriado (ver `core-guide.md`) |

Recomendação: sempre ativar pelo menos `flat/recommended` em projetos novos — essas regras pegam a maioria dos bugs mais comuns e sutis (especialmente `exhaustive-deps` e `stable-query-client`) antes de virarem problema em runtime.
