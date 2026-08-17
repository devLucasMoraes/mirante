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

## 10. 2026-08-16 — Equipamento vs máquina, apontamentos e datas (amostra local, 143 processos)
- **O que foi verificado** (réplica local porta 3308; produção `192.168.1.16` inacessível da rede
  doméstica — validação usa a amostra de `02-dados.sql`): relação `pcpprocessos` →
  equipamento/máquina, conteúdo dos apontamentos e preenchimento de início/fim.
- **Resultado:** validado na amostra (38 F / 105 P). Ver observações para os desvios encontrados.

### 10.1 Equipamento é obrigatório; máquina é opcional
- `CODIGOEQUIPAMENTO`/`DESCRICAOEQUIPAMENTO`: **preenchidos em 143/143** (100%). É o centro de
  trabalho (ex.: `SM 105 (MOISES)`, `SM 52 (LAZARO)`, `CTP`, `GUILHOTINA`, `MONTAGEM`,
  `DOBRA MECANIZADA 5 DOBRAS (JUNIOR)`, `EMBALAGEM`, `ARTE FINAL`, `CARTAO DE VISITA`, `ENTREGAS`).
- `CODIGOMAQUINA`/`DESCRICAOMAQUINA`: **opcional**. Amostra: 35/38 F e 44/105 P têm máquina.
  Finalizados sem máquina: `CTP`, `MONTAGEM`, 1× `SM 52` — pré-impressão/operação manual sem máquina física.
- **Descrição é cópia denormalizada (não é join):** mesmo `CODIGOEQUIPAMENTO=21` aparece como
  `SM 102` ou `SM 105 (MOISES)` (rank de nome muda com o tempo). Vínculo confiável é pela chave
  `CODIGOEQUIPAMENTO`; `DESCRICAO*` é snapshot.
- Catálogos em tabelas próprias (ausentes da amostra até 16/08; agora incluídos em `extrai-dados.sh`):
  `equipamento` (centro + `CODIGOOPERADOR`, `PREPRODUCAO`), `maquina` (física, `MAQ_ID`, `MAQ_QTCORES`),
  `equipamentomaquinas` (**N:N** equipamento×máquina×`CODIGOTAREFA`). Para conferir "nome correto"
  oficial: comparar `pcpprocessos.DESCRICAOEQUIPAMENTO` com `equipamento.DESCRICAO` via produção.

### 10.2 Estrutura do apontamento (`pcpapontamento`)
- Ligação por (`CODIGOTRABALHO`, `CODIGOPROCESSO`); `CODIGO` sequencia a "ficha" de tempo do processo.
- Campos por apontamento: `CODIGOOPERADOR`, `CODIGOTIPOTEMPO` (0 instante · 1 produção · 2 preparação ·
  3 tempo/intervalo · 4 · 5), `DATAHORAINICIAL`→`DATAHORAFINAL`, `TEMPOTOTAL` (**segundos**),
  `TIRAGEMAPONTADA`, `QTFOLHASPEDACOS`, `QTFINALAPONTADA`, `TIPOAPONTAMENTO='T'`.
- **Encadeamento:** `DATAHORAFINAL` de um apont = `DATAHORAINICIAL` do próximo → o intervalo real do
  processo é a trilha de apontamentos, não as datas do processo.
- **`TEMPOTOTAL=0` é comum** (apontamentos tipo 0 de fechamento). Exemplo real: processo `61282/1`
  (SM 105) = 3 aponts, tipo 4 com `TIRAGEMAPONTADA=950` e `TEMPOTOTAL=20.523s`.
- Cobertura: 36/38 F têm ≥1 apontamento; `62364 (SM 52)` e `62550 (CTP)` marcados F **sem** apontamento.
- `DURACAO` do processo **não** é soma dos apontamentos (é previsão do planejamento; quantidade pequena,
  aparentemente em minutos) — não usar como realizado.

### 10.3 Início/fim no processo vs no apontamento
- `pcpprocessos.DATAINICIO/DATAFIM`+`HORAINICIO/HORAFIM`: 36/38 F completos; **2 F sem DATAFIM**
  (OP 62223: **pai** proc 11 SM 52 e proc 13 CTP — ver 10.4) — mesmo `STATUS='F'` e com apontamentos,
  as datas do processo podem faltar.
- `pcpapontamento`: **todos** os apontamentos têm `DATAHORAINICIAL`/`DATAHORAFINAL`.

