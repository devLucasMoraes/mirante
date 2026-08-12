# Relatório — Contas a receber em aberto (Análise ABC)

> Validado em treino 11/08/2026 (empresa 1, carteira completa). Somente leitura.

## Pergunta de negócio
Categorizar a carteira de **contas a receber em aberto** em classes **A/B/C por concentração de
valor acumulado**, para direcionar o esforço de cobrança:
- **Classe A** — clientes que somam até **80%** do valor total (foco total de cobrança).
- **Classe B** — clientes seguintes até **95%**.
- **Classe C** — o restante (~5%), cobrança em lote/automatizada.

## Definições
- **Em aberto:** título a receber (`financeiro.ORIGEM='TOL_CONTASARECEBER'`) com `SALDO > 0`,
  `FLAGLANCCANCELADO<>'S'` e `ESTORNO<>'S'` (ou NULL). Inclui os títulos `PNJ01-OP*` (`DOC_ID=0`,
  gerados direto da OP sem documento faturado) — visão completa da carteira de cobrança.
- **Valor por cliente:** `SUM(financeiro.SALDO)` (restante a pagar), empresa `EMP_ID=1`.
- **Classificação:** ordenar clientes por saldo **descendente** e acumular até atingir 80% (A),
  depois 95% (B); o resto é C.
- **Corte exato da Classe A (validado):** primeiros **280 clientes** (rn 1 a 280) = **80,00%** do
  valor total.

## Script SQL — Classe A (280 clientes, foco total de cobrança)
```sql
SELECT x.cliente, x.nome, x.titulos, x.saldo, ROUND(x.cum/16922404.75*100,2) AS pct_acum, x.rn
FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT CODIGOPESSOA AS cliente, MAX(NOMEPESSOA) AS nome, COUNT(*) AS titulos,
               ROUND(SUM(SALDO),2) AS saldo
        FROM financeiro
        WHERE EMP_ID=1 AND ORIGEM='TOL_CONTASARECEBER' AND SALDO>0
          AND FLAGLANCCANCELADO<>'S' AND (ESTORNO<>'S' OR ESTORNO IS NULL)
        GROUP BY CODIGOPESSOA ORDER BY SUM(SALDO) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 280;
```

## Script SQL — resumo ABC da carteira
```sql
-- Totais por cliente (base para A/B/C)
SELECT CODIGOPESSOA AS cliente, MAX(NOMEPESSOA) AS nome, COUNT(*) AS titulos,
       ROUND(SUM(SALDO),2) AS saldo
FROM financeiro
WHERE EMP_ID=1 AND ORIGEM='TOL_CONTASARECEBER' AND SALDO>0
  AND FLAGLANCCANCELADO<>'S' AND (ESTORNO<>'S' OR ESTORNO IS NULL)
GROUP BY CODIGOPESSOA ORDER BY SUM(SALDO) DESC;

-- Totais da carteira
SELECT COUNT(DISTINCT CODIGOPESSOA) AS clientes, COUNT(*) AS titulos, ROUND(SUM(SALDO),2) AS saldo_total
FROM financeiro
WHERE EMP_ID=1 AND ORIGEM='TOL_CONTASARECEBER' AND SALDO>0
  AND FLAGLANCCANCELADO<>'S' AND (ESTORNO<>'S' OR ESTORNO IS NULL);
```

## Como reproduzir
```bash
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL>"
```
> `--default-character-set=utf8` é obrigatório para acentuação legível (banco latin1).

## Resultado validado — empresa 1 (11/08/2026)
| Métrica | Valor |
|---|---|
| Carteira total em aberto | **R$ 16.922.404,75** · 3.443 clientes · 16.314 títulos |
| **Classe A (≤ 80%)** | **280 clientes (~8,1% da base)** · **R$ 13.537.084,76** |
| Classe B (80–95%) | ~720 clientes (~R$ 2,54 mi) |
| Classe C (95–100%) | ~2.443 clientes (~R$ 0,85 mi) |

