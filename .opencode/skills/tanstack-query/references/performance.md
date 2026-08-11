# Performance & Request Waterfalls

## O que é um request waterfall

Uma requisição só começa depois que outra termina, quando isso não era estritamente necessário. Cada "degrau" do waterfall é um round-trip completo ao servidor; com latência alta (~250ms em 3G), poucos degraus já custam segundos.

```
1. |-> Markup
2.   |-> JS
3.     |-> Query
```

## Padrões que causam waterfall em TanStack Query

### 1. Queries seriais dentro do mesmo componente

```tsx
// RUIM: a segunda query só roda depois que a primeira resolve
const { data: user } = useQuery({ queryKey: ['user', email], queryFn: getUserByEmail })
const { data: projects } = useQuery({
  queryKey: ['projects', user?.id],
  queryFn: getProjectsByUser,
  enabled: !!user?.id, // dependent query — sempre serial
})
```

Quando é genuinamente uma **dependent query** (a segunda precisa de dado da primeira), o waterfall é inevitável no client — a solução real é redesenhar a API (endpoint único `getProjectsByUserEmail`) ou mover a lógica para o servidor (Server Components).

### 2. `useSuspenseQuery` múltiplas no mesmo componente

```tsx
// RUIM: com Suspense, cada useSuspenseQuery separada roda em série
const usersQuery = useSuspenseQuery({ queryKey: ['users'], queryFn: fetchUsers })
const teamsQuery = useSuspenseQuery({ queryKey: ['teams'], queryFn: fetchTeams })
```

```tsx
// BOM: useSuspenseQueries roda tudo em paralelo
const [usersQuery, teamsQuery, projectsQuery] = useSuspenseQueries({
  queries: [
    { queryKey: ['users'], queryFn: fetchUsers },
    { queryKey: ['teams'], queryFn: fetchTeams },
    { queryKey: ['projects'], queryFn: fetchProjects },
  ],
})
```

Regra prática: **nunca** use múltiplas `useSuspenseQuery` soltas no mesmo componente — sempre `useSuspenseQueries`. Com `useQuery` normal (sem suspense) isso não é problema, pois já rodam em paralelo naturalmente.

### 3. Nested component waterfalls

Pai não renderiza o filho até sua própria query terminar, e o filho só dispara a query dele depois de montar.

```tsx
// Se Comments não depende de nada que só existe depois do fetch do Article,
// isso é um waterfall desnecessário
function Article({ id }) {
  const { data: articleData, isPending } = useQuery({ queryKey: ['article', id], queryFn: getArticleById })
  if (isPending) return 'Loading...'
  return <><ArticleBody data={articleData} /><Comments id={id} /></>
}
```

Fix: hoiste a query do filho para o pai (ambos disparam em paralelo), ou prefetch a query do filho no pai, ou prefetch no nível de rota.

Quando o filho **de fato depende** de um dado que só existe após o fetch do pai (dependent nested waterfall — ex: um `feedItem.id` que só existe depois de buscar o feed), não dá para simplesmente hoistear; a solução real é redesenhar a API para incluir os dados já no fetch do pai, ou mover para o servidor.

### 4. Code splitting + query no componente lazy

```tsx
const GraphFeedItem = React.lazy(() => import('./GraphFeedItem')) // contém sua própria useQuery
```

Isso cria uma cadeia: `markup → JS do Feed → getFeed() → JS do GraphFeedItem → getGraphDataById()` — até 5 round-trips no pior caso. Trade-off: ou inclui o código de fetch no bundle principal (mais peso inicial, sem waterfall) ou aceita o waterfall do code split. Uma saída intermediária é fazer prefetch condicional da query assim que se sabe que o componente lazy vai ser necessário, em paralelo ao carregamento do JS dele.

## Como diagnosticar

Aba **Network** do devtools do browser é a ferramenta #1 — waterfalls aparecem visualmente como requisições em cascata em vez de em paralelo. Não é preciso eliminar todo waterfall — só ficar de olho nos de maior impacto (os que aparecem cedo na cadeia de carregamento, ou os que se repetem muito).

## Próximos passos (fora do escopo desta skill, mas relevantes)

- **Prefetching & Router Integration** — prefetch de dados antes da navegação.
- **Server Rendering & Hydration** — prefetch no servidor, hidrata no client sem refetch.
- **Advanced Server Rendering** — aplicação desses padrões com React Server Components e streaming.

Se a tarefa exigir essas técnicas, consulte a documentação oficial diretamente (`https://tanstack.com/query/latest/docs/framework/react/guides/prefetching`, `.../ssr`, `.../advanced-ssr`) — não fazem parte do conteúdo compactado nesta skill.
