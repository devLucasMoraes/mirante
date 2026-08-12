---
name: wingraphex-erp
description: Use this skill for any task involving the Wingraphex ERP database (MySQL, host 192.168.1.16:3307, database "wingraphex") — building SQL reports/queries, understanding business flow (Orçamento → OP → PCP → Faturamento → Financeiro), looking up table/column meaning, or reproducing/extending a known validated report. Triggers on mentions of Wingraphex, OP/ordem de produção, orçamento gráfico, faturamento CI/NF, contas a receber, PCP offset plana, or any table name from this schema (ordemservico, documentocabecalho, financeiro, qtorcamento, pcpprocessos, etc).
---

# Wingraphex ERP — Conhecimento e Relatórios

Base de conhecimento acumulada por engenharia reversa (somente leitura) do ERP
Wingraphex (gráfica/offset plana, MySQL 5.7.26, 558 tabelas, ~5,1 GB).
Este SKILL.md é só o roteador — leia apenas o(s) arquivo(s) de `references/`
relevante(s) para a tarefa atual, não todos.

## Regra de ouro (sempre vale, todo contexto)

- **Acesso ao banco é ESTRITAMENTE SOMENTE LEITURA.** Nunca gerar/executar
  INSERT, UPDATE, DELETE, TRUNCATE, CREATE, ALTER, DROP. Só SELECT, SHOW,
  `information_schema`.
- Comando padrão de execução:
  ```bash
  MYSQL_PWD="$(awk -F'= ' '/senha/{print $2}' senha.txt)" \
  mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL>"
  ```
  `--default-character-set=utf8` é **obrigatório** (banco é latin1, sem isso acentuação quebra).
  Nunca colar a senha em texto puro — ler de `senha.txt` (fora do controle de versão).
- Sem FKs declaradas no banco — todo relacionamento é por convenção de chave
  (colunas com índice MUL). Ver `references/esqueleto-schema.md` para o mapa.
- `EMP_ID` sempre no WHERE (empresas 1 e 2, cadastros duplicados) — sem isso
  os resultados duplicam.
- Datas: banco costuma usar `1899-12-30` como "não preenchido" em vez de NULL
  em alguns campos de baixa financeira — atenção ao filtrar por data.

## Como decidir o que ler

1. **Pedido de relatório/consulta de negócio** (contas a receber, OPs em
   aberto, análise ABC, consulta por descrição, etc.)
   → primeiro leia `references/relatorios-indice.md`. Se o relatório já
   existe lá, use o SQL validado diretamente (ele já tem os cortes/armadilhas
   resolvidos) — não repita o trabalho de análise.

2. **Relatório novo, não listado** → leia:
   - `references/regras-de-negocio.md` (fluxo, chaves, fórmulas, status)
   - o(s) módulo(s) relevante(s) em `references/modulo-*.md`
   - se precisar de nome exato de tabela/coluna, `references/esqueleto-schema.md`
     e, em último caso, grep no `references/schema-wingraphex.sql` (DDL completo,
     13k linhas — não carregar inteiro, buscar a tabela específica)
   - depois de validado com o usuário, **cristalizar** um novo arquivo em
     `references/relatorios/<nome>.md` seguindo o formato do índice, e
     adicionar a linha correspondente em `references/relatorios-indice.md`

3. **Dúvida sobre o que uma tabela/coluna significa** → busque primeiro em
   `references/esqueleto-schema.md` (mapa por módulo). Se não estiver lá,
   grep no schema:
   ```bash
   grep -A 40 "CREATE TABLE \`nome_tabela\`" references/schema-wingraphex.sql
   ```

4. **Pergunta sobre um módulo específico** (Orçamento, Faturamento,
   Financeiro, PCP) em profundidade — colunas-chave, exemplos reais,
   fórmulas, parâmetros → leia `references/modulo-<nome>.md` correspondente.

5. **Pergunta sobre infraestrutura** (rede, acesso ao MySQL, credenciais) →
   `references/infra-acesso.md`.

