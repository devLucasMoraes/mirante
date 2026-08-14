# Relatório — Consulta de OPs por descrição (com financeiro e PCP)

> Validado em treino 11/08/2026 (cliente **5011** JHONY'S PIZZA, termo `%PORTA FATIA%`, emissão
> 2024-01-01 a 2026-12-31). Somente leitura. Base para a futura aplicação cliente-servidor
> (Fastify + Vite/React) de consulta de OPs.

## Pergunta de negócio
Buscar OPs por **descrição** (com filtros opcionais de **cliente** e **range de data de emissão**)
trazendo, por OP: código, descrição, cliente, quantidade total, saldo de quantidade, valor total do
serviço, **saldo do valor de produção**, **valor já pago**, **saldo a receber**, data de emissão,
status de faturamento e **resumo do PCP** (nº de processos / finalizados).

## Definições
- **Valor total do serviço:** `ordemservico.ORS_VLRFINALPRAZO` (preço a prazo do espelho do
  orçamento; à vista ⇒ trocar por `ORS_VLRFINALVISTA`).
- **Saldo do valor de produção:** `ORS_VLRFINALPRAZO × (op.ORS_SALDO / ORS_QUANTIDADE)` —
  proporcional ao que falta produzir (fórmula validada em `ops-em-aberto.md`).
- **Valor já pago:** `SUM(f.VALOR - f.SALDO)` dos títulos (`financeiro.ORIGEM = 'TOL_CONTASARECEBER'`)
  vinculados aos documentos da OP (via `documentoitem.CODIGOORDEMPRODUCAO` → `documentocabecalho` → `financeiro`).
- **Saldo a receber:** `SUM(f.SALDO)` dos mesmos títulos — o que ainda falta receber.
- **PCP:** agregação de `pcpprocessos` por `CODIGOOP` (processos totais e `STATUS='F'` finalizados).
- **OP sem faturamento** (órfã/fantasma): `COALESCE` → 0 (NULL), nunca quebra a linha.
- **Filtros:** `ORS_DESCRICAO LIKE '%...%'` (sem índice → scan ~0,3s), `CLI_ID` (índice
  `fkCliente`), `ORS_DATA` entre datas (range de emissão). `EMP_ID=1`, `ORS_CANCELADA<>'S'`.
- **Status:** `ORS_STATUSFATURAMENTO` (`TSF_AFATURAR` / `TSF_FATURADA`).

