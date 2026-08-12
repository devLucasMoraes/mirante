# Regras de negócio do Wingraphex (ERP) — levantamento 11/08/2026

> Baseado em consultas somente leitura ao banco de produção + dump do schema. Medidas e exemplos reais.

## 1. Módulos e uso real
- **9 módulos no total:** Orçamento, Faturamento, Financeiro, Estoque, PCP, Balcão, CRM, Custos, Bremen.net (relatórios).
- **Em uso real (só 4):** Orçamento, Faturamento, Financeiro, PCP. Balcão não tem tabelas próprias (usa `documento*`).

## 2. Dimensões do negócio
| Item | Valor | Detalhe |
|---|---|---|
| OPs (`ordemservico`) | **162.027** | de 2007-07-07 a 2026-08-10 |
| Tipo de processo | **100% offset plana** | `op.TIPOPROCESSO = TP_OFFSETPLANA` |
| Produto/serviço | **TI_SERVICO dominante** | ~155 mil serviço vs ~1 produto revenda |
| Documentos fiscais | **93 mil** | CI (interna) 91.482 · NF série 1 (SEFAZ) 1.651 |
| Títulos financeiro | **~236 mil** | 18.396 em aberto (SALDO>0) na empresa 1 |
| Materiais | **284 mil** | TC_PRODUTO 323k · TC_MATERIAPRIMA 274 · TC_SERVICO 2 |
| Empresas | **2** | `EMP_ID` 1 e 2; cadastros duplicados por empresa |

## 3. Fluxo operacional fim a fim

```
orcamento 171415 ──> ordemservico 162056 ──> documentoitem ──> documentocabecalho
(custo 119,48)      (ORS 171,45)             DOC 93318          CI 208132 (10/08)
                                                                      │
                                                                financeiro
                                                          CHAVE 259413 (venc 10/08)
                                                          ainda NÃO baixado (saldo 171,45)
```

1. **Orçamento** → gera a **Ordem de Produção (OP)**. **OP só é gerada quando o orçamento é aprovado** (`ORC_ORDEMSERVICO='S'` + log "Geração de O.P.").
2. A OP é **programada** → fica visível no **PCP** → operadores de máquina informam status (tabelas `op`, `ordemservico`, `pcptrabalhos`/`pcpprocessos`).
3. **Faturamento** (o ato): pedido pago → gera **CI** (nota fiscal interna, documento). Exceção: se o cliente **exige nota de produto** → **NF série 1** (integrada SEFAZ) — somente sob pedido.
4. **Financeiro:** dão baixa nos pedidos, informam o tipo de pagamento, fazem conciliação + fechamento de caixa.

> Prática comum: emitem a nota apenas para o cliente **assinar e pagar depois** (pré-pagamento) — ponto de atenção do usuário.

### Encadeamento de chaves (verificado, sem FKs declaradas)
1. `orcamento.ORC_ID` → `ordemservico.ORC_ID` (OP nasce do orçamento)
2. `ordemservico.ORS_ID` (PK) → `op.ORS_ID` (mesma chave; `op` guarda saldo/processo)
3. `documentoitem.CODIGOORDEMPRODUCAO` = `ORS_ID` (item da nota aponta a OP)
4. `financeiro.DOC_ID` + `CLASSIFICACAO` → `documentocabecalho` (título nasce do documento)
5. `financeiro.NRO_OP` existe mas **nem sempre preenchido** (só 8.403 de 236.554) — ligação confiável é via `DOC_ID`
6. Relacionamento sempre por convenção (colunas com índice MUL), nunca FK declarada

## 4. Modalidades de pagamento
- Antecipado
- Na retirada do material
- A prazo (retira e paga depois)
- **Flexível:** ex. 50/50 ou **paga conforme vai retirando o material**
- ⚠️ **Não há forma de pagamento ativa para 50/50 ou "paga conforme retira".** As formas cadastradas para isso (FOP 12 "Entrada 50% e ato de entrega em dinheiro", FOP 50 "Sinal") estão **desativadas** (`FOP_DESATIVADO='S'`). Na prática isso é feito como **baixa manual parcial** (vários lançamentos, ex. PIX) no financeiro — ver `modulo-financeiro.md`.

## 5. Regra de precificação (fórmula verificada)
Exemplo real `orcamento 171415` (1.905 unid.): Papel 38,64 · Custo total **119,48** · Impostos **27,28** · Preço a prazo **171,45**.

