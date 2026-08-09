# Condições (ABAC) e restrição de campos

## Condições estilo MongoDB

CASL usa um subconjunto de operadores MongoDB (via `ucast`) para restringir por atributos do objeto:

`$eq`, `$ne`, `$lt`, `$lte`, `$gt`, `$gte`, `$in`, `$nin`, `$all`, `$size`, `$regex`, `$exists`, `$elemMatch`

```js
can('read', 'Article', { status: { $in: ['review', 'published'] } });
can('update', 'WishlistItem', {
  sharedWith: { $elemMatch: { permission: 'update', userId: user.id } },
});
can('read', 'User', { 'country.isoCode': 'BR' }); // dot notation p/ campo aninhado
```

Um caso muito comum em aplicações multi-tenant é restringir por dono/tenant:
```js
can('manage', 'Invoice', { tenantId: user.tenantId });
```

**Operadores lógicos `$and`, `$or`, `$nor`, `$not` NÃO existem por padrão.** Isso é intencional:
- `$or` → combine múltiplos `can` para o mesmo par action/subject.
- `$and` → várias chaves no mesmo objeto de condições já são combinadas com AND.
- `$not`/`$nor` → use `cannot` (regra invertida), ou registre operador customizado via `buildMongoQueryMatcher` (ver `aliases-and-customization.md`) se realmente precisar de `$nor`.

Se o usuário perguntar "como faço um OR/NOR em CASL", a resposta correta não é procurar um operador `$or` — é reestruturar em múltiplas regras `can`/`cannot`.

## Restringindo campos (field-level permissions)

```js
can('update', 'Article', ['title', 'description'], { authorId: user.id });
if (user.isModerator) can('update', 'Article', ['published']);
```

Checagem:
```js
ability.can('update', article, 'title');       // checando numa instância
ability.can('update', 'Article', 'title');      // checando no subject type
```

⚠️ **Diferença crítica e fonte comum de "bug" reportado por usuários:**
- Checar contra uma **instância** responde "posso atualizar o título *deste* artigo?"
- Checar contra o **subject type** (string) responde "posso atualizar o título de *pelo menos um* artigo?" — por isso pode retornar `true` mesmo quando, para um artigo específico, seria `false`. Isso não é bug, é o comportamento documentado.

Para extrair todos os campos permitidos, use `permittedFieldsOf` de `@casl/ability/extra`:
```js
import { permittedFieldsOf } from '@casl/ability/extra';
const fields = permittedFieldsOf(ability, 'update', article, {
  fieldsFrom: (rule) => rule.fields || ALL_FIELDS,
});
// combine com lodash.pick para sanitizar o body de uma request
```

## Padrões de campo (wildcards)

`*` casa um nível (não cruza `.`), `**` casa qualquer profundidade.
```js
can('read', 'User', ['address.*']);   // address, address.street — NÃO address.city.name
can('read', 'User', ['address.**']);  // address.city.name — qualquer profundidade
```

| Pattern | Exemplo | Resultado |
|---|---|---|
| `address.*` | `can('read','User','address')` | `true` |
| | `can('read','User','address.city')` | `true` |
| | `can('read','User','address.city.name')` | `false` |
| `address.**` | `can('read','User','address.city.name')` | `true` |
| `*.name` | `can('read','User','city.name')` | `true` |
| | `can('read','User','address.city.name')` | `false` |
| `**.name` | `can('read','User','address.city.name')` | `true` |
