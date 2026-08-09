# Integração com React (`@casl/react`)

```jsx
import { createMongoAbility } from '@casl/ability';
import { AbilityProvider, Can, useAbility } from '@casl/react';

const ability = createMongoAbility([
  { action: 'read', subject: 'Post' },
  { action: 'create', subject: 'Post' },
]);

function App() {
  return (
    <AbilityProvider value={ability}>
      <Can I="read" a="Post">
        <div>Lista de posts</div>
      </Can>
      <CreatePostButton />
    </AbilityProvider>
  );
}

function CreatePostButton() {
  const ability = useAbility();
  return ability.can('create', 'Post') && <button>Criar Post</button>;
}
```

- `<Can>` → ideal para renderização condicional simples e legível no JSX. O nome do componente e das props forma quase uma frase em inglês: `<Can I="create" a="Post">` lê-se "Can I create a Post".
- `useAbility()` → ideal quando a checagem faz parte de lógica mais complexa, ou é combinada com outros estados.
- Padrão legado (exemplos antigos) usa `AbilityContext` criado manualmente com `React.createContext` + `useAbility(AbilityContext)` — se o usuário mostrar código assim, é compatível, apenas mais verboso que `AbilityProvider`.
- Se as regras mudam em runtime (ex. após login), chame `ability.update(newRules)` — componentes que leem via `useAbility`/`<Can>` re-renderizam automaticamente.
- Qualquer instância de `Ability`/`MongoAbility`, não importa como foi construída (via `AbilityBuilder`, raw rules, ou derivada de schemas Zod — ver `casl-zod-pattern.md`), pode ser passada diretamente para `<AbilityProvider value={ability}>` sem adaptação extra.
