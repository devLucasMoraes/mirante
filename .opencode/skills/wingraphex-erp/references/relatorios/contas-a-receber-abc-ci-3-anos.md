# Relatório — Contas a receber em aberto (Análise ABC — faturados CI + NF série 1, notas dos últimos 3 anos)

> Validado em treino 11/08/2026 (empresa 1). Somente leitura. Variante do `contas-a-receber-abc-ci.md`
> restrita a **notas emitidas nos últimos 3 anos** (`documentocabecalho.DATAEMISSAO >= hoje - 3 anos`)
> e **séries CI e 1** explicitamente. Com opção de exportação CSV (Classe A).

## Pergunta de negócio
Análise ABC (cobrança por concentração de valor) das **contas a receber em aberto** de documentos
**faturados** — **CI** (Conta Interna) e **NF série 1** (NF-e SEFAZ) — considerando **somente notas
emitidas nos últimos 3 anos** (carteira "recente"). Classes por valor acumulado:
- **Classe A** — clientes até **80%** do valor total (foco total de cobrança).
- **Classe B** — até **95%**.
- **Classe C** — o restante (~5%).

## Definições
- **Em aberto:** `financeiro.ORIGEM='TOL_CONTASARECEBER'`, `SALDO > 0`, `FLAGLANCCANCELADO<>'S'`,
  `ESTORNO<>'S'` (ou NULL), empresa `EMP_ID=1`.
- **Faturado:** título vinculado a documento via `documentocabecalho` (`CLASSIFICACAO=0` = NF,
  `CANCELADA<>'S'`), **séries `CI` e `1`** (`dc.SERIENF IN ('CI','1')`). Exclui títulos sem
  documento (`PNJ01-OP*`, `DOC_ID=0`) e documentos cancelados.
- **Últimos 3 anos:** `dc.DATAEMISSAO >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)` (data de emissão da
  nota; em 11/08/2026 = emitidas a partir de 11/08/2023).
- **Valor por cliente:** `SUM(financeiro.SALDO)` (restante a pagar), agregado por `CODIGOPESSOA`.
- **Cortes exatos (validados):** **Classe A = 61 clientes (rn 1–61)** = 79,84% (rn 62 já passa de
  80%: 80,06%) · **Classe B = rn 62–233** (94,98%; rn 234 = 95,02%).

## Script SQL — Classe A (61 clientes, foco total de cobrança)
```sql
SELECT x.cliente, x.nome, x.titulos, x.saldo, ROUND(x.cum/3064062.43*100,2) AS pct_acum, x.rn
FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
               ROUND(SUM(f.SALDO),2) AS saldo
        FROM financeiro f
        JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
        WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
          AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
          AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
          AND dc.SERIENF IN ('CI','1')
          AND dc.DATAEMISSAO >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
        GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 61;
```

## Script SQL — resumo ABC da carteira (faturados CI + 1, últimos 3 anos)
```sql
-- Totais por cliente (base para A/B/C)
SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
       ROUND(SUM(f.SALDO),2) AS saldo
FROM financeiro f
JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
  AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
  AND dc.SERIENF IN ('CI','1')
  AND dc.DATAEMISSAO >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC;

-- Totais da carteira
SELECT COUNT(DISTINCT f.CODIGOPESSOA) AS clientes, COUNT(*) AS titulos, ROUND(SUM(f.SALDO),2) AS saldo_total
FROM financeiro f
JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
  AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
  AND dc.SERIENF IN ('CI','1')
  AND dc.DATAEMISSAO >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);
```

## Como reproduzir
```bash
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL>"
```
> `--default-character-set=utf8` é obrigatório para acentuação legível (banco latin1).

## Resultado validado — empresa 1 (11/08/2026)
| Classe | Clientes | Títulos | Saldo | % valor |
|---|---|---|---|---|
| **A (≤ 80%)** | **61 (~7,5% da base)** | 735 | **R$ 2.446.204,31** | **79,84** |
| B (80–95%) | 172 | 620 | R$ 464.122,90 | 15,15 |
| C (95–100%) | 579 | 881 | R$ 153.735,21 | 5,02 |
| **Total** | **812** | **2.236** | **R$ 3.064.062,43** | 100,00 |

Notas de **11/08/2023 a 11/08/2026** (janela móvel de 3 anos na data de emissão).

