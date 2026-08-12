# Relatório — Contas a receber em aberto (por cliente)

> Validado em treino 11/08/2026 (clientes **5011** JHONY'S PIZZA, **267** JEANE MALTA DOS SANTOS,
> **606** FX ESCRITÓRIO DE REPRESENTAÇÕES). Somente leitura.

## Pergunta de negócio
Listar as **contas a receber** de um cliente: documentos faturados (CI/NF) cujo título financeiro
**ainda não foi baixado** (`SALDO > 0`), com NF, vencimento, entrega, contato, forma de pagamento,
quantidade, valor unitário, descrição, valor e **saldo (o que falta pagar)**, mais o **total geral**.

## Definições e aprendizado-chave
- **O relatório é centrado no DOCUMENTO faturado** (`documentocabecalho`), **NÃO no título do
  financeiro**. Ligação: `financeiro.DOC_ID` + `CLASSIFICACAO` = `documentocabecalho.DOC_ID` + `CLASSIFICACAO`.
- **Títulos `PNJ01-OP*` (`DOC_ID=0`)** — gerados direto da OP, sem documento faturado — **ficam de
  fora** (o relatório do sistema também não os mostra).
- **Saldo** = `financeiro.SALDO` (restante a pagar do título). Título com baixa parcial fica com
  saldo parcial (ex.: título 256066 de 1.200 com baixa de 600 → saldo 600).
- **Total geral = `SUM(f.SALDO)` direto no financeiro** — **não somar** a coluna repetida nas linhas
  de item.
- Documentos com **vários itens repetem valor/saldo do título em cada linha** (é **um título por documento**).

## Script SQL — detalhe por item
```sql
SELECT
  dc.NUMERONF            AS nf,
  dc.SERIENF             AS serie,
  DATE(dc.DATAENTREGA)   AS entrega,
  DATE(f.DATAVENCIMENTO) AS vencimento,
  c.CON_NOME             AS contato,
  fop.FOP_DESCRICAO      AS forma_pagto,
  di.QUANTIDADE          AS quantidade,
  di.VALORUNITARIO       AS valor_unitario,
  di.DESCRICAOITEM       AS descricao,
  f.VALOR                AS valor,
  f.SALDO                AS saldo
FROM documentocabecalho dc
JOIN documentoitem di ON di.EMP_ID=dc.EMP_ID AND di.CLASSIFICACAO=dc.CLASSIFICACAO AND di.DOC_ID=dc.DOC_ID
JOIN financeiro f ON f.EMP_ID=dc.EMP_ID AND f.CLASSIFICACAO=dc.CLASSIFICACAO AND f.DOC_ID=dc.DOC_ID
  AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
LEFT JOIN contato c ON c.EMP_ID=dc.EMP_ID AND c.PES_ID=dc.CODIGOPESSOA AND c.CON_ID=dc.CODIGOCONTATOPESSOA
LEFT JOIN formapagto fop ON fop.EMP_ID=dc.EMP_ID AND fop.FOP_ID=dc.CODIGOFORMAPAGTO
WHERE dc.EMP_ID=1 AND dc.CODIGOPESSOA='<CLI_ID>' AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
ORDER BY dc.NUMERONF;
```

## Script SQL — total geral
```sql
SELECT ROUND(SUM(f.SALDO),2) AS saldo_total
FROM documentocabecalho dc
JOIN financeiro f ON f.EMP_ID=dc.EMP_ID AND f.CLASSIFICACAO=dc.CLASSIFICACAO AND f.DOC_ID=dc.DOC_ID
  AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
WHERE dc.EMP_ID=1 AND dc.CODIGOPESSOA='<CLI_ID>' AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S';
```

## Como reproduzir
```bash
MYSQL_PWD="$(awk -F'= ' '/senha/{print $2}' senha.txt)" \
mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL>"
```
> `--default-character-set=utf8` é obrigatório para acentuação legível (banco latin1).

## Resultado validado
### 5011 — JHONY'S PIZZA (1 CI)
| NF | Entrega | Vencimento | Contato | Forma | Qtd | Valor unit. | Valor | Saldo |
|---|---|---|---|---|---|---|---|---|
| 207427 | 13/04/2026 | 13/05/2026 | JHONY 75 98135-9123 | PROMISSORIA | 4.000 | 0,30 | 1.200,00 | **600,00** |

**Total: R$ 600,00** (baixa parcial de 600)

### 267 — JEANE MALTA DOS SANTOS (2 CIs)
| NF | Entrega | Vencimento | Contato | Forma | Qtd | Valor unit. | Valor | Saldo |
|---|---|---|---|---|---|---|---|---|
| 186015 | 09/11/2020 | 09/12/2020 | JEANE | PROMISSORIA | 60.000 | 0,1498 | 8.988,00 | **6.988,00** |
| 207937 | 21/07/2026 | 21/07/2026 | JEANE | A VISTA - ESPECIE | 1.000 | 0,059 | 59,00 | **29,00** |

**Total: R$ 7.017,00**

### 606 — FX ESCRITÓRIO DE REPRESENTAÇÕES (6 CIs, 8 itens)
NFs 199878 (52), 200033 (104, 2 itens), 203080 (104, 2 itens), 204485 (59), 204871 (118), 205873
(59) — contato sidnei de lima carvarlho.
**Total: R$ 496,00** — atenção: CIs 200033/203080 têm 2 itens cada e o título (104) repete nas
linhas; o total correto vem de `SUM(SALDO)` (52+104+104+59+118+59).

## Observações
- **Filtros:** `ORIGEM='TOL_CONTASARECEBER'`, `SALDO>0`, `FLAGLANCCANCELADO<>'S'`, `ESTORNO<>'S'`,
  `CLASSIFICACAO=0` (NF), `CANCELADA<>'S'`. Previsões (`PREVISAO='S'`) vinculadas a OP (`DOC_ID=0`)
  ficam de fora por não terem documento.
- `NUMERONF` = número da CI/NF (`NUMERODOCUMENTO` fica NULL na prática).
- Contato: `contato` (`PES_ID`+`CON_ID`); forma de pagamento: `formapagto` (`FOP_ID`).
- Excluir estorno/cancelado: título 78031 (1.720, estorno) não é dívida real.
