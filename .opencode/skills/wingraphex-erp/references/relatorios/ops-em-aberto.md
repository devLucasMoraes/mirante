# Relatório — OPs em aberto por cliente

> Validado em treino 11/08/2026 (cliente **5011 — JHONY'S PIZZA**). Somente leitura.

## Pergunta de negócio
Listar as OPs **em aberto** de um cliente, com: descrição da OP, data de emissão, número da OP,
quantidade, saldo, valor e **saldo do valor**.

## Definições
- **Em aberto:** `op.ORS_SALDO > 0` e `ordemservico.ORS_CANCELADA <> 'S'`.
- **Valor:** `ordemservico.ORS_VLRFINALPRAZO` (preço a prazo do espelho do orçamento). Para à vista,
  trocar por `ORS_VLRFINALVISTA`.
- **Saldo do valor:** `valor × (saldo / quantidade)` — valor proporcional ao saldo restante de
  produção. **Validado contra o título financeiro** (OP 161816 → título 259384 = 600,00 = metade
  do valor, exatamente o saldo restante).
- **Inclui OPs "fantasma" (órfãs):** OPs criadas mas que **nunca entraram no fluxo** — sem
  programação PCP (`pcptrabalhos`), sem título (`financeiro.NRO_OP`) e sem fatura
  (`documentoitem.CODIGOORDEMPRODUCAO`). O relatório do próprio sistema **NÃO as mostra** (lista só
  as que entraram no fluxo PCP/produção). Incluí-las ajuda a achar lixo a cancelar: há **3.613 OPs**
  órfãs na empresa 1 (de 10.785 com saldo > 0).

## Script SQL
```sql
SELECT
  os.ORS_ID            AS numero_op,
  DATE(os.ORS_DATA)    AS data_emissao,
  os.ORS_QUANTIDADE    AS quantidade,
  o.ORS_SALDO          AS saldo_qtd,
  os.ORS_VLRFINALPRAZO AS valor,
  ROUND(os.ORS_VLRFINALPRAZO * (o.ORS_SALDO / os.ORS_QUANTIDADE), 2) AS saldo_valor,
  os.ORS_DESCRICAO     AS descricao_op
FROM ordemservico os
JOIN op o ON o.EMP_ID = os.EMP_ID AND o.ORS_ID = os.ORS_ID
WHERE os.EMP_ID = 1
  AND os.CLI_ID = '<CLI_ID>'
  AND o.ORS_SALDO > 0
  AND os.ORS_CANCELADA <> 'S'
ORDER BY os.ORS_DATA, os.ORS_ID;
```

## Como reproduzir
```bash
MYSQL_PWD="$(awk -F'= ' '/senha/{print $2}' senha.txt)" \
mysql --default-character-set=utf8 -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "<SQL>"
```
> `--default-character-set=utf8` é obrigatório para acentuação legível (banco latin1).

## Resultado validado — cliente 5011 (JHONY'S PIZZA)
| OP | Data emissão | Qtd | Saldo qtd | Valor | Saldo valor | Descrição |
|---|---:|---:|---:|---:|---:|---|
| 73809 | 2016-06-09 | 50 | 50,00 | 170,00 | 170,00 | 50 BLOCOS 100X1 VIA "THONY'S PIZZARIA"... (**fantasma**) |
| 153950 | 2024-09-18 | 4.000 | 4.000,00 | 1.200,00 | 1.200,00 | 4.000 PORTA FATIA DE PIZZA "JC - JHONY CERQUEIRA" [4X0] 12X16,12cm TRIPLEX 225G |
| 161816 | 2026-07-10 | 4.000 | 2.000,00 | 1.200,00 | **600,00** | 4.000 PORTA FATIA DE PIZZA "JC - JHONY CERQUEIRA" [4X0] 12X16,12cm TRIPLEX 225G |

## Observações
- **OP fantasma vs em fluxo:** a 73809 é órfã (criada 2016, status histórico só "Ordem de serviço
  salva", nunca programada/faturada). Para filtrar como o sistema faz, adicionar
  `AND EXISTS (SELECT 1 FROM pcptrabalhos pt WHERE pt.EMP_ID = os.EMP_ID AND pt.CODIGOOP = os.ORS_ID)`.
- Cliente: `pessoa.PES_ID` = código (nome em `PES_NOME_RAZAO`/`PES_NOMEFANTASIA`); `cliente.CLI_ID` = `PES_ID`.
- O título financeiro nasce com valor = saldo do valor (ex.: 161816 → título 259384 = 600,00),
  validando a fórmula.
- Empresa: filtrar `EMP_ID` (1 = principal). Se não filtrar, duplica por empresa.