```
qtorcamento (QTO_*)  ─→  ordemservico (ORS_*)  (espelho completo, prefixo QTO/ORS)
  QTO_VLCUSTO            ORS_VLCUSTO          (papel+tinta+chapa+serviço+acabamento+lavagem+acerto)
  QTO_VLRIMPOSTOS        ORS_VLRIMPOSTOS      (ICMS+IPI+PIS+COFINS+ISS+IR+CSLL+SIMPLES)
  QTO_VLRFINALPRAZO      ORS_VLRFINALPRAZO    = custo + impostos + margem
  QTO_VLRFINALVISTA      ORS_VLRFINALVISTA    (à vista)
```
- Margem/comissão: `QTO_PERCMARGEMLUCRO`, `QTO_VLRCONTRIBMARGINAL`, `QTO_PERCCOMVENDEDOR`, `QTO_VLRCOMVENDEDOR`.
- Variantes sem IPI: `*_SEMIPI`, `VLRBRUTOVISTA`/`VLRBRUTOPRAZO`.
- **Custos realizados** (pós-produção): `VLR_CUSTO_REALIZADO`, `VLR_TOTAL_REALIZADO`, `PER_MARGEMLUCRO_REALIZADO` etc. — ficam **0/zerados** na prática (apuração pós-cálculo não roda; ver `modulo-pcp.md` §"pcpapuracao vazia").
- Detalhe completo da fórmula (papel/impostos individualizados/margem negativa frequente) → `modulo-orcamento.md`.

## 6. Status da OP (12 estados)
Tabela `tipostatusordemservico` (código→descrição) + `ordemservicostatus` (histórico/auditoria por mudança):

| Código | Descrição | Qtde registros |
|---|---|---:|
| 1 | Aberto | 193.232 |
| 3 | Faturada | 166.883 |
| 11 | Baixada para Faturamento | 78.927 |
| 2 | Produção | 54.769 |
| 6 | Cancelada | 2.314 |
| 5 | Baixada | 342 |
| 9 | Faturada Sem Baixa | 24 |
| 12 | Encerrada | 16 |
| 4 | Pré-faturada | 15 |
| 7-10 | (raros/novos) | — |

- Estado **atual** da OP: `ordemservico.ORS_STATUSFATURAMENTO` (TSF_AFATURAR / TSF_FATURADA). `PCPCODIGOSTATUSOP` fica quase sempre NULL/0 (não usar).
- Histórico lançado pelos operadores PCP: `ordemservicostatus` (CODIGO 1-12, DATA, CODIGOUSUARIO, JUSTIFICATIVA).

## 7. Faturamento — CI vs NF série 1
- **Série `CI` = 91.482 documentos** → Conta Interna (sem SEFAZ) — **padrão da casa**.
- **Série `1` = 1.651 documentos** → NF-e produto, integrada SEFAZ — **somente quando o cliente exige nota de produto**.
- Série `PRE` = pré-fatura · `NC`/`PC` = compra · `M1`/`S2` = séries secundárias.
- `tipodocumento.CLASSIFICACAO`: 0=NF · 1=Pedido/Compra/Orçamento · 2=Pedido de venda/pré-fatura · 3=Pedido de compra.
- `naturezaoperacao` define flags de geração (GERARESTOQUE, GERARFATURAMENTO, GERARCOMISSAO) por CFOP.
- Status NF-e (`nfe.STATUS`): TTS_DANFEIMPRESSO(1599) · TTS_CANCELADA(79) · TTS_REJEICAO(42) · TTS_AUTORIZADA(1).
- Detalhe completo (estrutura de documento, exemplos reais, parâmetros) → `modulo-faturamento.md`.

## 8. Financeiro — baixa e pagamentos
### Mecânica da baixa (`CHAVE` ↔ `CHAVEBAIXARECEBER`)
- Título original: `ORIGEM=TOL_CONTASARECEBER`, `SALDO=VALOR`, `CHAVEBAIXARECEBER=0`.
- Baixa: `ORIGEM=TOL_BAIXACONTASREC`, novo `CHAVE`, `CHAVEBAIXARECEBER`=CHAVE do título.
- **Baixa parcial:** um mesmo título pode ter vários lançamentos de baixa (ex. 30+119+93) — é assim que "paga conforme retira" e 50/50 funcionam na prática.
- Título liquidado quando soma das baixas = VALOR (SALDO→0); `DATALIQUIDACAO` registra.
- `TIPOPAGAMENTO`: 1=No Prazo/Adiantado (dominante) · 2=Em Atraso · 3=Em Cartório · 4=Adiantado.