### 10.4 Modelo pai/filho dos processos (multiplicação por componente — VERIFICADO 16/08)
- Não é "lixo de reprogramação": a duplicação é um **modelo hierárquico pai/filho** via
  `CODIGOPROCESSOVINCULADO`/`CODIGOTRABALHOVINCULADO`:
  - **Pai** = processo no nível da OP, **sem componente** (`TIPOCOMPONENTE` vazio, `CODIGOCOMPONENTE=-1`),
    `CODIGOPROCESSOVINCULADO=NULL`, um por equipamento (ex.: OP 62223 procs 11/12/13/14).
  - **Filhos** = um processo **por componente/via/miolo**, todos **apontando para o pai**
    (ex.: 62223 procs 1 e 6 → pai 11; procs 4 e 8 → pai 13).
- **`DURACAO` do pai = SOMA das durações dos filhos** (rollup, não produção nova):
  SM 92=46+46 · GUILHOTINA 80=40+40 · CTP 16=15+1 · ENTREGAS 2=1+1.
- **Apontamentos espelhados** em pai + filhos (mesmo operador, mesmos `DATAHORAINICIAL/FINAL`).
- Nem todo processo tem pai: `EMBALAGEM`/`MONTAGEM` são de nível OP (vinculado NULL, sem par);
  só processos "por componente" (impressão/CTP/corte/entrega) têm pai.
- Pai e filhos são criados **no mesmo evento** (OP 61791: tudo 2026-05-06 16:39 por `leilan`) —
  não é versão antiga abandonada.
- `SEQUENCIAL` chega a ser **igual entre pai e o 1º filho** (11263/11402/12400) e 0 em outros —
  **não confiável como chave**.
- **Regra de ouro de relatório:** contar produção com **só os filhos**
  (`CODIGOPROCESSOVINCULADO IS NOT NULL`, equivale a `CODIGOCOMPONENTE<>-1`) **ou só os pais** —
  nunca ambos. Tempo real: apontamentos espelhados → somar um dos grupos (pai = total, filhos = por via).

### 10.5 Como reproduzir (somente leitura, réplica 3308 ou produção)
```sql
-- Vínculo equipamento (obrigatório) x máquina (opcional) por status
SELECT STATUS, COUNT(*) qtd, SUM(CODIGOMAQUINA<>'') com_maq
FROM pcpprocessos WHERE EMP_ID=1 GROUP BY STATUS;
-- Drift de nome (mesmo código, nomes distintos)
SELECT CODIGOEQUIPAMENTO, COUNT(DISTINCT DESCRICAOEQUIPAMENTO) nomes
FROM pcpprocessos WHERE EMP_ID=1 GROUP BY CODIGOEQUIPAMENTO HAVING nomes>1;
-- Apontamentos por processo finalizado
SELECT p.CODIGOTRABALHO, p.CODIGO, p.DESCRICAOEQUIPAMENTO, p.DURACAO,
  COUNT(a.CODIGO) aponts, IFNULL(SUM(a.TEMPOTOTAL),0) seg_apont
FROM pcpprocessos p
LEFT JOIN pcpapontamento a ON a.EMP_ID=p.EMP_ID AND a.CODIGOTRABALHO=p.CODIGOTRABALHO
  AND a.CODIGOPROCESSO=p.CODIGO
WHERE p.EMP_ID=1 AND p.STATUS='F'
GROUP BY p.CODIGOTRABALHO, p.CODIGO, p.DESCRICAOEQUIPAMENTO, p.DURACAO;
-- Pai x filhos (rolagem de duracao e apontamento espelhado)
SELECT p.CODIGOTRABALHO, p.CODIGO pai, p.DESCRICAOEQUIPAMENTO, p.DURACAO dur_pai,
  c.CODIGO filho, c.TIPOCOMPONENTE, c.DESCRICAOCOMPONENTE, c.DURACAO dur_filho
FROM pcpprocessos p
LEFT JOIN pcpprocessos c ON c.EMP_ID=p.EMP_ID
  AND c.CODIGOTRABALHOVINCULADO=p.CODIGOTRABALHO AND c.CODIGOPROCESSOVINCULADO=p.CODIGO
WHERE p.EMP_ID=1 AND p.CODIGOPROCESSOVINCULADO IS NULL
ORDER BY p.CODIGOTRABALHO, p.CODIGO, c.CODIGO;
```