### Top 15 da Classe A
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 1 | 213 BAHIA ARTES GRAFICAS LTDA | 347 | 1.221.963,02 | 7,22 |
| 2 | 5120 G B SOUZA ME | 45 | 790.982,10 | 11,90 |
| 3 | 10816 NEWELL BRANDS BRASIL LTDA | 79 | 579.395,00 | 15,32 |
| 4 | 10234 ELEICAO 2024 JOSE RONALDO DE CARVALHO PREFEITO | 135 | 572.164,00 | 18,70 |
| 5 | 57 JOSE RONALDO DE CARVALHO SENADOR | 101 | 432.969,80 | 21,26 |
| 6 | 3682 GRÁFICA E EDITORA POLIKRON LTDA | 60 | 386.660,42 | 23,54 |
| 7 | 2917 BOMBONE INDUSTRIA E COMERCIO | 157 | 239.163,60 | 24,96 |
| 8 | 10248 ELEICAO 2024 EDSON ALMEIDA DE JESUS PREFEITO | 11 | 236.838,60 | 26,36 |
| 9 | 3716 LIMA SANTOS INDUSTRIA DE CONFECÇÕES LTDA | 62 | 224.288,15 | 27,68 |
| 10 | 5570 PLANTAO - CARTÃO DE VISITA | 111 | 209.749,44 | 28,92 |
| 11 | 174 EMGRAF EMPRESARIAL GRAFICA FEIRENSE LTDA | 73 | 198.256,84 | 30,09 |
| 12 | 443 GRAFICA PLANTÃO (LAMINAS) | 215 | 166.503,74 | 31,08 |
| 13 | 97 NOVAES RABELO COMÉRCIO DE PRODUTOS NATURAIS LTDA | 135 | 155.501,89 | 32,00 |
| 14 | 215 R. ESQUIVEL MORAES DA SILVA EDITORA LTDA | 2 | 155.488,30 | 32,91 |
| 15 | 844 ASSOCIAÇÃO REDE QUERO BAHIA | 153 | 150.122,78 | 33,80 |

### Final da Classe A (corte dos 80%)
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 275 | 4360 SABAO REAL INDUSTRIA COMÉRCIO LTDA. | 20 | 8.822,50 | 79,74 |
| 276 | 860 JOAO JACSON FREIRE SOARES | 13 | 8.785,36 | 79,79 |
| 277 | 636 SILVANI PEREIRA - HUGO SOUZA | 7 | 8.775,00 | 79,84 |
| 278 | 113 INDUSTRIA DE ALIMENTOS SAO MATHEUS LTDA EPP | 10 | 8.754,52 | 79,89 |
| 279 | 867 VALDEMAR JOSE DA SILVA PRUDENCIO DE JAGUARARI | 11 | 8.745,00 | 79,94 |
| 280 | 198 IVAN LOPES DE ARAUJO | 14 | 8.744,67 | **80,00** |

## Observações
- **Concentração real mais forte que o modelo teórico (20/30/50):** ~8,1% da base já responde por
  80% do valor. Para B/C, recomenda-se medir os cortes reais (80/95/100) em vez de proporção de clientes.
- **⚠️ Acumulado por variável (`@cum`):** acumular sobre o **valor bruto** (`saldo`), nunca sobre
  `pct` arredondado — arredondar cada linha antes de acumular infla/derruba o percentual e desloca
  o corte (testado: corte errado em ~261). O `LIMIT 280` fixo é seguro porque o rn 280 fecha
  exatamente em 80,00%.
- **Total geral:** `SUM(SALDO)` direto no financeiro (16.922.404,75) — 3.443 clientes incluem
  saldos residuais de centavos (limpar em uma análise de cobrança).
- **Cliente:** `CODIGOPESSOA`/`NOMEPESSOA` vêm do próprio `financeiro` (não precisa de join em
  `documentocabecalho`); `CODIGOPESSOA` = `pessoa.PES_ID`.
- **Diferença para `contas-a-receber-em-aberto.md`:** aquele relatório é **por cliente** e exclui
  `DOC_ID=0`; este é **por carteira** (agregado) e **inclui** `PNJ01-OP*`. Para o detalhe por
  documento de um cliente da Classe A, usar o relatório por cliente.
- **Saldos residuais:** clientes com títulos de R$ 0,01–0,10 existem (lixo a baixar) — na Classe C.
