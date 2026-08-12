# Relatório — OPs em aberto (Análise ABC)

> Validado em treino 11/08/2026 (empresa 1, carteira completa). Somente leitura. Variante de
> `ops-em-aberto.md` agregada por cliente e classificada por valor acumulado (cobrança/produção).

## Pergunta de negócio
Categorizar a carteira de **OPs em aberto** em classes **A/B/C por concentração de valor
acumulado**, para priorizar o acompanhamento de produção/cobrança:
- **Classe A** — clientes que somam até **80%** do saldo-valor total (foco).
- **Classe B** — até **95%**.
- **Classe C** — o restante (~5%).

## Definições
- **Em aberto:** `op.ORS_SALDO > 0` e `ordemservico.ORS_CANCELADA <> 'S'`, empresa `EMP_ID=1`.
  Inclui OPs "fantasma" (órfãs, que nunca entraram no fluxo PCP) — mesmo escopo do
  `ops-em-aberto.md` validado.
- **Saldo-valor por OP:** `ORS_VLRFINALPRAZO × (ORS_SALDO / ORS_QUANTIDADE)` — preço a prazo
  proporcional à produção restante (validado contra o título financeiro em `ops-em-aberto.md`).
- **Valor por cliente:** `SUM(saldo-valor)` agregado por `ordemservico.CLI_ID`.
- **Corte exato da Classe A (validado):** primeiros **185 clientes** (rn 1 a 185) = **79,96%** do
  saldo-valor total.

## Script SQL — Classe A (185 clientes, foco)
```sql
SELECT x.cliente, x.nome, x.ops, x.saldo, ROUND(x.cum/6148098.85*100,2) AS pct_acum, x.rn
FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT os.CLI_ID AS cliente,
               (SELECT p.PES_NOME_RAZAO FROM pessoa p WHERE p.PES_ID=os.CLI_ID LIMIT 1) AS nome,
               COUNT(*) AS ops, ROUND(SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)),2) AS saldo
        FROM ordemservico os
        JOIN op o ON o.EMP_ID = os.EMP_ID AND o.ORS_ID = os.ORS_ID
        WHERE os.EMP_ID = 1 AND o.ORS_SALDO > 0 AND os.ORS_CANCELADA <> 'S'
        GROUP BY os.CLI_ID ORDER BY SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 185;
```

