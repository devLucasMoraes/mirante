# Definindo regras (can/cannot)

## As 3 formas de definir abilities

| Forma | Quando usar |
|---|---|
| `defineAbility((can, cannot) => {...})` | Testes unitários, exemplos, protótipos. **Não recomendado para produção** (menos flexível para customizar matcher). |
| `new AbilityBuilder(createMongoAbility)` + `can`/`cannot`/`build()` | **Forma recomendada** em produção, especialmente com lógica condicional (`if (user.isAdmin) can(...)`). |
| Array de objetos JSON (raw rules) passado direto pro construtor | Permissões dinâmicas vindas do backend/banco de dados, ou para reduzir bundle size (tree-shaking). |

```js
// AbilityBuilder — forma recomendada
import { AbilityBuilder, createMongoAbility } from '@casl/ability';

function defineAbilityFor(user) {
  const { can, cannot, build } = new AbilityBuilder(createMongoAbility);

  if (user.isAdmin) {
    can('manage', 'all'); // 'manage' e 'all' são coringas especiais
  } else {
    can('read', 'all');
    cannot('delete', 'Post', { published: true });
  }

  return build();
}
```

```js
// Raw rules (JSON) — regras vindas de rede/DB
const ability = createMongoAbility([
  { action: 'read', subject: 'Post' },
  { inverted: true, action: 'delete', subject: 'Post', conditions: { published: true } },
]);
```

Forma da raw rule:
```ts
interface RawRule {
  action: string | string[];
  subject?: string | string[];
  fields?: string[];       // campos permitidos/negados
  conditions?: any;        // query estilo MongoDB
  inverted?: boolean;      // true = regra de "cannot"
  reason?: string;         // mensagem explicando o "cannot"
}
```

## Semântica de combinação de regras (fonte comum de bugs)

- Múltiplas regras `can` para o mesmo par (action, subject) se combinam com **OR**.
- Regras `cannot` (inverted) restringem regras `can` anteriores com **AND** — mas **a ordem importa**: defina regras gerais primeiro, específicas (inclusive `cannot`) depois. Se um `can('manage','all')` vier *depois* de um `cannot`, o `cannot` é sobrescrito.
- Boa prática: prefira regras diretas (`can`) a regras invertidas (`cannot`) sempre que possível — é mais fácil de raciocinar e reduz risco de dar permissão errada. Lembre-se: "dê permissões, não as retire".

Exemplo do problema de ordem:
```js
can('read', 'Article'); // regra geral
cannot('read', 'Article', { published: false }); // restringe — deve vir DEPOIS

// Se invertido (cannot antes do can geral), o cannot é sobrescrito e published:false
// também vira legível — bug silencioso.
```

## Usando `.because()` para regras invertidas

```js
cannot('create', 'BlogPost').because('Você não pagou a assinatura mensal');
```
Isso preenche `rule.reason`, útil para debugging e para mostrar mensagens de erro amigáveis (ver `debugging.md`).
