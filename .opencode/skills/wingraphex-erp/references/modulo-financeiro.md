# Módulo Financeiro do Wingraphex (ERP) — levantamento 11/08/2026

> Baseado em consultas somente leitura ao banco de produção + dump do schema. Medidas reais.

## Visão geral
- Tabela central: **`financeiro`** (236.554 lançamentos, ~413 MB) — mistura título, baixa, baixa
  parcial e estorno num único PK composto.
- Extensões: `pagar`, `receber` (detalhes por tipo de título), `cheque`/`chequebaixas`,
  `carteira`/`carteiraparametros`, `banco`, `contabancaria`, `formapagto`/`formapagtoparcela`, `meiospagamento`.
- **Não há tabela "caixa"** — fechamento de caixa é operacional via `financeiro` + `contabancaria`.

## 1. Chave e mecânica do lançamento (`financeiro`)
- PK: `EMP_ID + CHAVE + CHAVEBAIXAPAGAR + CHAVEBAIXARECEBER`.
- `CHAVE` = chave do título · `CHAVEBAIXARECEBER`/`CHAVEBAIXAPAGAR` = sequencial da baixa (0 = título original).
- Origem dos lançamentos (`ORIGEM`, contagens reais):

| ORIGEM | Qtde | Total | Significado |
|---|---:|---:|---|
| TOL_BAIXACONTASREC | 110.492 | 64,2 M | recebimento/baixa de título |
| TOL_CONTASARECEBER | 102.204 | 83,6 M | emissão de título (a receber) |
| TOL_BAIXACONTASPAGAR | 10.897 | 6,6 M | pagamento/baixa a fornecedor |
| TOL_CONTASAPAGAR | 9.673 | 5,3 M | emissão de título a pagar |
| TOL_MOVIMENTOMANUAL | 3.165 | 533 k | lançamento manual |
| TOL_ESTORNOBAIXAREC | 102 | 177 k | estorno de baixa a receber |
| TOL_ANTCREDITO / TOL_BAIXAANTCREDITO | 11+5 | — | adiantamento de crédito |
| TOL_ESTORNOBAIXAPAG | 4 | 2,5 k | estorno de baixa a pagar |

- **PREVISAO**: N = 228.143 · S = 8.411 (títulos a vencer gerados como previsão, `TOL_CONTASARECEBER`).

## 2. Mecânica título → baixa (verificada)

### Baixa simples (PIX) — DOC 93317 (1.300,00)
| CHAVE | CHAVEBAIXAREC | ORIGEM | Meio | Valor | Saldo | Data |
|---:|---:|---|---|---:|---:|---|
| 259411 | 0 | TOL_CONTASARECEBER | — | 1.300,00 | 650,00 | venc 10/08 |
| 259411 | 1 | TOL_BAIXACONTASREC | **24 (PIX)** | 650,00 | 0,00 | pago 10/08 |

### Baixa parcial (múltiplos recebimentos) — DOC 93319 (5.250,00)
- Título 259419 (5.250,00) recebeu **2 baixas**: 703,50 + 4.546,50 = 5.250,00 (ambas PIX, 11/08) → saldo 0.
- DOC 93320 (242,00): 3 baixas **119,00 + 93,00 + 30,00** → saldo 0. É assim que "paga conforme retira o material" é feito na prática.

### Em aberto — DOC 93318 (171,45)
- CHAVE 259413 (`TOL_CONTASARECEBER`), saldo 171,45, venc 10/08 — **ainda não baixado** (mesmo quando o cliente pagou antecipado em outros casos).

## 3. Estorno e cancelamento
- `ESTORNO='S'`: 1.119 lançamentos · `FLAGLANCCANCELADO='S'`: 2.158.
- Fluxo de estorno (ex. CHAVE 4): `TOL_CONTASARECEBER` (cancelado) + `TOL_BAIXACONTASREC` + `TOL_ESTORNOBAIXAREC` — o estorno reabre o título.
- `RENEGOCIACAO` (S/N), `CHAVEBAIXAPAI`/`CHAVEBAIXARECEBERPAI` para baixas vinculadas/renegociadas (1.962 com pai).

