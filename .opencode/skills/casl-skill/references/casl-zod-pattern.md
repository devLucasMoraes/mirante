# Tipando subjects do CASL com Zod

Alternativa a `InferSubjects`/interfaces TS puras (ver `typescript.md`): usar **Zod** como fonte única da verdade para os subjects — o mesmo schema valida o objeto em runtime E gera o tipo estático. Útil em qualquer projeto que já use Zod para validar payloads/entidades e queira manter a definição de permissões sincronizada com esses mesmos schemas, em vez de mantê-los duplicados.

Isso não é uma feature do CASL — é apenas uma forma de organizar tipos TypeScript e alimentar o generic `MongoAbility<...>`. As peças do CASL propriamente dito (`AbilityBuilder`, `can`/`cannot`, `detectSubjectType`) continuam as mesmas descritas no resto desta skill.

## A técnica, em 4 passos

### 1. Cada entidade tem um schema Zod com um discriminador literal

```ts
import { z } from 'zod'

export const articleSchema = z.object({
  __typename: z.literal('Article').default('Article'),
  id: z.string(),
  authorId: z.string(),
})

export type Article = z.infer<typeof articleSchema>
```

- O campo discriminador (`__typename` é a convenção mais comum, mas pode ser `kind`, `type`, etc. — escolha um e seja consistente no projeto) usa `z.literal('X').default('X')`. O `.default(...)` é o que garante que, ao validar/criar o objeto via `schema.parse({...})`, o campo é preenchido automaticamente mesmo sem passá-lo explicitamente.
- Esse valor literal (`'Article'`) é o que o CASL vai enxergar como "subject type" — precisa bater exatamente com a string usada nas regras (`can('read', 'Article')`).

### 2. Cada entidade tem uma tupla Zod descrevendo ações válidas e as duas formas de referenciá-la

```ts
import { articleSchema } from './article-schema.js'
import { z } from 'zod'

export const articleSubject = z.tuple([
  z.union([
    z.literal('manage'),
    z.literal('read'),
    z.literal('update'),
    z.literal('delete'),
    z.literal('create'),
  ]),
  z.union([z.literal('Article'), articleSchema]),
])

export type ArticleSubject = z.infer<typeof articleSubject>
```

O segundo elemento da tupla aceita **ou** a string do tipo (`'Article'`, para checagens genéricas tipo "posso criar algum Article?") **ou** uma instância real do schema (para checagens sobre um objeto específico). Essa dualidade espelha exatamente como o CASL já funciona nativamente (`ability.can('read', 'Article')` vs `ability.can('read', articleInstance)`) — o Zod só está formalizando isso em tipo.

### 3. Uma union de todas as tuplas alimenta o tipo genérico da `Ability`

```ts
import { AbilityBuilder, type CreateAbility, createMongoAbility, type MongoAbility } from '@casl/ability'
import { z } from 'zod'
import { articleSubject } from './subjects/article.js'
import { commentSubject } from './subjects/comment.js'

export const appAbility = z.union([
  articleSubject,
  commentSubject,
  z.tuple([z.literal('manage'), z.literal('all')]), // sempre inclua o coringa universal
])

type AppAbilities = z.infer<typeof appAbility>

export type AppAbility = MongoAbility<AppAbilities>
export const createAppAbility = createMongoAbility as CreateAbility<AppAbility>
```

- `z.infer` extrai o tipo TS da union — é isso que vira o generic de `MongoAbility<AppAbilities>`.
- O cast `createMongoAbility as CreateAbility<AppAbility>` é o que dá ao `AbilityBuilder` e a `build()` autocomplete e checagem de tipo corretos para as actions/subjects definidos. Sem esse cast, os tipos ficam genéricos demais e você perde a validação estática de "essa action existe para esse subject".

### 4. `detectSubjectType` aponta para o mesmo discriminador usado no passo 1

```ts
const ability = builder.build({
  detectSubjectType: (subject) => subject.__typename,
})
```

Isso resolve, de forma centralizada, o problema descrito em `subject-type-detection.md`: sem essa configuração, um objeto plano `{ id: '1' }` não seria reconhecido pelo CASL, mesmo tendo uma regra correta para o tipo dele. Como o `__typename` já é preenchido automaticamente pelo `.default(...)` do Zod ao validar o objeto, basta apontar `detectSubjectType` para esse campo — não é mais necessário chamar o helper `subject('Article', obj)` manualmente em cada checagem.

## Por que usar essa técnica (trade-offs)

**Vantagens:**
- Uma única definição por entidade serve para validação de runtime (ex. parsear payload de API) e para tipagem das permissões — elimina duplicação e risco de dessincronia entre "o que a API aceita" e "o que o CASL sabe checar".
- `detectSubjectType` resolvido uma vez, de forma centralizada, em vez de espalhar chamadas a `subject(...)` pelo código.

**Trade-offs / quando não vale a pena:**
- Adiciona uma dependência de tipagem em `zod` só para estruturar as permissões — se o projeto não já usa Zod para essa entidade, prefira `InferSubjects`/interfaces simples (ver `typescript.md`), que é mais direto.
- É um padrão de organização de código, não uma feature nativa do CASL — não existe suporte especial do CASL para Zod; tudo é fiação manual de tipos TypeScript.

## Checklist genérico para adicionar um novo subject

1. Criar o schema Zod da entidade com o campo discriminador (`__typename` ou o nome escolhido) usando `z.literal('Nome').default('Nome')`.
2. Criar a tupla Zod de ações válidas + `z.union([z.literal('Nome'), schema])`.
3. Adicionar essa tupla na `z.union([...])` geral que compõe `AppAbilities`.
4. Escrever as regras (`can`/`cannot`) usando exatamente a mesma string do discriminador como subject.
5. Garantir que qualquer objeto passado para `ability.can()` tenha passado pelo `schema.parse(...)` (ou equivalente) antes — senão o discriminador não estará presente e a detecção falha (ver `subject-type-detection.md`).

