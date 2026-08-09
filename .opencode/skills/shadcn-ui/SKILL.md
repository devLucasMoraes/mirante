---
name: shadcn-ui
description: Conhecimento profundo de componentes, padrões e boas práticas do shadcn/ui. Use sempre que o usuário pedir para adicionar, criar, customizar ou trabalhar com componentes de UI em um projeto que usa (ou vai usar) shadcn/ui — ex. "adicione um formulário de login", "crie uma dashboard com sidebar e data table", "troque para o preset X", "adicione um hero do @tailark". Ativa quando existe um components.json no projeto ou quando o usuário menciona shadcn/ui explicitamente.
---

# shadcn/ui

Esta skill dá ao agente conhecimento equivalente à skill oficial `shadcn/ui`
(instalável via `pnpm dlx skills add shadcn/ui`, ver https://ui.shadcn.com/docs/skills),
adaptada para rodar como skill nativa do OpenCode (`.opencode/skills/shadcn-ui/SKILL.md`).

O shadcn/ui não é uma biblioteca de componentes tradicional — é código que é
copiado para dentro do projeto (Open Code), composto a partir de primitivas
acessíveis (Radix ou Base UI ou React Aria), estilizado com Tailwind CSS, e
distribuído via CLI + registries.

## Passo 0 — Detectar o projeto

Antes de qualquer coisa, verifique se existe um `components.json` na raiz do
projeto (ou em um workspace, em caso de monorepo).

- Se existir: rode `npx shadcn info --json` (ou `pnpm dlx` / `bunx`, conforme o
  gerenciador de pacotes do projeto) para carregar a configuração real:
  framework, versão do Tailwind, aliases de import, base library (`base`,
  `radix` ou `aria`), biblioteca de ícones, componentes já instalados e os
  caminhos resolvidos dos arquivos. Use essas informações para gerar código
  compatível com o projeto na primeira tentativa — não assuma caminhos ou
  aliases genéricos.
- Se não existir: pergunte ao usuário se deseja inicializar o shadcn/ui no
  projeto (`npx shadcn init`) antes de prosseguir, ou ofereça para rodar você
  mesmo.

## Comandos da CLI

Referência completa da CLI `shadcn`:

| Comando | Uso |
|---|---|
| `shadcn init` | Inicializa o shadcn/ui no projeto (cria `components.json`, configura Tailwind, aliases) |
| `shadcn add <component>` | Instala um ou mais componentes (`shadcn add button card`) |
| `shadcn search <query>` | Busca componentes em registries configurados |
| `shadcn view <component>` | Mostra o código-fonte de um componente antes de instalar |
| `shadcn docs <component>` | Mostra a documentação de uso de um componente |
| `shadcn diff <component>` | Mostra diferenças entre a versão instalada e a upstream |
| `shadcn info --json` | Retorna a configuração resolvida do projeto (framework, aliases, base, ícones, componentes instalados) |
| `shadcn build` | Constrói um registry customizado (`registry.json` → itens publicáveis) |

Flags úteis: `--dry-run` (simula sem escrever arquivos), `--overwrite`,
`--yes`, `--path` (subpasta em monorepo), `--preset` (aplica um preset
nomeado de tema/estilo), e a possibilidade de referenciar registries
externos com `@nome` (ex.: `shadcn add @tailark/hero-01`).

Sempre prefira `shadcn add` a copiar/colar código manualmente — isso garante
que dependências, variantes CSS e arquivos de suporte sejam instalados
corretamente.

## Regras de composição

Ao gerar UI com shadcn/ui, siga os padrões oficiais de composição em vez de
HTML/CSS cru:

- **Formulários**: usar `Field` / `FieldGroup` (ou `FormField` do
  `react-hook-form`/`TanStack Form`/Formisch quando o projeto já usa uma
  dessas libs) em vez de `<label>` + `<input>` soltos.
- **Grupos de opções**: usar `ToggleGroup`, `RadioGroup` ou `Select`
  conforme a semântica (seleção múltipla vs. única, poucas vs. muitas opções).
- **Cores**: usar tokens semânticos do tema (`bg-background`,
  `text-foreground`, `bg-primary`, `text-muted-foreground`, etc.) em vez de
  cores Tailwind arbitrárias (`bg-gray-100`), para respeitar dark mode e o
  tema do projeto.
- **Base library correta**: a API interna dos componentes varia conforme a
  base configurada no `components.json` (`base`, `radix` ou `aria`) — usar a
  API correspondente detectada em vez de assumir Radix por padrão.
- **Ícones**: usar a biblioteca de ícones já configurada no projeto (ex.
  `lucide-react`), não misturar bibliotecas diferentes.
- **Antes de gerar código de um componente não confirmado**, rodar
  `shadcn docs <component>` ou `shadcn search <component>` (ou usar o MCP
  server, se configurado) para conferir a API atual em vez de confiar
  apenas na memória — a API pode ter mudado desde o treinamento.

## Tematização

- Cores são definidas via variáveis CSS em formato OKLCH (Tailwind v4) ou
  HSL (Tailwind v3, legado).
- Dark mode é feito trocando o conjunto de variáveis CSS na classe `.dark`
  (ou `data-theme`), não duplicando componentes.
- Border radius, espaçamento e variantes de componente também são
  controlados por variáveis CSS/tokens no `globals.css` (ou equivalente) —
  editar ali, não fazer overrides pontuais no componente.
- Presets nomeados podem ser aplicados via `shadcn add --preset <CODE>` ou
  conforme pedido pelo usuário ("troque para o preset X").

## Registries customizados

Quando o usuário pedir para publicar ou consumir um registry próprio:

- Um registry é descrito por um `registry.json` (índice) e um ou mais
  `registry-item.json` (itens individuais: componente, hook, página, tema).
- Itens declaram `files`, `dependencies`, `registryDependencies`,
  variáveis CSS e metadata.
- `shadcn build` gera os artefatos publicáveis a partir do `registry.json`.
- Registries podem ser hospedados estaticamente (inclusive via GitHub) e
  consumidos com `shadcn add @namespace/item`.

## MCP Server (se configurado)

Se o projeto/ambiente tiver o MCP server do shadcn configurado, prefira usar
as tools do MCP (busca, browse e instalação de componentes de registries)
em vez de scraping manual de documentação — elas retornam dados
estruturados e atualizados. Ver https://ui.shadcn.com/docs/mcp.

## Referências

- Documentação de componentes: https://ui.shadcn.com/docs/components
- CLI: https://ui.shadcn.com/docs/cli
- components.json: https://ui.shadcn.com/docs/components-json
- Theming: https://ui.shadcn.com/docs/theming
- Registry: https://ui.shadcn.com/docs/registry
- Skills (origem desta skill): https://ui.shadcn.com/docs/skills
- llms.txt (mapa completo de docs): https://ui.shadcn.com/llms.txt