### Top 15 da Classe A
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 1 | 213 BAHIA ARTES GRAFICAS LTDA | 185 | 602.815,40 | 19,67 |
| 2 | 10816 NEWELL BRANDS BRASIL LTDA | 59 | 443.431,00 | 34,15 |
| 3 | 215 R. ESQUIVEL MORAES DA SILVA EDITORA LTDA | 1 | 149.888,30 | 39,04 |
| 4 | 5878 JCS BRASIL ELETRODOMESTICOS S.A. | 31 | 137.540,52 | 43,53 |
| 5 | 10197 LATASA GARIMPEIRO URBANO NORDESTE COMERCIO DE META | 2 | 115.700,00 | 47,30 |
| 6 | 320 JOÃO FERREIRA DE OLIVEIRA JUNIOR | 25 | 75.476,61 | 49,77 |
| 7 | 10235 ELEICAO 2024 MARIA BETIVANIA LIMA DA SILVA PREFEIT | 1 | 71.824,00 | 52,11 |
| 8 | 4276 ARCO E FLEXA LOCACAO MAQUINAS E SERVICOS LTDA | 5 | 66.054,20 | 54,27 |
| 9 | 4809 INDUSTRIA REUNIDAS SANTOS CARVALHO LTDA | 23 | 60.809,00 | 56,25 |
| 10 | 10213 ELEICAO 2024 ISMAEL BASTOS DE SANTANA VEREADOR | 1 | 43.350,10 | 57,66 |
| 11 | 6030 PAULO CEZAR ALBUQUERQUE DE OLIVEIRA FILHO | 23 | 38.790,50 | 58,93 |
| 12 | 10671 MACEDOS INDUSTRIA E COMERCIO DE EMBALAGENS LTDA | 5 | 28.500,00 | 59,86 |
| 13 | 8525 ESTACAO 1 CONSTRUCOES E EMPREENDIMENTOS LTDA | 27 | 28.116,25 | 60,78 |
| 14 | 8849 ENVASADORA GAMBOA INDUSTRIA E COMERCIO DE AGUA E B | 10 | 24.603,04 | 61,58 |
| 15 | 8263 ELEICAO 2020 MARIA BETIVANIA LIMA DA SILVA PREFEIT | 6 | 24.400,00 | 62,38 |

### Final da Classe A (corte dos 80%)
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 58 | 6120 M S B NUNES FARDAMENTOS E FERRAMENTAS | 3 | 7.000,00 | 79,16 |
| 59 | 6945 BRENNO CARDOSO SILVA | 9 | 6.981,04 | 79,39 |
| 60 | 4653 GV COMERCIAL DE BEBIDAS LTD. | 5 | 6.980,00 | 79,61 |
| 61 | 10554 ELEICAO 2024 TANIA MARLI RIBEIRO YOSHIDA PREFEITO | 2 | 6.800,00 | **79,84** |
| 62 | 9306 DUNAX LUBRIFICANTES LTDA | 3 | 6.750,00 | 80,06 → sai da A |

## Exportação CSV (Classe A) — UTF-8 com BOM, separador `;`, decimal `,`
```bash
{ printf '\xef\xbb\xbfcliente;nome;titulos;saldo;pct_acum\n'; \
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 --batch --raw -h 192.168.1.16 -P 3307 -u _consulta wingraphex -N \
-e "SELECT CONCAT_WS(';', cliente, nome, titulos, REPLACE(CAST(saldo AS CHAR), '.', ','), REPLACE(CAST(ROUND(cum/3064062.43*100,2) AS CHAR), '.', ',')) FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
               ROUND(SUM(f.SALDO),2) AS saldo
        FROM financeiro f
        JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
        WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
          AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
          AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S' AND dc.SERIENF IN ('CI','1')
          AND dc.DATAEMISSAO >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
        GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 61;"; } > contas-a-receber-abc-ci-3-anos.csv
```
> O `\xef\xbb\xbf` grava o BOM UTF-8 (Excel BR abre direto); `;` como separador e `,` decimal
> seguem o padrão pt-BR. `--batch --raw` evita a borda/`|` do modo texto.

## Observações
- **⚠️ Acumulado por variável (`@cum`):** acumular sobre o **valor bruto** (`saldo`), nunca sobre
  `pct` arredondado — arredondar antes de acumular desloca o corte.
- **Filtro por data de emissão** (`dc.DATAEMISSAO`), não de vencimento/entrega. Janela móvel:
  re-executar com `CURDATE()` recalcula sozinho.
- **Comparação com o escopo sem corte de data** (`contas-a-receber-abc-ci.md`): o corte de 3 anos
  **reduz a carteira de R$ 11,76 mi para R$ 3,06 mi** (−74%) e **encolhe a Classe A de 234 para 61
  clientes**. Notas antigas (2010–2022) concentram grande valor em aberto, principalmente na série CI.
- **Séries explícitas:** além de `CI` e `1`, existem séries `2` e `M1` com saldo aberto mínimo
  (R$ 994 e R$ 415) — fora deste relatório por critério de negócio (CI + série 1).
- **Cliente:** `CODIGOPESSOA`/`NOMEPESSOA` do próprio `financeiro`; `CODIGOPESSOA` = `pessoa.PES_ID`.
- **Para detalhar os títulos de um cliente da Classe A** (NF, vencimento, forma de pagto), usar `contas-a-receber-em-aberto.md`.