## Erros comuns desta técnica (não específicos de um projeto)

- **Nome do subject inconsistente entre schema e regra** — se o schema usa `__typename: 'Article'` mas a regra é escrita como `can('read', 'article')` (minúsculo) ou `'Post'`, a regra nunca bate. É correspondência exata de string.
- **Objeto construído sem passar pelo Zod** — um objeto literal montado à mão (`{ id: '1', authorId: '2' }`, sem `__typename`) não tem o discriminador, então `detectSubjectType` retorna `undefined` e a checagem falha silenciosamente. Sempre construa/valide objetos de entidade pelo schema correspondente antes de checar permissões.
- **Esquecer de adicionar a tupla nova na union geral (`appAbility`)** — o TypeScript pode não acusar erro imediatamente (dependendo de como o restante do código usa os tipos), mas o autocomplete de actions/subjects não vai listar a entidade nova, e checagens mais estritas podem falhar silenciosamente em outros pontos do app.
- **Esquecer o `manage`/`all` coringa na union geral** — se o projeto depende de `can('manage', 'all')` para roles administrativas, omitir essa tupla da union quebra a tipagem dessa checagem específica.

## Consumindo a ability numa rota HTTP (padrão backend)

A definição da `Ability` (passos 1-4 acima) normalmente mora num pacote/módulo compartilhado (ex. `packages/authorization`, ou `libs/authorization`), separado da API. O consumo típico numa camada HTTP segue este fluxo: **extrair a identidade do usuário autenticado → construir a ability → checar a permissão → lançar erro (ou seguir) antes de tocar no banco.**

### 1. Um helper fino encapsula a criação da `Ability` para o usuário autenticado

Em vez de chamar `defineAbilityFor(...)` diretamente em cada rota, é comum ter um helper de uma linha que valida a identidade com o mesmo schema Zod usado para o subject `User` e devolve a ability já pronta:

```ts
// get-user-permissions.ts
import { defineAbilityFor, type Role, userSchema } from '@your-scope/authorization'

export function getUserPermissions(userId: string, role: Role) {
  const authUser = userSchema.parse({ id: userId, role })
  return defineAbilityFor(authUser)
}
```

Note que `userSchema.parse(...)` é chamado aqui — é isso que preenche o discriminador (`__typename`, `kind`, etc.) do usuário autenticado antes de ele ser usado para montar a ability. Centralizar essa chamada num único helper evita que cada rota precise lembrar de validar o usuário manualmente antes de checar permissões.

### 2. Na rota, extraia a identidade do token/sessão, monte a ability, cheque antes de qualquer efeito colateral

```ts
// dentro de um handler de rota (exemplo com Fastify, mas o padrão vale para qualquer framework HTTP)
const { tenantId, role: userRole, sub: userId } = req.user as {
  tenantId: string
  role: Role
  sub: string
}

const { cannot } = getUserPermissions(userId, userRole)

if (cannot('create', 'User')) {
  throw new ForbiddenError('Você não tem permissão para acessar esse recurso')
}

// só a partir daqui o handler toca no banco de dados / efeitos colaterais
```

Pontos importantes deste padrão de consumo:

- **Desestruture `cannot` (ou `can`) diretamente do retorno** de `getUserPermissions(...)` — como a ability já vem com `can`/`cannot` vinculados (bind) na função que a constrói (ver passo de `AbilityBuilder.build()`), desestruturar não perde o `this`. Se a ability do seu projeto **não** faz esse bind, prefira `const ability = getUserPermissions(...)` e chame `ability.cannot(...)`, para evitar o erro clássico de `this` indefinido.
- **A checagem de permissão acontece antes de qualquer leitura/escrita no banco** — é o padrão "fail fast": não faz sentido consultar unicidade de e-mail, hashear senha, etc., se o usuário nem tem permissão para a ação. Sempre posicione o `if (cannot(...)) throw ...` o mais cedo possível no handler, logo após montar a ability.
- **Erro de domínio, não erro genérico** — lance uma classe de erro própria do projeto (`ForbiddenError`, `UnauthorizedError`, etc.) em vez de um `Error` genérico ou de retornar um status manualmente. Isso mantém a checagem de autorização consistente com o restante do tratamento de erros da aplicação (ex. um middleware global que converte `ForbiddenError` em HTTP 403).
- **A ação checada aqui é sobre o subject type (string), não uma instância** — `cannot('create', 'User')` pergunta "esse usuário pode criar *algum* User?", o que faz sentido numa rota de criação (o recurso ainda não existe para checar condições como `{ ownerId: ... }`). Para rotas de update/delete sobre um recurso já existente, prefira checar contra a instância carregada do banco (`cannot('update', existingUser)`), para que condições como "só o próprio tenant" sejam avaliadas — ver `conditions-and-fields.md`.

### Checklist para adicionar a checagem de permissão numa nova rota

1. Extrair `userId`/`role` (e qualquer outro dado necessário para o subject `User`, como `tenantId`) da identidade autenticada (token, sessão, etc.).
2. Chamar o helper (`getUserPermissions` ou equivalente) para obter a `ability` — nunca construa a ability manualmente dentro da rota.
3. Chamar `cannot(action, subjectTypeOuInstancia)` **antes** de qualquer leitura/escrita relevante.
4. Lançar o erro de domínio apropriado (`ForbiddenError`) se `cannot(...)` for `true` — nunca apenas logar ou seguir em frente.
5. Se a regra depende de atributos do recurso (não só do tipo), buscar a instância primeiro e checar contra ela, não contra a string do tipo.