6. **Ambiente local/Docker** (testar SQL sem tocar produção, subir réplica, regenerar amostra de
   dados) → `references/ambiente-docker-local.md`. Os arquivos brutos ficam em
   `wingraphex-docker/` (raiz da skill, irmã de `references/`) — nunca ler
   `wingraphex-docker/initdb/01-schema.sql` ou `02-dados.sql` inteiros (627 KB / 4 MB); usar grep
   ou consultar via `mysql` no container local.

## Mapa de references/

| Arquivo | Conteúdo |
|---|---|
| `regras-de-negocio.md` | Fluxo fim a fim, chaves entre módulos, fórmula de precificação, 12 status de OP, faturamento CI vs NF, financeiro/baixa, problema de retirada/entrega, dimensões gerais do negócio |
| `esqueleto-schema.md` | Mapa das 558 tabelas por módulo, ligações-chave verificadas, tabelas de maior porte, notas de risco/infra do banco |
| `modulo-orcamento.md` | Estrutura de tabelas `orc*`/`qtorcamento`/`flexoorc*`, fórmula de precificação, ciclo de vida (log), achado de margem negativa |
| `modulo-faturamento.md` | `documentocabecalho`/`documentoitem`/etc., série CI vs NF série 1, comissões, tipos de documento, parâmetros |
| `modulo-financeiro.md` | Tabela `financeiro` (título↔baixa), formas/meios de pagamento, cheques, bancos/carteiras, parâmetros |
| `modulo-pcp.md` | Programação (`pcptrabalhos`/`pcpprocessos`/`pcpapontamento`), status de processo, lacuna de expedição/entrega |
| `relatorios-indice.md` | Índice + resumo de cada relatório SQL já validado (aponta para `relatorios/*.md`) |
| `relatorios/*.md` | Um arquivo por relatório validado: pergunta de negócio, definições, SQL completo, resultado real, armadilhas |
| `infra-acesso.md` | Rede (portas, IP), acesso MySQL de produção, ferramentas locais, protocolo de registro |
| `ambiente-docker-local.md` | Réplica Docker local (MySQL 5.7.26, porta 3308), como subir/regenerar, quando usar local vs produção |
| `schema-wingraphex.sql` | DDL bruto completo de produção (mysqldump --no-data), 558 tabelas — usar via grep, nunca ler inteiro |

## wingraphex-docker/ (raiz da skill — arquivos brutos do ambiente local)

| Arquivo | Conteúdo |
|---|---|
| `wingraphex-docker/docker-compose.yml` | Serviço MySQL 5.7.26 (porta host 3308) |
| `wingraphex-docker/.env.example` | Modelo de variáveis (copiar para `.env`, nunca commitar) |
| `wingraphex-docker/initdb/01-schema.sql` | Schema completo (557 tabelas), sem dados — **grande, não ler inteiro** |
| `wingraphex-docker/initdb/02-dados.sql` | Amostra real de dados (42 tabelas) — **grande, não ler inteiro** |
| `wingraphex-docker/scripts/extrai-dados.sh` | Gera `02-dados.sql` a partir da produção (somente leitura) — pequeno, pode ler direto se precisar ver os filtros exatos |

## Protocolo de aprendizado (registro de novas descobertas)

Ao testar/confirmar algo novo (acesso, comportamento de tabela, relatório
validado), registrar no arquivo `.md` correspondente ao assunto:
- Um arquivo por assunto; assunto novo = novo arquivo em `references/`.
- Formato de entrada datada:
  ```md
  ## YYYY-MM-DD - <síntese do que foi verificado>
  - **O que foi testado:** ...
  - **Resultado:** funciona / não funciona / parcial
  - **Como reproduzir:** ...
  - **Observações:** ...
  ```
- Nunca salvar senha/chave em texto puro — só referenciar onde está.
- Relatório validado pelo usuário → cristalizar em `references/relatorios/<nome>.md`
  e atualizar `references/relatorios-indice.md`.
