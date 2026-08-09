# TypeScript com CASL

Versão mínima do TS: 3.8.3 (export type syntax).

## Padrão "clássico" (interfaces/tagged unions)

```ts
type Actions = 'create' | 'read' | 'update' | 'delete';
type Subjects = 'Article' | 'Comment' | 'User';
export type AppAbility = MongoAbility<[Actions, Subjects]>;
```

**Companion object pattern** para usar o tipo como valor:
```ts
import { Ability, AbilityClass } from '@casl/ability';
export const AppAbility = Ability as AbilityClass<AppAbility>;
```

`InferSubjects<T>` infere subjects a partir de interfaces/classes com tag `kind`, `__typename` ou `__caslSubjectType__`.

## Alternativa: derivar os tipos de schemas de validação (Zod)

Em vez de `InferSubjects`, é possível derivar `AppAbilities` de uma union de schemas de validação (ex. Zod) e castear `createMongoAbility` com `CreateAbility<AppAbility>`:

```ts
export const appAbility = z.union([userSubject, articleSubject, /* ... */]);
type AppAbilities = z.infer<typeof appAbility>;
export type AppAbility = MongoAbility<AppAbilities>;
export const createAppAbility = createMongoAbility as CreateAbility<AppAbility>;
```

Ver `casl-zod-pattern.md` para o passo a passo completo. Essa abordagem é útil quando o projeto já usa uma biblioteca de validação para as mesmas entidades — garante que o schema que valida dados em runtime (ex. payloads de API) também define os tipos de permissão, evitando divergência entre "o que a API aceita" e "o que o CASL sabe checar".

## Erros comuns de tipo

- `Type '{...}' is not assignable to type 'ForcedSubject<"X">'` — significa que o objeto precisa passar por `subject()` (ou ter a tag esperada, como `kind`/`__typename`) antes de ser usado onde o tipo exige um subject "forçado". Se o objeto vem de uma validação (Zod/io-ts/etc.), confirme que ele de fato passou pelo `.parse()`/factory antes de chegar na checagem.
- Erro de `unbound-method` do eslint ao desestruturar `createMongoAbility` diretamente — prefira sempre passar a função para `new AbilityBuilder(createMongoAbility)` em vez de desestruturar `can`/`cannot` de uma chamada direta a `createMongoAbility<...>()`.

## Helpers úteis

- `RawRuleOf<AppAbility>` — tipar regras cruas vindas de API/DB.
- `AbilityOptionsOf<AppAbility>` — tipar opções passadas para `build()`/`createMongoAbility`.
- `AnyAbility` / `AnyMongoAbility` — bons para restrições em tipos genéricos.
- `ExtractSubjectType` — usado ao customizar `detectSubjectType` com classes (cast de `object.constructor`).
