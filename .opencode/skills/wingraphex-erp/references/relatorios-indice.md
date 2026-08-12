# Relatórios — base de conhecimento validada

Registro de relatórios do Wingraphex **validados em treino** (o usuário confirma o resultado antes
de cristalizar). Um arquivo por relatório em `relatorios/`.

## Como consultar
- Pedido de relatório → **procurar aqui primeiro**. Se existir, usar o SQL validado (já resolve
  cortes/armadilhas conhecidas — não repita a análise do zero).
- Se não existir: montar o SQL com base no conhecimento (`regras-de-negocio.md`,
  `esqueleto-schema.md`, `modulo-*.md`, `schema-wingraphex.sql`), executar **somente leitura** e
  apresentar o resultado real.
- Banco: `wingraphex` em `192.168.1.16:3307`, usuário `_consulta`, senha em `senha.txt`
  (gitignored, nunca colar em texto puro).
- Sempre usar `--default-character-set=utf8` (banco é latin1 — sem isso a acentuação quebra).

## Formato padrão de cada arquivo em `relatorios/`
1. **Pergunta de negócio** que o relatório responde
2. **Definições** — critérios exatos usados (ex.: o que é "em aberto", qual campo de valor)
3. **Script SQL** validado
4. **Como reproduzir** — comando completo
5. **Resultado validado** — amostra real com o cliente/escopo usado no treino
6. **Observações** — armadilhas, exceções, variantes, como distinguir casos

## Fluxo de validação
- Acertou → cristalizar (novo arquivo `relatorios/<nome>.md`, atualizar a tabela abaixo).
- Errou → perguntar ao usuário o que ficou ambíguo, corrigir e só então salvar.

## Índice
| Relatório | Arquivo | Status | Resumo em 1 linha |
|---|---|---|---|
| OPs em aberto por cliente | `relatorios/ops-em-aberto.md` | validado 11/08/2026 (cliente 5011) | Lista OPs com saldo>0 de um cliente, incl. OPs "fantasma" nunca faturadas |
| OPs em aberto — Análise ABC | `relatorios/ops-em-aberto-abc.md` | validado 11/08/2026 (carteira empresa 1) | Classifica clientes A/B/C por saldo-valor de produção acumulado |
| Contas a receber em aberto por cliente | `relatorios/contas-a-receber-em-aberto.md` | validado 11/08/2026 (clientes 5011, 267, 606) | Lista títulos não baixados de um cliente, com NF/vencimento/saldo |
| Contas a receber — Análise ABC (carteira completa) | `relatorios/contas-a-receber-abc.md` | validado 11/08/2026 (carteira empresa 1) | ABC de todo `financeiro` em aberto, inclui títulos sem documento (PNJ01-OP*) |
| Contas a receber — ABC (só faturados CI + NF série 1) | `relatorios/contas-a-receber-abc-ci.md` | validado 11/08/2026 (carteira empresa 1) | Mesmo ABC, restrito a títulos com documento fiscal emitido; tem export CSV |
| Contas a receber — ABC (CI + série 1, últimos 3 anos) | `relatorios/contas-a-receber-abc-ci-3-anos.md` | validado 11/08/2026 (carteira empresa 1) | Mesmo escopo anterior + filtro de emissão nos últimos 3 anos; tem export CSV |
| Consulta de OPs por descrição (financeiro + PCP) | `relatorios/consulta-ops-por-descricao.md` | validado 11/08/2026 (cliente 5011) | Busca OP por texto/cliente/data trazendo saldo produção + saldo financeiro + resumo PCP |

## Quando usar qual variante de "contas a receber ABC"
- Precisa da carteira **inteira** (inclusive títulos gerados direto da OP sem NF/CI) → `contas-a-receber-abc.md`.
- Precisa só do que já foi **faturado** (documento fiscal existe) → `contas-a-receber-abc-ci.md`.
- Precisa de uma visão **recente** (cobrança operacional, não dívida histórica) → `contas-a-receber-abc-ci-3-anos.md`.
