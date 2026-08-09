# Debugging e testes

`can`/`cannot` só devolvem boolean — para saber **qual regra** decidiu o resultado, use `relevantRuleFor`:

```js
const rule = ability.relevantRuleFor('read', article);
rule?.conditions   // condições da regra que bateu
rule?.fields        // campos da regra que bateu
rule?.reason        // mensagem de .because(...), se houver
// retorna null se nenhuma regra combina com essa action/subject
```

```js
cannot('read', 'Article', { private: true }).because('Conteúdo privado protegido por lei');
// depois:
ability.relevantRuleFor('read', subject('Article', { private: true })).reason;
```

Se o projeto tem `detectSubjectType` customizado (comum, ver `subject-type-detection.md`) e os objetos de entidade já carregam o campo discriminador esperado, `relevantRuleFor` funciona diretamente sem precisar do helper `subject()`.

## Checklist de troubleshooting (ordem de investigação)

1. **`ability.relevantRuleFor(action, subject)`** — retorna `null`? Nenhuma regra bate nesse par action/subject; confira se a função que define permissões para essa role/usuário realmente inclui essa permissão.
2. Retorna uma regra mas o resultado ainda parece errado? Inspecione `rule.conditions` — compare campo a campo com o objeto que está sendo checado.
3. Suspeita de problema de subject type? Vá para `subject-type-detection.md`.
4. Suspeita de problema de ordem de regras (`cannot` sendo ignorado)? Vá para `define-rules.md`.

## Sobre testes

**Não teste a lista de regras geradas (implementação)** — teste o resultado de `ability.can(...)` para casos concretos de negócio. A mesma política pode ser expressa com combinações diferentes de regras; testar a "forma" das regras quebra a cada refactor sem mudar o comportamento real.

```js
// ❌ Ruim: testa detalhe de implementação
expect(defineRulesFor(user)).to.deep.equal([{ action: 'manage', subject: 'all' }]);

// ✅ Bom: testa o comportamento observável
describe('quando o usuário é regular (não admin)', () => {
  const ability = defineAbilityFor({ isAdmin: false, id: '1' });

  it('pode ler artigos mas não deletar artigos publicados', () => {
    expect(ability.can('read', 'Article')).toBe(true);
    expect(ability.can('delete', article({ published: true }))).toBe(false);
  });
});
```
