# Relatório — Contas a receber em aberto (Análise ABC — somente faturados CI + NF série 1)

> Validado em treino 11/08/2026 (empresa 1). Somente leitura. Variante do `contas-a-receber-abc.md`
> restrita a títulos com **documento faturado** (séries CI e 1). Com opção de exportação CSV.

## Pergunta de negócio
Mesma análise ABC (cobrança por concentração de valor) do relatório geral, porém considerando
**somente os títulos a receber em aberto que têm documento faturado** — **CI** (Conta Interna) e
**NF série 1** (NF-e SEFAZ). Classes por valor acumulado:
- **Classe A** — clientes até **80%** do valor total (foco total de cobrança).
- **Classe B** — até **95%**.
- **Classe C** — o restante (~5%).

## Definições
- **Em aberto:** `financeiro.ORIGEM='TOL_CONTASARECEBER'`, `SALDO > 0`, `FLAGLANCCANCELADO<>'S'`,
  `ESTORNO<>'S'` (ou NULL), empresa `EMP_ID=1`.
- **Faturado:** título vinculado a documento via `documentocabecalho` (`CLASSIFICACAO=0` = NF,
  `CANCELADA<>'S'`), nas séries **CI e 1**. Exclui títulos **sem documento** (`PNJ01-OP*`,
  `DOC_ID=0`) e documentos cancelados.
- **Valor por cliente:** `SUM(financeiro.SALDO)` (restante a pagar), agregado por `CODIGOPESSOA`.
- **Corte exato da Classe A (validado):** primeiros **234 clientes** (rn 1 a 234) = **79,96%** do
  valor total.

## Script SQL — Classe A (234 clientes, foco total de cobrança)
```sql
SELECT x.cliente, x.nome, x.titulos, x.saldo, ROUND(x.cum/11756279.32*100,2) AS pct_acum, x.rn
FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
               ROUND(SUM(f.SALDO),2) AS saldo
        FROM financeiro f
        JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
        WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
          AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
          AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
        GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 234;
```

## Script SQL — resumo ABC da carteira (faturados CI + 1)
```sql
-- Totais por cliente (base para A/B/C)
SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
       ROUND(SUM(f.SALDO),2) AS saldo
FROM financeiro f
JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
  AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC;

-- Totais da carteira
SELECT COUNT(DISTINCT f.CODIGOPESSOA) AS clientes, COUNT(*) AS titulos, ROUND(SUM(f.SALDO),2) AS saldo_total
FROM financeiro f
JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
  AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
  AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S';
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
| Carteira (faturados CI + 1) | **R$ 11.756.279,32** · 2.506 clientes · 9.821 títulos |
| **Classe A (≤ 80%)** | **234 clientes (~9,3% da base)** · **R$ 9.399.903,92 (79,96%)** |
| Classe B (80–95%) | ~600 clientes |
| Classe C (95–100%) | ~1.672 clientes |

### Top 5 da Classe A
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 1 | 213 BAHIA ARTES GRAFICAS LTDA | 210 | 1.089.949,61 | 9,27 |
| 2 | 5120 G B SOUZA ME | 29 | 751.262,60 | 15,66 |
| 3 | 10816 NEWELL BRANDS BRASIL LTDA | 59 | 443.431,00 | 19,43 |
| 4 | 3682 GRÁFICA E EDITORA POLIKRON LTDA | 60 | 386.660,42 | 22,72 |
| 5 | 2917 BOMBONE INDUSTRIA E COMERCIO | 157 | 239.163,60 | 24,76 |

### Final da Classe A (corte dos 80%)
| # | Cliente | Títulos | Saldo | % acum. |
|---|---|---:|---:|---:|
| 231 | 1538 IEDO LOBO SANTANA | 12 | 7.760,91 | 79,76 |
| 232 | 9536 ELEICAO 2022 ALEX LOPES DA SILVA DEPUTADO ESTADUAL | 1 | 7.750,00 | 79,83 |
| 233 | 2454 ELEIÇÕES 2012 DION AVELINO DA SILVA PREFEITO | 4 | 7.725,00 | 79,89 |
| 234 | 8061 JACKSON MARIANO GOES DA SILVA | 2 | 7.695,00 | **79,96** |

## Exportação CSV (Classe A) — UTF-8 com BOM, separador `;`, decimal `,`
```bash
{ printf '\xef\xbb\xbfcliente;nome;titulos;saldo;pct_acum\n'; \
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 --batch --raw -h 192.168.1.16 -P 3307 -u _consulta wingraphex -N \
-e "SELECT CONCAT_WS(';', cliente, nome, titulos, REPLACE(CAST(saldo AS CHAR), '.', ','), REPLACE(CAST(ROUND(cum/11756279.32*100,2) AS CHAR), '.', ',')) FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT f.CODIGOPESSOA AS cliente, MAX(f.NOMEPESSOA) AS nome, COUNT(*) AS titulos,
               ROUND(SUM(f.SALDO),2) AS saldo
        FROM financeiro f
        JOIN documentocabecalho dc ON dc.EMP_ID=f.EMP_ID AND dc.CLASSIFICACAO=f.CLASSIFICACAO AND dc.DOC_ID=f.DOC_ID
        WHERE f.EMP_ID=1 AND f.ORIGEM='TOL_CONTASARECEBER' AND f.SALDO>0
          AND f.FLAGLANCCANCELADO<>'S' AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
          AND dc.CLASSIFICACAO=0 AND dc.CANCELADA<>'S'
        GROUP BY f.CODIGOPESSOA ORDER BY SUM(f.SALDO) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 234;"; } > classe_a_ci_1.csv
```
> O `\xef\xbb\xbf` grava o BOM UTF-8 (Excel BR abre direto); `;` como separador e `,` decimal
> seguem o padrão pt-BR. `--batch --raw` evita a borda/`|` do modo texto. Arquivo sai no diretório
> onde o comando roda.

## Observações
- **⚠️ Acumulado por variável (`@cum`):** acumular sobre o **valor bruto** (`saldo`), nunca sobre
  `pct` arredondado — arredondar antes de acumular desloca o corte. O `LIMIT 234` fixo é seguro
  porque o rn 234 fecha em 79,96%.
- **Comparação dos 3 escopos (empresa 1):**
  | Escopo | Carteira | Classe A | Saldo A |
  |---|---|---|---|
  | Todos (incl. PNJ01-OP\*) | R$ 16.922.404,75 · 3.443 cli | 280 cli | R$ 13.537.084,76 |
  | Somente CI | R$ 10.300.005,06 · 2.477 cli | 254 cli | R$ 8.238.189,36 |
  | **CI + NF série 1** | **R$ 11.756.279,32 · 2.506 cli** | **234 cli** | **R$ 9.399.903,92** |
- **Série 1 é minoria mas relevante:** excluir os `PNJ01-OP*` muda top (NEWELL volta a aparecer), e
  a NF série 1 (SEFAZ) agrega ~R$ 1,46 mi à carteira CI.
- **Cliente:** `CODIGOPESSOA`/`NOMEPESSOA` do próprio `financeiro`; `CODIGOPESSOA` = `pessoa.PES_ID`.
- **Para detalhar os títulos de um cliente da Classe A** (NF, vencimento, forma de pagto), usar `contas-a-receber-em-aberto.md`.
