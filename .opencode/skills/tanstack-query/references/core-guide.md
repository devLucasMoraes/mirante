# Core Guide — Queries, Mutations, Invalidation, TypeScript, Devtools

Fonte: docs oficiais TanStack Query v5 (react). Leia esta referência quando for **escrever** código novo (não para debugar — para isso use `troubleshooting.md`).

## Queries em detalhe

```tsx
function Todos() {
  const { isPending, isError, data, error } = useQuery({
    queryKey: ['todos'],
    queryFn: fetchTodoList,
  })

  if (isPending) return <span>Loading...</span>
  if (isError) return <span>Error: {error.message}</span>

  return (
    <ul>
      {data.map((todo) => <li key={todo.id}>{todo.title}</li>)}
    </ul>
  )
}
```

Padrão recomendado: checar `isPending` → `isError` → assumir sucesso. TypeScript estreita (narrows) o tipo de `data` automaticamente depois desses checks.

### status vs fetchStatus

- `status`: fala sobre os **dados** — pending / error / success.
- `fetchStatus`: fala sobre a **queryFn** — fetching / paused / idle.
- Combinações não óbvias são normais: uma query `success` pode estar `fetching` (refetch em background). Uma query `pending` pode estar `paused` (sem rede — ver Network Mode).

## Mutations em detalhe

```tsx
const mutation = useMutation({
  mutationFn: (newTodo) => axios.post('/todos', newTodo),
})

mutation.mutate({ id: Date.now(), title: 'Do Laundry' })
```

### Ciclo de vida / side effects

```tsx
useMutation({
  mutationFn: addTodo,
  onMutate: (variables, context) => {
    // roda antes da mutation — retorno vira onMutateResult nos outros callbacks
    return { id: 1 }
  },
  onError: (error, variables, onMutateResult, context) => {
    console.log(`rollback ${onMutateResult.id}`)
  },
  onSuccess: (data, variables, onMutateResult, context) => {},
  onSettled: (data, error, variables, onMutateResult, context) => {},
})
```

- Callbacks passados para `mutate(vars, { onSuccess, onError, onSettled })` rodam **depois** dos callbacks de `useMutation` e só disparam uma vez, mesmo com chamadas consecutivas — só o último se mantém "vivo" porque o observer é resubscrito a cada `mutate()`.
- `mutateAsync` retorna Promise (use com try/catch/await).
- Retry: mutations **não** fazem retry por padrão; passe `retry: N` explicitamente.
- Se a mutation falhar por estar offline, ela é reexecutada automaticamente na reconexão, na mesma ordem.
- **Mutation Scopes**: mutations com o mesmo `scope: { id: 'x' }` rodam em série (fila), não em paralelo — útil para evitar race conditions em ações repetidas do mesmo tipo.
- Cuidado com `onSubmit` de formulários em React 16 ou anterior: `mutate` é assíncrona, então `event` pode já ter sido reciclado (pooling). Sempre envolva em outra função e chame `event.preventDefault()` antes.

## Query Invalidation em detalhe

```tsx
queryClient.invalidateQueries()                              // invalida tudo
queryClient.invalidateQueries({ queryKey: ['todos'] })        // prefixo
queryClient.invalidateQueries({ queryKey: ['todos'], exact: true }) // só a chave exata
queryClient.invalidateQueries({
  predicate: (query) => query.queryKey[0] === 'todos' && query.queryKey[1]?.version >= 10,
})
```

- Matching por prefixo é o comportamento padrão: `['todos']` invalida `['todos']`, `['todos', {page:1}]`, etc.
- Invalidar faz duas coisas: marca como stale (ignorando `staleTime`) e, se a query estiver ativa (renderizada em algum componente), dispara refetch em background.
- `staleTime: 'static'` é a **exceção**: bloqueia até invalidação manual via `invalidateQueries`.

## TypeScript

- Inferência de tipos é automática quando a `queryFn` tem retorno tipado:
  ```ts
  const fetchGroups = (): Promise<Group[]> => axios.get('/groups').then(r => r.data)
  const { data } = useQuery({ queryKey: ['groups'], queryFn: fetchGroups })
  //      data: Group[] | undefined
  ```
- `error` é tipado como `Error` por padrão. Para subclasses (ex. `AxiosError`), faça type narrowing (`axios.isAxiosError(error)`) em vez de forçar generics manualmente — forçar generics quebra a inferência dos outros parâmetros de `useQuery`.
- Para registrar um tipo de erro global (sem precisar de generics em cada call site):
  ```ts
  declare module '@tanstack/react-query' {
    interface Register { defaultError: unknown }
  }
  ```
- **`queryOptions` helper**: use sempre que precisar compartilhar as mesmas opções entre `useQuery`, `prefetchQuery`, `getQueryData`, etc. Preserva a inferência de tipos que se perderia extraindo um objeto plano:
  ```ts
  import { queryOptions } from '@tanstack/react-query'

  function groupOptions() {
    return queryOptions({
      queryKey: ['groups'],
      queryFn: fetchGroups,
      staleTime: 5 * 1000,
    })
  }

  useQuery(groupOptions())
  queryClient.prefetchQuery(groupOptions())
  const data = queryClient.getQueryData(groupOptions().queryKey) // tipado!
  ```
- Existe `mutationOptions` equivalente para `useMutation`.
- Para desabilitar uma query preservando type-safety, use `skipToken` em vez de `enabled: false` sozinho quando o argumento da queryFn depender de um valor possivelmente undefined.

## Devtools

```tsx
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

<QueryClientProvider client={queryClient}>
  {/* app */}
  <ReactQueryDevtools initialIsOpen={false} />
</QueryClientProvider>
```

- Só entra no bundle em dev (`process.env.NODE_ENV === 'development'`) — não precisa remover manualmente.
- Opções úteis: `buttonPosition`, `position`, `client` (para QueryClient customizado), `errorTypes` (para simular erros específicos pela UI).
- Existe modo `ReactQueryDevtoolsPanel` (embedded, não flutuante) e extensões de browser (Chrome/Firefox/Edge) que fazem a mesma coisa sem precisar instalar o pacote.
- Para produção: lazy-load com `React.lazy(() => import('@tanstack/react-query-devtools/production'))` atrás de um toggle manual (`window.toggleDevtools`), nunca inclua no bundle principal de produção sem lazy loading.

## Instalação — referência rápida

```bash
npm i @tanstack/react-query
npm i -D @tanstack/react-query-devtools @tanstack/eslint-plugin-query
```

Requisitos de browser: Chrome ≥91, Firefox ≥90, Edge ≥91, Safari ≥15, iOS ≥15, Opera ≥77. Projetos que precisam suportar browsers mais antigos precisam transpilar a lib manualmente.