> Regra de ouro: `EMP_ID` no WHERE; apontamentos em segundos; datas do banco `1899-12-30` = não preenchido.
> Catálogos `equipamento`/`maquina`/`equipamentomaquinas` foram adicionados a `docker/wingraphex/scripts/extrai-dados.sh` (16/08) — regenerar a amostra com acesso à produção para validar o nome canônico.

## 11. 2026-08-16 — Cadeia OP → trabalho → processo → equipamento (mapeamento verificado)
- **O que foi testado:** como a Ordem de Produção (`ordemservico`) chega aos equipamentos/processos.
- **Resultado:** validado na amostra local (38 OPs/trabalhos, 143 processos).

### 11.1 Cadeia de chaves (sem FKs declaradas — por convenção)
```
ordemservico (ORS_ID = nº da OP; ORS_CLASSIFICACAO='VE')
   │
   ├──▶ op ── 1:1 por ORS_ID ── TIPOPROCESSO='TP_OFFSETPLANA', ORS_SALDO (saldo a produzir)
   │
   └──▶ pcptrabalhos ── CODIGOOP = ORS_ID ── "programação da OP"
            │   CODIGO = chave intermediária (≠ ORS_ID; ex.: 60030, 60248…)
            │   (amostra: 1 trabalho/OP; produção: 40.492 trabalhos vs ~162k OPs → nem toda OP é programada)
            │
            └──▶ pcpprocessos ── CODIGOTRABALHO = pcptrabalhos.CODIGO (+ CODIGOOP denormalizado)
                     │
                     ├──▶ 1 equipamento (CODIGOEQUIPAMENTO = equipamento.CODIGO)  ← centro de trabalho (sempre)
                     ├──▶ 0..1 máquina (CODIGOMAQUINA = maquina.MAQ_ID)           ← máquina física (opcional)
                     ├──▶ pcpapontamento (CODIGOTRABALHO + CODIGOPROCESSO)        ← produção real
                     └──▶ catálogo equipamentomaquinas = N:N equipamento×máquina×CODIGOTAREFA
```
- **`ordemservico` não tem `TIPOPROCESSO`**; ele vive em `op.TIPOPROCESSO` (1 registro de `op` por OP).
- `pcpprocessos.CODIGOOP` é **denormalizado** (duplica `pcptrabalhos.CODIGOOP`) — útil para juntar
  direto de `pcpprocessos` para a OP sem passar por `pcptrabalhos`.
- Equipamento = "o que o PCP escala" (centro de trabalho); máquina = "onde rodou" (ver §10).

### 11.2 Números reais na amostra (1 OP = 1 trabalho = N processos)
| OP | processos | equip. distintos | F | c/ máquina | destaque |
|---|---:|---:|---:|---:|---|
| 159638 | 4 | 4 | 2 | 3 | SM105 + GUILHOTINA (F); EMBALAGEM/ENTREGAS (P) |
| 160700 | 6 | 6 | 3 | 4 | SM105 + CTP + GUILHOTINA (F) |
| 161529 | 5 | 5 | 1 | 4 | SM74 (F); DOBRA programada para 2029 |
| 161675 | 14 | **6** | 6 | 7 | multi-via: 1 pai + filhos por via (ver §10.4) |
| 161715 | 6 | 6 | 2 | 4 | SM102 executado **na máquina 14** (SPEED MASTER 74) |
| 162061 | 4 | 4 | 0 | 3 | `TSF_AFATURAR`, `ORS_SALDO=3000` — ainda não faturada |
| 162056 | 1 | 1 | 0 | 0 | só ENTREGAS (sem máquina) |

- **processos ≥ equipamentos distintos** — o modelo pai/filho por componente (ver §10.4) e OPs
  reprogramadas inflam a contagem de processos; usar `CODIGOCOMPONENTE<>-1` para os "efetivos".
- Saldo real de produção da OP está em `op.ORS_SALDO` e no faturamento, não no nº de processos.