## 4. Campos financeiros relevantes
- Valores: `VALOR`, `VALORTOTAL`, `SALDO`, `ACRESCIMO`, `DESCONTO`, `PERCJUROS`, `VALORJUROS`,
  `PERCMULTA`, `VALORMULTA`, `VALORDOCORIGEM`, `VALORPARCELADOCORIGEM`, `DESPESABANCARIA`.
- Datas: `DATACONTABIL`, `DATALANCAMENTO`, `DATAEMISSAO`, `DATAVENCIMENTO`, `DATAPREVISTA`,
  `DATAPAGAMENTO`, `DATALIQUIDACAO`.
- Partidas: `DEBITOCODREDUZIDO`/`DEBITOCODCONTABIL`, `CREDITOCODREDUZIDO`/`CREDITOCODCONTABIL`
  (plano de contas), `CODIGOHISTORICO`/`DESCRICAOHISTORICO`.
- Origem do documento: `DOC_ID`, `CLASSIFICACAO`, `SEQUENCIALITEM`, `NRODOCORIGEM`, `SERIEDOCORIGEM`,
  `NRO_OP` (8.403 preenchidos), `NUMEROTITULO`.
- Pagamento: `MEIOPAGAMENTO`, `TIPOPAGAMENTO` (1=No Prazo/Adiantado 112.399 · 2=Em Atraso 412 ·
  4=Adiantado 7; vazio 115.044), `CODIGOCONTABANCARIA`, `NUMEROCONTABANCARIA`, `COMISSAOPGAANTECIPADA`.
- Usuários: `CODIGOUSUARIO`/`NOMEUSUARIO`/`LOGINUSUARIO` + últimos (`ULTIMONOMEUSUARIO` etc.).

## 5. A receber / a pagar
- **`receber`**: estende `financeiro` (CHAVE) com banco/carteira, boleto (BOLETOENVIADOEMAIL,
  DATAENVIO), liquidação duvidosa. Ex.: CHAVE 259413 → `CODIGOBANCO=2`, `CODIGOCARTEIRA=1`.
- **`pagar`**: estende `financeiro` com `TIPODOCUMENTO`, `PERCCORRECAODIARIA`.
- **Contas a pagar reais** (comissões, empréstimos, fornecedores): `NUMEROTITULO` = `COMI:160876`,
  `COMISSÃO:160168`, `EMP.138760`, datas de venc 2026.

## 6. Cheques (`cheque`/`chequebaixas`)
- Chave `CHE_ID`; dados: banco, agência, conta, número, emitente (nome+CNPJ/CPF), cidade/UF, valor,
  data emissão/vencimento, contabancaria, usuário.
- **STATUS**: `TCHS_NAOCOMPENSADO` (5.804) e `TCHS_RESGATADO` (3).

## 7. Bancos, contas e carteiras
- `banco`: 1 Banco do Brasil · 2 **Caixa Interno** (341) · 3 Caixa Econômica Federal.
- `contabancaria` (10 contas, ex.: 1 C/C BB, 2 Caixa Interno, 3 Dinheiro, 4 Cheque, 6 Cartão Débito,
  8 C. Crédito, 9 Depósito Bancário, 11 Desconto, 12 Empréstimo): campo `INCLUIRFLUXOCAIXA` marca conta de caixa.
- `carteira`: banco, conta, cedente, taxa boleto/duplicata, posição corrente, numeração inicial/final,
  layouts de remessa/retorno, juros/multa. Carteira 1 → banco 2 (Caixa Interno), `EMISAOBLOQUETO`.
- `tipodocumentofinanceiro`: Bloqueto, Cheque, Duplicata, Nota Fiscal, Nota Promissória, Recibo, Carnê, Outros, Sem Documento.

## 8. Formas de pagamento (`formapagto`)
28 formas por empresa (empresa 1):