## Script SQL (validado, consolidado em um comando)
```sql
SELECT os.ORS_ID AS op,
       (SELECT p.PES_NOME_RAZAO FROM pessoa p WHERE p.EMP_ID=os.EMP_ID AND p.PES_ID=os.CLI_ID LIMIT 1) AS cliente,
       os.ORS_QUANTIDADE AS qtd_total,
       o.ORS_SALDO AS saldo_qtd,
       ROUND(os.ORS_VLRFINALPRAZO,2) AS valor_total,
       ROUND(os.ORS_VLRFINALPRAZO*(o.ORS_SALDO/os.ORS_QUANTIDADE),2) AS saldo_producao,
       COALESCE(fin.valor_pago,0) AS valor_pago,
       COALESCE(fin.saldo_receber,0) AS saldo_receber,
       DATE(os.ORS_DATA) AS data_emissao,
       os.ORS_STATUSFATURAMENTO AS status,
       COALESCE(pcp.processos,0) AS pcp_processos,
       COALESCE(pcp.finalizados,0) AS pcp_finalizados
FROM ordemservico os
JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
LEFT JOIN (
  SELECT di.CODIGOORDEMPRODUCAO AS op,
         ROUND(SUM(f.VALOR-f.SALDO),2) AS valor_pago,
         ROUND(SUM(f.SALDO),2) AS saldo_receber
  FROM documentoitem di
  JOIN documentocabecalho dc ON dc.EMP_ID=di.EMP_ID AND dc.CLASSIFICACAO=di.CLASSIFICACAO AND dc.DOC_ID=di.DOC_ID AND (dc.CANCELADA<>'S' OR dc.CANCELADA IS NULL)
  JOIN financeiro f ON f.EMP_ID=dc.EMP_ID AND f.CLASSIFICACAO=dc.CLASSIFICACAO AND f.DOC_ID=dc.DOC_ID
    AND f.ORIGEM='TOL_CONTASARECEBER'
    AND (f.FLAGLANCCANCELADO<>'S' OR f.FLAGLANCCANCELADO IS NULL)
    AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
  WHERE di.EMP_ID=1 AND di.CODIGOORDEMPRODUCAO IN (
    SELECT os2.ORS_ID FROM ordemservico os2
    WHERE os2.EMP_ID=1 AND os2.ORS_CANCELADA<>'S' AND os2.CLI_ID=5011
      AND os2.ORS_DESCRICAO LIKE '%PORTA FATIA%'
      AND os2.ORS_DATA BETWEEN '2024-01-01' AND '2026-12-31')
  GROUP BY di.CODIGOORDEMPRODUCAO
) fin ON fin.op=os.ORS_ID
LEFT JOIN (
  SELECT pc.CODIGOOP AS op, COUNT(*) AS processos, SUM(pc.STATUS='F') AS finalizados
  FROM pcpprocessos pc WHERE pc.EMP_ID=1 AND pc.CODIGOOP IN (
    SELECT os3.ORS_ID FROM ordemservico os3
    WHERE os3.EMP_ID=1 AND os3.ORS_CANCELADA<>'S' AND os3.CLI_ID=5011
      AND os3.ORS_DESCRICAO LIKE '%PORTA FATIA%'
      AND os3.ORS_DATA BETWEEN '2024-01-01' AND '2026-12-31')
  GROUP BY pc.CODIGOOP
) pcp ON pcp.op=os.ORS_ID
WHERE os.EMP_ID=1 AND os.ORS_CANCELADA<>'S'
  AND os.CLI_ID=5011
  AND os.ORS_DESCRICAO LIKE '%PORTA FATIA%'
  AND os.ORS_DATA BETWEEN '2024-01-01' AND '2026-12-31'
ORDER BY os.ORS_DATA DESC;
```
> Na API, os 3 parâmetros (`CLI_ID`, termo do LIKE, range de datas) viram placeholders; `LIKE`
> escapado no mysql2.

## Como reproduzir
```bash
MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL acima>"
```
> `--default-character-set=utf8` é obrigatório para acentuação legível (banco latin1).

## Resultado validado — cliente 5011 · `%PORTA FATIA%` · emissão 2024–2026 (8 OPs, 0,83s)
| OP | Qtd | Saldo qtd | Valor tot. | Saldo produção | Já pago | Saldo a receber | Emissão | Status | PCP (proc/fin) |
|---|---:|---:|---:|---:|---:|---:|---|---:|---|
| 161816 | 4.000 | 2.000 | 1.200,00 | 600,00 | 600,00 | 0,00 | 2026-07-10 | TSF_AFATURAR | 2 / 1 |
| 160875 | 4.000 | 0 | 1.200,00 | 0 | 1.200,00 | 0,00 | 2026-04-01 | TSF_FATURADA | 2 / 1 |
| 160396 | 4.000 | 0 | 1.200,00 | 0 | 600,00 | **600,00** | 2026-02-24 | TSF_FATURADA | 1 / 0 |
| 159763 | 4.000 | 0 | 1.200,00 | 0 | 1.200,00 | 0,00 | 2025-12-03 | TSF_FATURADA | 4 / 2 |
| 159152 | 4.000 | 0 | 1.200,00 | 0 | 1.200,00 | 0,00 | 2025-10-14 | TSF_FATURADA | 4 / 1 |
| 158117 | 2.000 | 0 | 700,00 | 0 | 700,00 | 0,00 | 2025-07-24 | TSF_FATURADA | 3 / 2 |
| 156063 | 2.000 | 0 | 700,00 | 0 | 700,00 | 0,00 | 2025-02-10 | TSF_FATURADA | 3 / 3 |
| 153950 | 4.000 | 4.000 | 1.200,00 | 1.200,00 | 0,00 | 0,00 | 2024-09-18 | TSF_AFATURAR | 5 / 5 |

**Leitura dos casos-chave:** 160396 pagou só metade (saldo a receber 600 = cobrança real) ·
153950 é "fantasma" (desde 2024, nunca faturada, saldo produção 1.200 → lixo a cancelar) ·
161816 produziu metade, faturou/pagou 600 (os dois saldos distintos aparecem: produção 600 vs financeiro 0).