### 11.3 Como reproduzir (somente leitura)
```sql
-- Cadeia completa com agregados por OP
SELECT o.ORS_ID, o.ORS_CLASSIFICACAO, op.TIPOPROCESSO, o.ORS_STATUSFATURAMENTO, op.ORS_SALDO,
  COUNT(DISTINCT t.CODIGO) trabalhos, COUNT(DISTINCT p.CODIGO) processos,
  COUNT(DISTINCT p.CODIGOEQUIPAMENTO) equipamentos, SUM(p.STATUS='F') proc_fim,
  SUM(p.CODIGOMAQUINA<>'') proc_com_maq
FROM ordemservico o
LEFT JOIN op ON op.EMP_ID=o.EMP_ID AND op.ORS_ID=o.ORS_ID
LEFT JOIN pcptrabalhos t ON t.EMP_ID=o.EMP_ID AND t.CODIGOOP=o.ORS_ID
LEFT JOIN pcpprocessos p ON p.EMP_ID=t.EMP_ID AND p.CODIGOTRABALHO=t.CODIGO
WHERE o.EMP_ID=1 AND o.ORS_ID IN (...)
GROUP BY o.ORS_ID, o.ORS_CLASSIFICACAO, op.TIPOPROCESSO, o.ORS_STATUSFATURAMENTO, op.ORS_SALDO;
-- Detalhe: processos por OP com equipamento/máquina/status
SELECT t.CODIGOOP, t.CODIGO, p.CODIGO, p.SEQUENCIAL, p.STATUS, p.CODIGOEQUIPAMENTO,
  p.DESCRICAOEQUIPAMENTO, p.CODIGOMAQUINA, p.DESCRICAOMAQUINA, p.DATAINICIO, p.DATAFIM
FROM pcptrabalhos t
LEFT JOIN pcpprocessos p ON p.EMP_ID=t.EMP_ID AND p.CODIGOTRABALHO=t.CODIGO
WHERE t.EMP_ID=1 ORDER BY t.CODIGOOP, t.CODIGO, p.CODIGO;
```

## 12. 2026-08-16 — Dimensão componente do processo
- **O que foi testado:** significado de `TIPOCOMPONENTE`/`CODIGOCOMPONENTE`/`DESCRICAOCOMPONENTE` nos processos.
- **Resultado:** validado na amostra (mesmo dia).

### 12.1 Valores observados
| `TIPOCOMPONENTE` | `CODIGOCOMPONENTE` | `DESCRICAOCOMPONENTE` | caso |
|---|---|---|---|
| `TL_FOLHA` | 1 | "Folha" | a maioria (1 componente) |
| `TL_VIA1` / `TL_VIA2` | 1 / 2 | "1ª Via" / "2ª Via" | produtos multi-via (formulários) |
| `TL_SERVGERAL` | 0 | "Serviço Geral" | 1 por OP (processo MONTAGEM) |
| *(vazio)* | **−1** | *(vazio)* | **processo-pai** da OP, sem componente (ver §10.4) |

### 12.2 Padrão (OPs 161237 e 161675, 2 vias)
- Cada via/componente **replica o mesmo conjunto de processos** contra os mesmos equipamentos:
  `SM (F) · CTP (F) · GUILHOTINA · ENTREGAS` (por via) + `EMBALAGEM` e 1 `MONTAGEM`
  (`TL_SERVGERAL`) **de nível OP** (sem par por via).
- Os processos de componente são **filhos** de um **processo-pai** por equipamento
  (`CODIGOPROCESSOVINCULADO` → pai, sem componente; ver §10.4).
- `NUMEROCADERNO` (=1 nos de produção, 0 em ENTREGAS/sem-componente) e `MONTAGEM`
  (= grupo de montagem, mesmo valor em toda a OP) qualificam cada processo.
- Em produtos multi-miolo (ex. OP 157682 da produção) a descrição vira "Miolo NN" — mesma mecânica de
  replicação por componente. **Não há tabela `componente`** (só `opflexocomponente`, do módulo flexo):
  o componente é atributo/índice de subproduto dentro da OP, não catálogo.
- Consequência para relatórios: agrupar produção por `TIPOCOMPONENTE`/`CODIGOCOMPONENTE` quando a OP
  tiver vias/miolos; **contar só filhos** (`CODIGOCOMPONENTE<>-1` / `CODIGOPROCESSOVINCULADO IS NOT NULL`)
  para não duplicar a produção do mesmo equipamento.

### 12.3 Como reproduzir (somente leitura)
```sql
SELECT CODIGOOP, TIPOCOMPONENTE, DESCRICAOCOMPONENTE, CODIGOCOMPONENTE,
  COUNT(DISTINCT CODIGO) processos, SUM(STATUS='F') proc_fim
FROM pcpprocessos WHERE EMP_ID=1
GROUP BY CODIGOOP, TIPOCOMPONENTE, DESCRICAOCOMPONENTE, CODIGOCOMPONENTE
ORDER BY CODIGOOP;
```
