# Detecção de subject type (⚠️ causa nº 1 de "can sempre retorna false")

Quando você passa um **objeto** (não string/classe/função) como subject, o CASL precisa descobrir o "tipo" dele. Por padrão:
1. Usa `object.constructor.modelName` (propriedade estática) se existir;
2. Senão, cai para `object.constructor.name`.

Um objeto literal `{}` tem `constructor.name === 'Object'` — quase nunca bate com nenhuma regra, resultando em `false` silencioso. Isso é a explicação mais comum para "defini a regra certinho mas `can()` retorna false".

## Soluções (3 abordagens gerais)

**a) Usar classe com `modelName` estático** (bom para backend/TS, sobrevive a minificação):
```js
class Article {
  static get modelName() { return 'Article'; }
}
```

**b) Usar o helper `subject()` para objetos DTO/planos** (comum em frontend, chamado toda vez):
```js
import { subject } from '@casl/ability';
ability.can('read', subject('Article', articleDTO)); // true, se a regra permitir
```
Isso seta uma propriedade `__caslSubjectType__` no objeto. Alias comum: `import { subject as an } from '@casl/ability'` para escrever `an('Article', obj)`.

**c) Fornecer `detectSubjectType` customizado** (centralizado, resolve de uma vez — abordagem recomendada em projetos maiores):
```js
const ability = createMongoAbility(rules, {
  detectSubjectType: (object) => object.__typename,
});
```

Abordagem (c) é a mais robusta em projetos maiores: resolvida uma única vez na criação da `ability`, elimina a necessidade de chamar `subject('Tipo', obj)` manualmente toda vez que uma checagem é feita. Se o projeto já usa uma biblioteca de validação (Zod, io-ts, etc.) para tipar entidades, é comum usar o mesmo campo discriminador dessas entidades como fonte para `detectSubjectType` — ver `casl-zod-pattern.md` para um exemplo concreto dessa técnica.

## Custom detection para outros formatos (ex. GraphQL)

```js
const ability = createMongoAbility(rules, {
  detectSubjectType: (object) => object.__typename, // GraphQL já usa essa convenção nativamente
});
```

## Checklist de debug quando `can()` retorna `false` inesperadamente

1. O subject passado é um objeto plano sem `modelName`/tag customizada/`subject()` aplicado? → provável causa raiz.
2. Se o projeto usa `detectSubjectType` customizado apontando para um campo (ex. `__typename`), esse campo realmente está presente no objeto sendo checado? Objetos montados à mão (sem passar por validação/factory) costumam não ter esse campo.
3. A ordem das regras está certa (`cannot` depois de `can` geral, não antes)?
4. Está checando fields contra instância vs. contra subject type (ver `conditions-and-fields.md`)?
5. As `conditions` batem exatamente com o shape do objeto (nomes de campo, dot notation)?
6. O nome da ação está exatamente igual ao usado na regra? (ex.: `'get'` vs `'read'` — confira a convenção de nomes de ação adotada no projeto, o CASL faz correspondência exata de string).
