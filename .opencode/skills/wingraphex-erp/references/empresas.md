# Empresas do Wingraphex — levantamento 17/08/2026

> Fonte: `empresa` (produção, somente leitura) + contagens `GROUP BY EMP_ID` em 17/08/2026.

## As duas empresas

| EMP_ID | Razão social | Nome fantasia | CNPJ | Cidade | UF |
|---|---|---:|---|---|---|
| 1 | GOES E SILVA LTDA. | GRÁFICA PLANTÃO | 04252903000110 | FEIRA DE SANTANA | BA |
| 2 | R. Esquivel Moraes da Silva Editora LDTA | Editora Esquivel | 07850206000150 | FEIRA DE SANTANA | BA |

- **Empresa 1 = a gráfica** (offset plana, operação grande — 100% dos relatórios atuais).
- **Empresa 2 = a editora** (operação pequena, dados recentes 2026, clientela própria).

## Volume por empresa (produção, 17/08/2026)

| Tabela | Emp 1 | Emp 2 |
|---|---:|---:|
| `ordemservico` | 161.975 | 171 |
| `op` | 161.968 | 171 |
| `ordemservplanejentrega` | 162.147 | 171 |
| `orcamento` | 171.016 | 174 |
| `qtorcamento` | 174.391 | 174 |
| `documentocabecalho` (todas classificações) | 93.489 | 115 |
| `financeiro` | 236.807 | 284 |
| `equipamento` | 30 | 39 |
| `maquina` | 38 | 38 |
| `equipamentomaquinas` | 33 | 31 |
| `pcpprocessos` | 93.326 | 39 |

## Empresa 2 — particularidades

- **OPs:** 171, todas recentes (máx. `ORS_ID` ~171; amostra viva: 157–171). Ex.: "TIRAS/BASE PARA POTES 360ML – AÇAÍ NO KILO" (ORS 168–171, cliente 10074), tigelas 500ML "GELOH"/"AÇAÍ DO MONSTRO" etc.
- **Cliente dominante:** `PES_ID 10074` (Açaí); demais clientes na faixa **10908–10959** (AÇAÍ DO BERNA, SORVETES DELÍCIA, etc.) — base totalmente distinta da empresa 1.
- **13 OPs têm PCP** (`pcpprocessos` EMP_ID=2): ORS 122–128, 131, 132, 134, 138, 140, 170.
- **Equipamentos com `CODIGO` exclusivos da empresa 2** (não existem na emp 1): 3, 4, 10, 12, 14, 15, 16, 22, 24, 27 (descrições `--`, cadastro "fantasma").
- **Documentos:** série `CI`, `CLASSIFICACAO=0` (ex.: DOC 115 = CI 103, 14/08/2026).
- **`formapagto`:** cadastros duplicados por empresa (28 na emp 1; emp 2 tem os seus próprios).

## Regras gerais (valem para as duas)

- **Cadastros são duplicados por empresa** (`EMP_ID` sempre no `WHERE`); PKs compostas `(EMP_ID, ...)` — sem conflito ao misturar as duas no mesmo banco.
- `pessoa`/`cliente`/`vendedor`/`equipamento`/`maquina`/`formapagto` etc. são por empresa; tabelas de apoio (`tipostatusordemservico`, `tipodocumento`, `estado`, `cidade`, `cfopoficial`, `meiospagamento`, `_dicionario`, parâmetros) não têm `EMP_ID`.
- `_parametroempresa` tem as 2 linhas (configurações de e-mail/arte/despacho por empresa).

## Como consultar as empresas na réplica local

A amostra Docker (porta 3308) cobre as duas a partir de 17/08/2026:
```sql
SELECT EMP_ID, EMP_RAZAOSOCIAL, EMP_NOMEFANTASIA, EMP_CNPJ FROM empresa;
SELECT EMP_ID, COUNT(*) FROM ordemservico GROUP BY EMP_ID;
```
Para validar qualquer relatório em ambas, repetir o SQL trocando o `EMP_ID`.