| FOP | Descrição | Tipo | Dias | Desativado |
|---|---|---|---:|---|
| 1 | A VISTA - ESPECIE (ATO DE ENTREGA) | A_VISTA | 0 | N |
| 2 | 01 BOLETO PARA 30 DIAS | A_PRAZO | 30 | N |
| 11 | PROMISSORIA | A_PRAZO | 30 | N |
| 12 | **ENTRADA 50% E ATO DE ENTREGA EM DINHEIRO** | A_VISTA | 240 | **S** |
| 13 | CARTÃO DE CRÉDITO | A_VISTA | 0 | N |
| 14 | ENTRADA + 01 BOLETO PARA 30 DIAS | A_PRAZO | 30 | N |
| 15-28 | BOLETOS/DUPLICATAS/CHEQUES em n parcelas | A_PRAZO | — | N |
| 50 | SINAL | A_PRAZO | 30 | **S** |

> ⚠️ A forma **12 "ENTRADA 50% E ATO DE ENTREGA EM DINHEIRO"** está cadastrada porém **desativada (S)**.
> Na prática, 50/50 e "paga conforme retira" são feitos como **baixa manual parcial** (vários
> lançamentos PIX), não por forma cadastrada. `FOP_PERCJUROS`: cheque 30/60/90 = 6%, 30/45/60 e
> 30/60 = 4,5%. `formapagtoparcela` define parcelas (`FPP_NROPARCELA`, `FPP_QTDIAS`, `FPP_PERCPARCELA`).

## 9. Meios de pagamento (`meiospagamento`, 26 códigos)
1 Dinheiro · 2 Cheque · 3 Depósito · 4 Transferência · 5 DOC · 6 TED · 7 Permuta · 8 Boleto ·
9 Duplicata · 10 Outros · 11 Débito Automático · 12 Débito Programado · 13 Cartão Débito ·
14 Cartão Crédito · 15 Desconto · 16 Crédito Loja · 17-20 Vale (Alimentação/Refeição/Presente/Combustível) ·
21-23 (outros) · 24 **PIX** · 25/26 (transferência/fidelidade).
> Uso real em baixas recentes (10-11/08/2026): **todos PIX (24)**.

## 10. Exemplo ponta a ponta (OP 162056 / DOC 93318)
```
CI 208132 (10/08) ──► financeiro CHAVE 259413 (TOL_CONTASARECEBER, 171,45, venc 10/08)
                          saldo 171,45 — NÃO baixado ainda
```
Faturamento cria o título; a baixa (recebimento) é o segundo passo, feito manualmente.

## 11. Como reproduzir (somente leitura)
```bash
MYSQL_PWD='<senha>' mysql -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "
SELECT CHAVE, CHAVEBAIXARECEBER, ORIGEM, DOC_ID, MEIOPAGAMENTO, VALOR, SALDO, DATAPAGAMENTO
FROM financeiro WHERE EMP_ID=1 AND DOC_ID IN (93317,93318,93319,93320) ORDER BY DOC_ID, CHAVEBAIXARECEBER;
SELECT FOP_ID, FOP_DESCRICAO, FOP_TIPOPAGTO, FOP_DESATIVADO FROM formapagto WHERE EMP_ID=1;"
```

## 12. Parâmetros financeiros (`_parametrofinanceiro`)
`CODIGOCARTEIRAPADRAO`, `PERCJUROSRECEBATRASO`, contas padrão (juros, comissões, transferência),
`TIPOPAGAMENTOPADRAO`, `MEIOSPAGAMENTOPADRAO`, `CONTABANCARIAPADRAO`, `USARCONTAVENDEDORCOMISSAO`,
`EFETIVACOMISSAOPROVLRBAIXA`, `CONTROLARCHEQUE`, `EFETIVARCOMISSAOCOMPCHEQUE`.

## 13. Pontos de atenção para redesenho
- `financeiro` mistura título, baixa, baixa parcial e estorno num único PK — normalizar em `lancamento`/`baixa`/`estorno`.
- Data padrão `1899-12-30` em título não baixado (flag de "não pago") — substituir por NULL.
- `NRO_OP` só preenchido em 8.403 de 236k — ligação confiável com OP é via `DOC_ID`.
- Formas 50/50 e "paga conforme retira" não são modeladas — apenas baixa manual parcial.
