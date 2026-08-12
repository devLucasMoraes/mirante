# Módulo PCP do Wingraphex (ERP) — levantamento 11/08/2026

> Baseado em consultas somente leitura ao banco de produção + dump do schema. Medidas reais.

## Visão geral
- **14 tabelas** `pcp*`, ~190 MB.
- PCP programa e acompanha a **Ordem de Produção (OP)** na fábrica (100% offset plana).
- Em uso real: `pcptrabalhos` 40.492 · `pcpprocessos` 93.017 · `pcpapontamento` 127.402.
- **`pcpapuracao`/`pcpapuracaoitem` = 0 registros** — o pós-cálculo (previsto×realizado de custo)
  **não é usado** na prática.

## 1. Fluxo de dados (encadeamento verificado)
```
ordemservico (ORS_ID, OP)  ──►  op (ORS_ID, saldo, TIPOPROCESSO)
        │                              │
        └──────────► pcptrabalhos (EMP_ID+CODIGO+CODIGOOP)   ← programação por OP
                          │
                          ├──► pcpprocessos (EMP_ID+CODIGO+CODIGOTRABALHO) ← operações
                          │        (nível, equipamento, máquina, status, datas)
                          ├──► pcpprocessoatividades / pcptempos / pcppausaprogramada(+equipamento)
                          ├──► pcpapontamento (+operador)  ← produção real por processo
                          ├──► pcpapuracaoitem / pcpapuracao ← apuração (vazia)
                          └──► pcpexpedicao / pcpprocessoentrega / expedicaopedido ← expedição
```
- `pcptrabalhos.CODIGOTRABALHO` é a chave intermediária mais usada; liga a `CODIGOOP` (= `ORS_ID`).
- `ordemservico.PCPCODIGOSTATUSOP` está **0/NULL em todas** — não é preenchido; o status é
  controlado em `ordemservicostatus` (12 estados, ver `regras-de-negocio.md` §6).

## 2. Programação (`pcptrabalhos`)
Colunas: `TIPOPROCESSO` (TP_OFFSETPLANA), `DATAPROGRAMACAO`, `CODIGOUSUARIO`/`NOMEUSUARIO`,
`STATUS` (P), `MODOAPONTAMENTO` (T), `JUSTIFICATIVA`, `OBSERVACAOPOSCALCULO`.
- Exemplos recentes (10/08/2026): OP 162065 (62598, 4 processos), 162060 (62593, 2 processos),
  162056 (62589, 1 processo).
- Cada trabalho = uma OP programada; `CODIGO` sequencia os trabalhos.

## 3. Processos/operações (`pcpprocessos`)

### Status (`STATUS`, contagem real)
| STATUS | Qtde | Significado |
|---|---:|---|
| F | 86.386 | Finalizado |
| P | 8.613 | Programado/parado |
| E | 16 | (ex.: dobra 4 — processo encerrado sem apontamento) |
| S | 2 | (raro) |

### Colunas-chave
- Sequência: `SEQUENCIAL`, `NIVEL`, `SEQUENCIAEXECUCAO`, `CODIGOPROCESSODEPENDENTE`/`CODIGOTRABALHODEPENDENTE`.
- Equipamento: `CODIGOEQUIPAMENTO`, `DESCRICAOEQUIPAMENTO`, `CODIGOMAQUINA`, `DESCRICAOMAQUINA`.
- Quantidades: `QUANTIDADE` (da OP), `TIRAGEM` (folhas/pedaços), `TIRAGEMAPONTADA`,
  `QTFOLHASPEDACOS`, `QTFOLHASAPONTADA`, `QTFINALAPONTADA`, `QTPRODUZIDAPARCIAL`, `QTMETROSLINEAR`.
- Datas: `DATAINICIO`/`DATAFIM` (+`HORAINICIO`/`HORAFIM`), `DURACAO`.
- Componente: `CODIGOCOMPONENTE`, `TIPOCOMPONENTE` (TL_FOLHA / TL_SERVGERAL), `DESCRICAOCOMPONENTE` (ex.: "Miolo 01").
- Flags: `PREPRODUCAO` (S/N), `DISPONIVEL`, `AGRUPADO`, `MONTAGEM`, `NUMEROCADERNO`, `TIPOMAQUINA`,
  `COROCORRENCIA`, `CODIGOTAREFA`/`DESCRICAOTAREFA`, `FORMAACABAMENTO`, `CODIGOSERVICO`.

### Como classificar equipamento em estágio de produção (útil p/ relatórios)
CTP, ARTE FINAL → pré-impressão · SM*/SPEED*/GTO* → impressão · GUILHOTINA, DOBRA, EMBALAGEM,
MONTAGEM... → acabamento · `STATUS='F'` ⇒ finalizado · "ENTREGAS" fica fora (entrega, não produção).

## 4. Apontamento de produção (`pcpapontamento`) — exemplo OP 157682
102 apontamentos em 24 processos distintos, 6 operadores, 68.574 s (~19 h):

| Operador | Apontamentos | Segundos |
|---|---:|---:|
| MOISES MENEZES FERREIRA | 77 | 39.809 |
| EDILSON MARTINS DE OLIVEIRA | 10 | 23.102 |
| EDSON DE SANTANA CARVALHO JUNIOR | 12 | 5.663 |
| (outros 3) | 3 | 0/NULL |

