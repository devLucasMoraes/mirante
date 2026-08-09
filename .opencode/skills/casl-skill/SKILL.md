---
name: casljs
description: Use esta skill sempre que o usuário estiver trabalhando com CASL.js (@casl/ability, @casl/react, ou outros pacotes @casl/*) — definindo regras de autorização (can/cannot), integrando com React (AbilityContext, useAbility, <Can>), depurando por que uma permissão retorna false inesperadamente, restringindo campos, usando condições estilo MongoDB, definindo aliases de ação, customizando matchers de condições/campos, configurando TypeScript com CASL, ou tipando subjects com Zod. Aciona também em erros comuns como "ability.can sempre retorna false", "subject type not detected", problemas com detectSubjectType, ou dúvidas sobre a diferença entre Ability/PureAbility/createMongoAbility.
---

# CASL.js — Guia de Referência Rápida

CASL é uma biblioteca isomórfica de autorização (ACL/ABAC/RBAC) para JavaScript/TypeScript. Modelo mental central: uma permissão é a tupla **(action, subject, fields?, conditions?)**, testada via `ability.can(action, subject)` / `ability.cannot(...)`.

> Regra de ouro: quando o usuário reportar um bug de permissão ("retorna false mas deveria ser true", "não consigo restringir campo X"), **primeiro** vá para `references/subject-type-detection.md` e `references/debugging.md` antes de propor mudanças de código — é de longe a causa mais comum.

## Índice de referências (leia sob demanda, não tudo de uma vez)

| Arquivo | Quando ler |
|---|---|
| `references/define-rules.md` | Como escrever regras (`can`/`cannot`), as 3 formas de definir abilities, semântica de combinação (OR/AND, ordem importa). |
| `references/conditions-and-fields.md` | Condições estilo MongoDB (ABAC) e restrição de campos (field-level permissions). |
| `references/subject-type-detection.md` | **Leia isto primeiro se `can()` retorna `false` inesperadamente.** Causa nº 1 de bugs de permissão. |
| `references/debugging.md` | `relevantRuleFor`, como testar permissões corretamente, checklist de troubleshooting. |
| `references/aliases-and-customization.md` | `createAliasResolver`, operadores customizados, matchers customizados. |
| `references/typescript.md` | Tipagem genérica de `Ability`, `InferSubjects`, erros comuns de tipo (`ForcedSubject`). |
| `references/casl-zod-pattern.md` | Técnica opcional: usar Zod como fonte da verdade para tipar/validar subjects em vez de interfaces TS puras, e como consumir a ability numa rota HTTP (checagem antes de efeitos colaterais, erro de domínio). Útil em projetos que já usam Zod. |
| `references/react-integration.md` | `@casl/react`: `AbilityProvider`, `<Can>`, `useAbility`. |
| `references/security-and-versioning.md` | `Ability` → `createMongoAbility` (nomenclatura atual), CVE de prototype pollution, cuidados com input externo. |

## Fluxo de decisão rápido

1. **`ability.can()` retorna resultado errado?** → `references/subject-type-detection.md` → depois `references/debugging.md`
2. **Preciso restringir por atributo (ex: só o dono pode editar) ou por campo?** → `references/conditions-and-fields.md`
3. **Vou definir regras/roles do zero?** → `references/define-rules.md`
4. **O projeto usa (ou eu quero usar) Zod para validar as mesmas entidades que aparecem nas permissões?** → `references/casl-zod-pattern.md`
5. **Vou integrar com componentes React?** → `references/react-integration.md`
6. **Erro de tipo do TypeScript envolvendo CASL?** → `references/typescript.md`
7. **Dúvida sobre nome de import (`Ability` vs `createMongoAbility` vs `PureAbility`)?** → `references/security-and-versioning.md`