### Meios de pagamento (`meiospagamento`)
1 Dinheiro · 2 Cheque · 3 Depósito · 4 Transferência · 5 DOC · 6 TED · 8 Boleto · 9 Duplicata · 10 Outros · 11 Débito automático · 13 Cartão débito · 14 Cartão crédito · 15 Desconto · 23 Depósito bancário · **24 PIX** · 25/26 outros.
> Uso histórico na baixa: 1=Dinheiro(51k) · 2=Cheque(23k) · 3=Depósito(18k) · 8=Boleto(5k) · 14=Cartão crédito(4k) · 13=Cartão débito(3k) · 24=PIX (em forte crescimento — toda a atividade recente, 10-11/08/2026, é 100% PIX).

- Comissões/estornos e detalhe completo (formas de pagamento, cheques, bancos/carteiras) → `modulo-financeiro.md`.

## 9. Problema confirmado: controle de retirada/entrega
- **Não existe status nem campo "retirada/entrega/expedição"** na OP, no documento nem no financeiro.
- Sistema de entrega do PCP (`pcpexpedicao`, `expedicaopedido`) é **quase não utilizado**: `expedicaopedido` só tem **4 registros** (série PRE); `pcpexpedicao` tem 22k registros mas de **produção**, não de entrega ao cliente.
- `ordemservicolog` (68k linhas de texto livre) tem **0 menções** a entrega/retirada/expedição.
- Por isso o controle de "já levou?" é feito manualmente pelo **relatório de Faturamento** — workaround, já que o sistema de entrega do PCP é difícil/chato de usar.
- **Maior problema real:** quando o cliente **paga antecipado**, não sabem se ele **já levou ou não o pedido** — o título nasce pago mas o material pode seguir na fábrica.
- Campo pouco usado mas disponível: `ordemservico.ORS_DATALIBERACAOFAT` (113k preenchidos); `documentocabecalho.DATALIBERACAO` só 2 registros.
- Detalhe PCP/expedição → `modulo-pcp.md` §6.

## 10. Estoque e produção (visão rápida)
- `estoque.ORIGEM`: **EP** (baixa produção, 535k) · **BR** (baixa/consumo, 263k) · **NF** (entrada por nota, 73k) · **OP** (baixa automática da OP, 87k) · AC (acerto) · PC/EM (outros).
- `ordemservico.ORS_CLASSIFICACAO`: VE (venda, dominante) · IN (insumo) · PM (produção própria).
- `estoque` referencia `CODIGOOS` + `DOC_ID`/`CLASSIFICACAO`/`SEQUENCIALITEM` (mesma chave da venda).
- Requisição de material p/ produção: `requisicaoestoque`(+item).

## 11. Técnica (para reprodução/migração)
- **MySQL 5.7.26**, banco `wingraphex`, charset base **latin1** — colunas com acentuação, sempre usar `--default-character-set=utf8` ao consultar.
- 558 tabelas, 552 InnoDB + 5 MyISAM + 1 view; ~5,1 GB.
- Sem triggers, sem eventos; 3 funções + 2 procedures (corpo não extraído — sem privilégio `SHOW CREATE FUNCTION`).
- **Colunas double(18,8)** em todo dinheiro — em destino moderno usar `NUMERIC(18,8)`.
- `DATA_ALTERACAO`/`USER_ALTERACAO` em todas as tabelas (auditoria útil p/ "mais recentes").
- `_dicionario` (7.321 registros) traduz tabela/campo físico → nome de negócio em português — consultar ao mapear tabela desconhecida.
- ⚠️ `_segusuario.USU_SENHA` em texto claro — nunca usar/expor; `_configsistema` tem colunas ofuscadas.

## 12. Pontos de atenção para redesenho (se for reconstruir o sistema)
- Modelar **"retirada/entrega" como entidade de negócio** própria (status na OP + data de retirada + usuário) — resolve o problema real do negócio.
- Substituir colunas `*_REALIZADO` zeradas por uma tabela de custo realizado bem definida (a apuração hoje não roda).
- Normalizar `financeiro` (hoje mistura título, baixa, baixa parcial e estorno num único PK composto) em `lancamento`/`baixa`/`estorno`.
- Separar `_segusuario` vs `_segusuario2` (duplicidade de credenciais) e hashear senhas.
- Padronizar utf8mb4 e validar acentuação na migração de latin1.
