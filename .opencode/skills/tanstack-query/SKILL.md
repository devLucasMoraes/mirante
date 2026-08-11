---
name: tanstack-query
description: Use this skill whenever working with TanStack Query (React Query) v5 in a React project — writing useQuery/useMutation/useInfiniteQuery code, setting up QueryClient/QueryClientProvider, debugging stale/refetch/cache behavior, fixing invalidateQueries not working, resolving TypeScript inference issues with queryOptions, configuring the ESLint plugin, or diagnosing request waterfalls and performance issues. Always consult this skill before writing or editing any file that imports from '@tanstack/react-query', and whenever the user mentions "React Query", "TanStack Query", queryKey, queryFn, staleTime, or cache invalidation — even if they don't name the library explicitly.
---

# TanStack Query (React Query) v5 — React

Guia de proficiência para trabalhar com TanStack Query no opencode. Cobre os conceitos essenciais, os erros mais comuns e onde procurar mais detalhes sem estourar o contexto.

## Regra de ouro

TanStack Query gerencia **server state** (dados assíncronos, remotos, que podem ficar desatualizados) — não é uma store de estado de cliente tipo Redux/Zustand. Todo problema estranho geralmente se resolve voltando a este princípio: "meus dados estão sujeitos a cache, staleness e refetch automático — o que a configuração atual diz sobre isso?"

## Setup mínimo (sempre necessário)

```bash
npm i @tanstack/react-query
npm i -D @tanstack/react-query-devtools @tanstack/eslint-plugin-query
```

```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

const queryClient = new QueryClient()

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <YourApp />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
```

- Requer React 18+.
- `QueryClient` deve ser criado **uma vez fora do componente** (ou com `useState(() => new QueryClient())` se precisar criar dentro). Recriar a cada render quebra o cache — ver `references/eslint-plugin.md` para a regra `stable-query-client` que pega esse erro automaticamente.
- Devtools só entram no bundle em `NODE_ENV === 'development'`; não precisa remover manualmente para produção.

## Os 3 conceitos centrais

### 1. Queries (leitura) — `useQuery`

```tsx
const { data, isPending, isError, error, isFetching } = useQuery({
  queryKey: ['todos'],
  queryFn: fetchTodoList,
})
```

- `queryKey`: identificador único (array). É a chave de cache — mudar o array = query diferente.
- `queryFn`: função que retorna uma Promise. Deve **resolver os dados ou lançar (throw) um erro**. Se a função não fizer throw em erro HTTP, `isError` nunca vai disparar (erro comum — ver troubleshooting).
- Estados: `isPending` (sem dados ainda) → `isError` → assume sucesso. Existe também `status` (`'pending' | 'error' | 'success'`) como alternativa aos booleans.
- `fetchStatus` é **independente** de `status`: `'fetching' | 'paused' | 'idle'`. Uma query pode estar `status: 'success'` e `fetchStatus: 'fetching'` ao mesmo tempo (refetch em background). Confundir os dois é fonte comum de bugs de UI.

### 2. Mutations (escrita) — `useMutation`

```tsx
const mutation = useMutation({
  mutationFn: (newTodo) => axios.post('/todos', newTodo),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] })
  },
})

mutation.mutate({ title: 'Do Laundry' })
```

- Estados: `isIdle`, `isPending`, `isError`, `isSuccess`.
- `mutate()` é fire-and-forget; use `mutateAsync()` se precisar de `await`/try-catch.
- Diferente de queries, mutations **não fazem retry automático** por padrão.
- `onMutate`/`onError`/`onSuccess`/`onSettled` recebem sempre `(payload, variables, onMutateResult, context)` — o valor retornado de `onMutate` vira o 3º argumento nos demais (útil para rollback de optimistic updates).

### 3. Invalidação — `queryClient.invalidateQueries`

```tsx
queryClient.invalidateQueries({ queryKey: ['todos'] })
```

- Faz **matching por prefixo** por padrão: invalidar `['todos']` também invalida `['todos', {page: 1}]`.
- Use `exact: true` para invalidar só a chave exata.
- Use `predicate` para lógica customizada de matching.
- Invalidar marca a query como stale e, se estiver montada em algum componente ativo, dispara refetch em background automaticamente — não precisa fazer refetch manual depois de invalidar.

## Defaults importantes que pegam gente de surpresa

| Comportamento | Default | Onde mexer |
|---|---|---|
| Dados considerados stale | Imediatamente (staleTime: 0) | `staleTime` |
| Refetch automático | Ao montar, focar janela, reconectar rede | `refetchOnMount`/`refetchOnWindowFocus`/`refetchOnReconnect` |
| Garbage collection de queries inativas | 5 minutos | `gcTime` |
| Retry em erro | 3 tentativas com backoff exponencial | `retry`/`retryDelay` |
| Retry em mutation | **Nenhum** (diferente de query!) | `retry` |

`staleTime: Infinity` bloqueia refetch automático mas `invalidateQueries` ainda funciona. `staleTime: 'static'` bloqueia até invalidação manual — use só para dados que realmente não mudam durante a sessão (feature flags no boot, etc).

## Antes de escrever qualquer código

1. Se a tarefa envolve **escrever queries/mutations do zero, TypeScript, ou queryOptions** → leia `references/core-guide.md`.
2. Se a tarefa é **debugar um comportamento estranho** (refetch demais, cache não atualiza, erro não aparece) → vá direto para `references/troubleshooting.md`.
3. Se a tarefa envolve **configurar ESLint** → leia `references/eslint-plugin.md`.
4. Se a tarefa envolve **performance / múltiplas queries / componentes aninhados** → leia `references/performance.md`.

Não carregue todas as references de uma vez — abra só a que resolve a tarefa atual.

## Checklist rápido antes de considerar terminado

- [ ] `queryKey` é um array e inclui todas as variáveis das quais `queryFn` depende (evita bugs de cache "colado")
- [ ] `queryFn` lança erro em vez de retornar objeto de erro silencioso
- [ ] Mutations que devem refletir na UI chamam `invalidateQueries` (ou atualização otimista) no `onSuccess`
- [ ] Nenhum `QueryClient` sendo recriado a cada render
- [ ] TypeScript: usando inferência automática (não anotando tipos manualmente) — se precisar extrair opções para reuso, usar `queryOptions()`
