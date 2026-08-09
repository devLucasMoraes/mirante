# Nomenclatura atual, versionamento e segurança

## `Ability` vs `createMongoAbility` vs `PureAbility` (⚠️ ponto de confusão comum)

Em versões recentes do `@casl/ability`, a antiga classe `Ability` (com matcher Mongo embutido) foi substituída pelo padrão baseado em factory function:

```js
import { createMongoAbility, AbilityBuilder } from '@casl/ability';

const { can, cannot, build } = new AbilityBuilder(createMongoAbility);
can('read', 'Post');
const ability = build();
```

- `createMongoAbility` é a factory recomendada hoje (equivalente ao antigo `new Ability(...)`).
- `PureAbility` é a classe-base sem matcher pré-configurado (usada para customização — ver `aliases-and-customization.md`).
- Código legado/exemplos antigos usando `import { Ability } from '@casl/ability'` ainda funcionam na maioria das versões 5/6, mas se o usuário estiver em versão mais nova e receber avisos de depreciação ou comportamento inesperado no matcher, oriente a migrar para `createMongoAbility`.
- Se o erro for do tipo "can sempre retorna false mesmo com regra aparentemente certa" **e** o projeto usa `Ability`/`PureAbility` "puro" sem matcher configurado, isso é esperado: `PureAbility` não vem com `conditionsMatcher`/`fieldMatcher` padrão — é preciso usar `createMongoAbility` ou fornecer os matchers manualmente.

## Alerta de segurança (prototype pollution — CVE-2026-1774)

Versões do `@casl/ability` anteriores à correção tinham uma vulnerabilidade de **prototype pollution** via `detectSubjectType`/`setByPath`, permitindo que um atacante poluísse `Object.prototype` (ex.: via condições com chaves como `__proto__.constructor.__proto__.modelName`) e forçasse a detecção de subject type para qualquer objeto, resultando em bypass de autorização. Corrigido na versão **6.7.5** com bloqueio de chaves perigosas (`__*`, `constructor`, `prototype`) em `setByPath`.

**Se o usuário reportar comportamento estranho de autorização envolvendo dados vindos de input externo (ex. condições montadas dinamicamente a partir de request body), ou estiver em versão antiga do pacote:**
- Recomende atualizar `@casl/ability` para >= 6.7.5 (ou versão v7 mais recente).
- Nunca construa `conditions` de uma regra CASL diretamente a partir de chaves de objeto controladas pelo usuário sem sanitização.

## Onde procurar mais informação

Ordem de prioridade ao investigar um erro que as referências desta skill não cobrem:
1. `ability.relevantRuleFor(action, subject)` para inspecionar qual regra decidiu o resultado (ver `debugging.md`).
2. Documentação oficial: https://casl.js.org/v7/en/guide/intro (nota: o site é uma SPA — para buscar ao vivo, prefira o conteúdo via GitHub, ex. `github.com/stalniy/casl`, cujos READMEs de pacote costumam trazer exemplos atualizados).
3. Repositório fonte: https://github.com/stalniy/casl — issues e discussions têm muitos casos reais de "por que minha regra não funciona".
4. Para pacotes específicos (Vue, Angular, Mongoose, Prisma, Aurelia), ver o README do respectivo pacote em `packages/casl-<nome>/README.md` no monorepo.
