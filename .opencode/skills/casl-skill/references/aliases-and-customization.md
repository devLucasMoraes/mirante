# Aliases de ação e customização

## Aliases de ação (`createAliasResolver`)

Combina várias ações em uma:
```js
import { createAliasResolver, createMongoAbility } from '@casl/ability';

const resolveAction = createAliasResolver({ modify: ['update', 'delete'] });
const ability = createMongoAbility(rules, { resolveAction });

can('modify', 'Post'); // implica can('update') E can('delete')
```

⚠️ **Funciona só numa direção**: definir `can(['update','delete'], 'Post')` NÃO implica automaticamente `can('modify', 'Post')`. Aliases são resolvidos uma vez, na criação/`update()` da ability — não dinamicamente.

Aliases podem ser aninhados (resolvidos recursivamente):
```js
const resolveAction = createAliasResolver({
  modify: ['update', 'delete'],
  access: ['read', 'modify'],
});
```

Restrições (fora de produção, checado via `NODE_ENV`): não é permitido criar alias para `manage` (já é coringa universal), nem alias que aponte pra si mesmo. Ciclos indiretos (A→B→A) **não** são detectados automaticamente.

## Customizando a Ability (operadores, matchers)

- **Adicionar operador Mongo customizado** (ex.: `$nor`) sem perder os padrão:
```ts
import { buildMongoQueryMatcher } from '@casl/ability';
import { $nor, nor } from '@ucast/mongo2js';

const conditionsMatcher = buildMongoQueryMatcher({ $nor }, { nor });
const ability = build({ conditionsMatcher });
```

- **Restringir operadores disponíveis** (bundle menor, regras mais simples): monte um `conditionsMatcher` customizado com `createFactory` de `@ucast/mongo2js`, passando só os operadores desejados.

- **Matcher baseado em função** (não serializável — cuidado se as regras precisam ir para o banco/rede): use `PureAbility` + `conditionsMatcher` que aceita uma função lambda como condição:
```ts
import { PureAbility, AbilityBuilder, MatchConditions, AbilityClass } from '@casl/ability';

const lambdaMatcher = (matchConditions: MatchConditions) => matchConditions;
can('read', 'Article', ({ authorId }) => authorId === user.id);
build({ conditionsMatcher: lambdaMatcher });
```

- **Custom field matcher**: raramente necessário; o default já cobre wildcards (ver `conditions-and-fields.md`).

Esses recursos são avançados e pouco usados no dia a dia — mas úteis se surgir necessidade de um operador MongoDB não suportado nativamente (ex. `$nor`) ou de matching baseado em função em vez de query.