## Script SQL — resumo ABC da carteira
```sql
-- Totais por cliente (base para A/B/C)
SELECT os.CLI_ID AS cliente, COUNT(*) AS ops,
       ROUND(SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)),2) AS saldo
FROM ordemservico os
JOIN op o ON o.EMP_ID = os.EMP_ID AND o.ORS_ID = os.ORS_ID
WHERE os.EMP_ID = 1 AND o.ORS_SALDO > 0 AND os.ORS_CANCELADA <> 'S'
GROUP BY os.CLI_ID ORDER BY saldo DESC;

-- Totais da carteira
SELECT COUNT(DISTINCT os.CLI_ID) AS clientes, COUNT(*) AS ops,
       ROUND(SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)),2) AS saldo_valor_total
FROM ordemservico os
JOIN op o ON o.EMP_ID = os.EMP_ID AND o.ORS_ID = os.ORS_ID
WHERE os.EMP_ID = 1 AND o.ORS_SALDO > 0 AND os.ORS_CANCELADA <> 'S';
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
| Carteira de OPs em aberto | **R$ 6.148.098,85** · 2.605 clientes · 10.783 OPs |
| **Classe A (≤ 80%)** | **185 clientes (~7,1% da base)** · **R$ 4.915.684,01 (79,96%)** |
| Classe B (80–95%) | ~400 clientes |
| Classe C (95–100%) | ~2.020 clientes |

### Top 5 da Classe A
| # | Cliente | OPs | Saldo-valor | % acum. |
|---|---|---:|---:|---:|
| 1 | 10234 ELEICAO 2024 JOSE RONALDO DE CARVALHO PREFEITO | 134 | 552.776,50 | 8,99 |
| 2 | 57 JOSE RONALDO DE CARVALHO SENADOR | 250 | 520.170,80 | 17,45 |
| 3 | 443 GRAFICA PLANTÃO (LAMINAS) | 713 | 349.078,72 | 23,13 |
| 4 | 10248 ELEICAO 2024 EDSON ALMEIDA DE JESUS PREFEITO | 11 | 236.838,60 | 26,98 |
| 5 | 5570 PLANTAO - CARTÃO DE VISITA | 292 | 209.131,64 | 30,38 |

### Final da Classe A (corte dos 80%)
| # | Cliente | OPs | Saldo-valor | % acum. |
|---|---|---:|---:|---:|
| 182 | 1470 RUY BARBOSA PREFEITURA | 1 | 3.970,00 | 79,76 |
| 183 | 8227 VALNEI FERREIRA DE SOUZA | 8 | 3.925,00 | 79,83 |
| 184 | 4967 EDUARDO FELIPE WELCH DA MOTTA | 7 | 3.920,00 | 79,89 |
| 185 | 4119 EDITORA PRINCESA LTDA | 1 | 3.900,00 | **79,96** |

## Exportação CSV (Classe A) — UTF-8 com BOM, separador `;`, decimal `,`
```bash
{ printf '\xef\xbb\xbfcliente;nome;ops;saldo;pct_acum\n'; \
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 --batch --raw -h 192.168.1.16 -P 3307 -u _consulta wingraphex -N \
-e "SELECT CONCAT_WS(';', cliente, REPLACE(nome, ';', '-'), ops, REPLACE(CAST(saldo AS CHAR), '.', ','), REPLACE(CAST(ROUND(cum/6148098.85*100,2) AS CHAR), '.', ',')) FROM (
  SELECT a.*, @cum := @cum + a.saldo AS cum, @rn := @rn + 1 AS rn
  FROM (SELECT os.CLI_ID AS cliente,
               (SELECT p.PES_NOME_RAZAO FROM pessoa p WHERE p.PES_ID=os.CLI_ID LIMIT 1) AS nome,
               COUNT(*) AS ops, ROUND(SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)),2) AS saldo
        FROM ordemservico os
        JOIN op o ON o.EMP_ID = os.EMP_ID AND o.ORS_ID = os.ORS_ID
        WHERE os.EMP_ID = 1 AND o.ORS_SALDO > 0 AND os.ORS_CANCELADA <> 'S'
        GROUP BY os.CLI_ID ORDER BY SUM(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE)) DESC) a
  CROSS JOIN (SELECT @cum := 0, @rn := 0) v
) x WHERE x.rn <= 185;"; } > ops_em_aberto_classeA.csv
```
> `\xef\xbb\xbf` grava o BOM UTF-8 (Excel BR abre direto); `;` separador e `,` decimal (padrão
> pt-BR); `--batch --raw` evita bordas do modo texto. Nomes com `;` são trocados por `-`.

## Observações
- **⚠️ Armadilha do `pessoa`:** a tabela `pessoa` tem **10.947 PES_ID duplicados** — `LEFT JOIN
  pessoa` duplica as linhas das OPs e estoura o acumulado (testado: passou de 100% no rn 100). Usar
  **subquery com `LIMIT 1`** para o nome; nunca JOIN direto.
- **⚠️ Acumulado por variável (`@cum`):** acumular sobre o **valor bruto** (`saldo`), nunca sobre
  `pct` arredondado. O `LIMIT 185` fixo é seguro porque o rn 185 fecha em 79,96%.
- **Comparação com o ABC de contas a receber** (`contas-a-receber-abc-ci.md`): a carteira de OPs em
  aberto (R$ 6,15 mi) é menor que a de títulos a receber faturados (R$ 11,76 mi); os cortes de 80%
  são parecidos em proporção de base (~7–9%). O topo muda (aqui dominam campanhas eleitorais e gráficas).
- **Para detalhar as OPs de um cliente da Classe A** (OP, data, saldo qtd/valor), usar `ops-em-aberto.md`.
- **Cliente:** `ordemservico.CLI_ID` = `pessoa.PES_ID`; `CLI_ID` também = `cliente.CLI_ID`.