### Tipos de tempo (`CODIGOTIPOTEMPO`, na OP 157682)
| Código | Qtde | Segundos | Uso |
|---|---:|---:|---|
| 0 | 23 | 3 | (apontamento instantâneo/0) |
| 1 | 18 | 20.448 | produção/tiragem |
| 2 | 19 | 715 | preparação? |
| 3 | 35 | 16.492 | intervalo/parada? |
| 4 | 3 | 18.623 | improdutivo? |
| 5 | 4 | 12.293 | outro |

> `CODIGOOCORRENCIA` no apontamento (ex.: 2, 12, 70, 95) registra ocorrências; `pcptempos.TIPO`
> E/I (estimado/realizado?) com `ATIVIDADE` A/C/E/I/L/S.

## 5. Estudo completo — OP 157682 (referência, dados completos)
- Orçamento **166303** → OP 157682, cliente 213 (BAHIA ARTES GRÁFICAS), 30.000 unid., 10 miolos.
- `ordemservico`: custo 86.822,62 · impostos 11.646,12 · prazo/vista 73.200,00 · `TSF_FATURADA` ·
  `VE` · TI_SERVICO · liberada p/ faturamento 15/07/2026 · **custos realizados zerados**
  (`VLR_CUSTO_REALIZADO`=0, `VLR_TOTAL_REALIZADO`=0).
- **44 processos**: CTP, SM 105 5 cores (MOISES), dobra mecânica 4/5 dobras, guilhotina, embalagem,
  montagem + **10× "ENTREGAS"** (1 por miolo, status P).
- Apontamentos cobrem SM 105 e dobras; processos "ENTREGAS"/EMBALAGEM ficaram sem apontamento (status P/E).
- Histórico `ordemservicostatus`: 1 → 2 (baixa automática) → 3 (produção iniciada) → 13 faturas
  (jul/2025-jul/2026, por Jodson).
- **Planejamento de entrega** (`ordemservplanejentrega`): 1 registro — 30.000, entrega 11/07/2025,
  saldo produzir 0, saldo faturar 0, fator 1. (162.028 registros no total da tabela.)
- Faturamento: 13+ CIs série CI (DOC 90455, 90576, 90665, 90701, 90743, 90761, 90800, 90849...), saldo 0.

## 6. Expedição/entrega (lacuna confirmada)
- `pcpexpedicao` 22.003 (status **E**=21.644, **A**=358, **P**=1) — usado para produção, não para
  entrega ao cliente.
- `pcpprocessoentrega` 64.467 (produção parcial por processo).
- **`expedicaopedido` = 4 registros** (série PRE) — ligação faturamento↔expedição quase não usada.
- `opflexoplanejamentoentrega` = 0 · `ordemservplanejentrega` 162.028 (agendamento usado, expedição não).
- **Consequência:** controle de "cliente já levou?" é feito manualmente pelo relatório de
  Faturamento (ver `regras-de-negocio.md` §9).

## 7. Como reproduzir (somente leitura)
```bash
MYSQL_PWD='<senha>' mysql -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "
SELECT p.CODIGO, p.SEQUENCIAL, p.DESCRICAOEQUIPAMENTO, p.TIRAGEM, p.STATUS, p.TIRAGEMAPONTADA, p.DATAINICIO, p.DATAFIM
FROM pcpprocessos p WHERE p.EMP_ID=1 AND p.CODIGOTRABALHO=58329 ORDER BY p.SEQUENCIAL;
SELECT a.CODIGOOPERADOR, COUNT(*), SUM(a.TEMPOTOTAL) FROM pcpapontamento a
WHERE a.EMP_ID=1 AND a.CODIGOTRABALHO=58329 GROUP BY a.CODIGOOPERADOR;"
```

## 8. Parâmetros PCP (`_parametrospcp`)
`PERMITIRAPONTTODOSFILA`, `TEMPOMINIMOEXECUCAO`, `MOVERTRABALHOTOTALINICIOFILA`,
`APONTARPROCESSOMESMOTRABALHO`, `MANTERDEPENDENCIAREMANEJAR`, `OCULTARJAHEXECUTADOS`,
`TIPOPROGRAMACAO`, `TEMPOINTERVALOPROXIMATAREFA`, `MODOAPONTAMENTO`, `PERMITIRPROGRAMARMANUAL`,
`PERMITIRAPONTARVARIOSPROCTRAB`, `AGRUPARVIASCOMPBLOCO`, `SENHAPARAAPONTAR`,
`PERMITIRAPTVAROPMESMOEQUIP`, `MOSTRARCLIENTEQUADROGERAL`, `TAMANHOFONTEQUADROGERAL`.

## 9. Pontos de atenção para redesenho
- `pcpapuracao`/`pcpapuracaoitem` vazias → o pós-cálculo de custo real não roda; colunas
  `VLR_*_REALIZADO` da OP ficam zeradas.
- `PCPCODIGOSTATUSOP` nunca preenchido → status PCP não é refletido na OP; usar `ordemservicostatus`.
- Status `E`/`S` em `pcpprocessos` mal documentados (sem tabela de referência).
- Expedição (`pcpexpedicao`/`pcpprocessoentrega`) mistura produção e entrega; sem vínculo real com
  `expedicaopedido`/faturamento.