## Observações
- **Desempenho:** descrição usa LIKE com `%` nos dois lados → varre ~76 mil linhas de
  `ordemservico` (~0,26s só a busca; 0,83s com os 2 joins em lote). Aceitável. Além de cliente
  (`fkCliente`) e data, não há índice de texto.
- **⚠️ Título manual pode superar o valor da OP:** títulos de faturamento podem ser preenchidos
  manualmente e não batem com o item da OP (ex.: OP 157682 — BAHIA ARTES — valor 73.200,00 mas
  títulos somam 161.005,57). Os campos financeiros mostram o valor **real do financeiro**; o valor
  da OP vem do espelho. Não somar expectativa de `pago + saldo_receber = valor_total`.
- **Nome do cliente:** usar subquery `pessoa` com `LIMIT 1` — a tabela `pessoa` tem 10.947 `PES_ID`
  duplicados; JOIN direto duplica as linhas (ver `ops-em-aberto-abc.md`).
- **OP sem fatura:** `COALESCE` → 0 (as fantasmas têm PCP às vezes, ex.: 153950 tem 5 processos finalizados).
- **PCP:** resume por `CODIGOOP` direto (`fkOrdemProducao`). Para classificar em estágios
  (pré-impressão/impressão/acabamento/finalizado), agrupar por `DESCRICAOEQUIPAMENTO` — ver mapa em
  `modulo-pcp.md` §3. "ENTREGAS" fica fora (entrega, não produção).
- **Filtros do financeiro:** `ORIGEM='TOL_CONTASARECEBER'`, `FLAGLANCCANCELADO<>'S'`,
  `ESTORNO<>'S'`, `documentocabecalho.CANCELADA<>'S'` (padrão dos relatórios de contas a receber).
- **Índices usados:** `op.PRIMARY (EMP_ID, ORS_ID)`, `ordemservico.fkCliente (EMP_ID, CLI_ID)`,
  `documentoitem.fkOP (EMP_ID, CODIGOORDEMPRODUCAO)`, `financeiro.akFinanceiro1 (EMP_ID, DOC_ID, CLASSIFICACAO)`,
  `pcpprocessos.fkOrdemProducao (EMP_ID, CODIGOOP)`.

## 2026-08-13 — Nota com itens de várias OPs: financeiro é da nota, ratear por pro-rata

- **O que foi testado:** amostra da réplica (29 notas CI/NF com `CODIGOORDEMPRODUCAO`): **9 de 29
  notas têm itens de mais de uma OP** (31%). Ex.: CI **207293** (DOC 92389) = OPs 160223 (118,00) +
  160306 (59,00) + 160102 (59,00) = total **236,00**.
- **Resultado:** a atribuição antiga (somar `financeiro` por `DOC_ID` e repetir o total para cada OP)
  **superestima o financeiro por OP**. Ex.: OP 160306 (serviço 59,00) aparecia "pago 236,00" — era a
  nota inteira. 
- **Solução adotada no app (pro-rata por valor faturado):** o título `TOL_CONTASARECEBER`
  (`pago = Σ(VALOR−SALDO)`, `saldo = Σ SALDO`) pertence à nota; a parcela da OP = `share × título`,
  com `share = Σ(QUANTIDADE×VALORUNITARIO) da OP na nota ÷ Σ(QUANTIDADE×VALORUNITARIO) de TODOS os
  itens da nota` (inclui OPs fora da página/consulta). OP 160306 → share 59/236 = 25% → pago **59,00**,
  saldo 0. Faturamento é item a item: valor 59,00 · qtd 1.000 · nota "CI 207293".
- **Como reproduzir:** `SELECT ... FROM documentoitem di JOIN documentocabecalho dc ... WHERE
  di.CODIGOORDEMPRODUCAO='160306'` (não cancelada, CLASSIFICACAO=0) → itens + `financeiro` por DOC_ID.
- **Observações:** `documentoitem.CODIGOORDEMPRODUCAO` é varchar(20) — comparar como string (usa índice
  `fkOP`). Nº da nota para exibição = `SERIENF + NUMERONF` (fallback `NUMERODOCUMENTO`/`DOC_ID`). Item
  sem OP entra no denominador (share ligeiramente subatribuído — aceito).
