# Troubleshooting — TanStack Query v5

Guia de diagnóstico por sintoma. Use quando algo está se comportando de forma inesperada. Sempre comece abrindo o **Devtools** (`@tanstack/react-query-devtools`) — ele mostra o estado real de cada query em cache (`fresh`/`stale`/`fetching`/`paused`/`inactive`) e é o jeito mais rápido de confirmar uma hipótese antes de mexer em código.

## "Minha UI não atualiza depois de uma mutation"

Causa mais comum: esqueceu de invalidar ou atualizar o cache manualmente.

1. A mutation tem `onSuccess: () => queryClient.invalidateQueries({ queryKey: [...] })`?
2. O `queryKey` passado para `invalidateQueries` é um **prefixo válido** da query que está na tela? (`['todos']` invalida `['todos', {page:1}]`, mas `['todo', id]` não invalida `['todos']` — nomes diferentes não têm relação).
3. Se usou `predicate` ou `exact: true`, confirme que a lógica realmente cobre a query em questão — teste removendo o filtro temporariamente.
4. A query que deveria atualizar está **montada** (renderizada) no momento da invalidação? Queries invalidadas mas sem observer ativo só atualizam no próximo mount, não imediatamente.

Alternativa sem round-trip: usar `queryClient.setQueryData(key, updater)` dentro de `onSuccess` para escrever a resposta da mutation direto no cache, sem precisar refazer o fetch.

## "Minha query refaz fetch toda hora / refetch demais"

Isso é comportamento **esperado por padrão** (staleTime: 0 → tudo é considerado stale imediatamente, e stale + mount/focus/reconnect = refetch). Não é bug até prova em contrário.

- Configure `staleTime` para o tempo que os dados podem ficar "bons" sem refetch: `staleTime: 5 * 60 * 1000` (5 min), etc.
- Se o refetch incomodado é especificamente ao focar a janela, desative com `refetchOnWindowFocus: false` (mas pense se isso é realmente desejável antes de desativar globalmente).
- `staleTime: Infinity` — nunca refetch automático, mas `invalidateQueries` ainda funciona.
- `staleTime: 'static'` — nunca refetch, nem com invalidação manual. Só para dados verdadeiramente imutáveis durante a sessão.

## "meu `isError` nunca vira `true` mesmo com erro HTTP 500/404"

Causa quase sempre: a `queryFn` não está lançando (`throw`) em resposta de erro. `fetch()` **não rejeita a Promise em respostas HTTP de erro** — só rejeita em falha de rede. Você precisa checar `response.ok` e lançar manualmente:

```ts
const queryFn = async () => {
  const res = await fetch(url)
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  return res.json()
}
```

Bibliotecas como axios já lançam em status de erro por padrão — se estiver usando axios e ainda assim não cai em `isError`, confira se algum `.catch()` no meio do caminho está engolindo o erro.

## "Query não roda / fica pendente para sempre"

- Cheque `enabled: false` explícito ou implícito (`enabled: !!someValue` onde `someValue` nunca fica truthy).
- Cheque `fetchStatus`: se estiver `'paused'`, a rede está offline ou `networkMode` está bloqueando o fetch — veja o guia de Network Mode.
- Se a queryFn depende de uma variável que pode ser `undefined`, prefira `skipToken` (ver `core-guide.md` seção TypeScript) em vez de só `enabled`, para manter tipagem correta e evitar chamadas acidentais.

## "TypeScript não infere o tipo de `data`" / "genéricos manuais quebram tudo"

- Verifique se a `queryFn` tem retorno tipado explicitamente (`(): Promise<Group[]> => ...`). Sem isso, muitas libs HTTP retornam `any` e a inferência não tem de onde puxar.
- Se você passou generics manualmente em `useQuery<T, E>(...)`, isso desliga a inferência automática dos outros parâmetros — prefira deixar o TS inferir a partir da `queryFn`, ou use type narrowing (`if (axios.isAxiosError(error))`) em vez de generics para tipar erros.
- Se extraiu as opções de query para uma função separada e perdeu a inferência (ex. em `getQueryData`), use o helper `queryOptions()` — ver `core-guide.md`.

## "QueryClient parece perder o cache / comportamento aleatório entre renders"

Quase sempre: `new QueryClient()` está sendo instanciado **dentro** do corpo do componente, recriando o client (e o cache) a cada render. Corrija:

```tsx
// errado
function App() {
  const queryClient = new QueryClient() // recriado a cada render!
  ...
}

// certo
const queryClient = new QueryClient() // fora do componente
// ou, se precisar de algo dinâmico:
function App() {
  const [queryClient] = useState(() => new QueryClient())
  ...
}
```

A regra ESLint `@tanstack/query/stable-query-client` pega esse erro automaticamente — ver `eslint-plugin.md`.

## "Erro do ESLint plugin que não entendo"

Veja `eslint-plugin.md` para a lista de regras (`exhaustive-deps`, `no-rest-destructuring`, `stable-query-client`, `no-unstable-deps`, `no-void-query-fn`, etc.) e o que cada uma está protegendo.

## "Tela demora muito para carregar / múltiplos loadings em sequência"

Provável **request waterfall** — ver `performance.md`. Sintomas típicos: uma query só começa depois que outra termina, sem depender de fato dos dados dela; ou um componente filho só monta (e só então dispara sua própria query) depois que o pai termina de carregar.

## Onde procurar mais fundo

- **Devtools** sempre primeiro — mostra estado real de cada query/mutation.
- Documentação oficial (se tiver acesso à internet): `https://tanstack.com/query/latest/docs/framework/react/overview`
- Para bugs de tipo em cenários avançados: artigos linkados na doc de TypeScript (TkDodo blog) cobrem casos extremos de inferência.
