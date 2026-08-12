# Módulo Faturamento do Wingraphex (ERP) — levantamento 11/08/2026

> Baseado em consultas somente leitura ao banco de produção + dump do schema. Medidas reais.

## Visão geral
- Tabelas núcleo: `documentocabecalho`, `documentoitem`, `documentocalculo`, `documentoitemcalculo`,
  `documentorodape` (+ apoio: `tipodocumento`, `naturezaoperacao`, `nfe`, `danfe`, `serienf`,
  `cfopoficial`, `ncm`).
- **Série `CI`** (nota interna, 91.482 documentos) é o padrão da casa; **série `1`** (NF-e produto
  integrada SEFAZ, 1.651) somente quando o cliente exige nota de produto.
- Chave dos documentos: `EMP_ID + CLASSIFICACAO + DOC_ID (+ SEQUENCIALITEM)`.

## 1. Camadas do documento (estrutura)
```
documentocabecalho (EMP_ID+CLASSIFICACAO+DOC_ID)
   ├── documentoitem (SEQUENCIALITEM)         → itens (descrição, qtd, unitário, CFOP, NCM, CSTs)
   ├── documentocalculo                       → totalizadores fiscais por documento
   ├── documentoitemcalculo                   → cálculo por item (espelha documentoitem)
   ├── documentorodape                        → transportadora, frete, volumes, peso
   ├── documentoitemcomissao                  → comissão por vendedor/agência por item
   ├── documentoitemexpedicao                 → expedição/entrega por item (ID_EXPEDICAOPED)
   └── documentoarquivos / documentoitemcomanda / documentoitemrastreabilidade / documentoitemimportacao
```

## 2. Cabeçalho (colunas-chave de `documentocabecalho`)
- Identificação: `CODIGOTIPODOC`, `SERIENF`, `NUMERONF`, `SERIENFFOR`/`NUMERONFFOR`, `NUMERODOCUMENTO`, `TIPODOCUMENTO`.
- Datas: `DATAEMISSAO`, `DATAENTREGA`, `DATAENTRADASAIDA`, `DATALANCAMENTO`, `DATALIBERACAO`, `DATACANCELAMENTO`.
- Venda: `CODIGOFORMAPAGTO`, `PERCJUROS`, `CODIGOPESSOA`, `CODIGOENDERECOPESSOA`, `CODIGOCONTATOPESSOA`,
  `CODIGOVENDEDOR`, `PERCCOMISSVENDEDOR`, `CODIGOCARTEIRA`, `CODIGOPERFILCOBRANCA`, `CODIGOPLANOCONTA`.
- Flags: `CANCELADA`, `FATURADA`, `PREFATURA`, `CONSUMIDORFINAL`, `NFEENVIADASEFAZ`, `DDARECEBIDO`,
  `BOLETORECEBIDO`, `RETERISS/INSS/IR/CSLL/PIS/COFINS/OUTRASRET`.
- SEFAZ: `CHAVENFE` (44 dígitos), `CHAVENFEVINCULADA`.
- Status/auditoria: `STATUSPEDIDO`, `DATAALTERACAOSTATUS`, `NOMEUSUARIOSTATUS`, `CODIGOUSUARIOLOGADO`, `NOMEUSUARIOLOGADO`.

## 3. Exemplo real CI — DOC 93318 (OP 162056 / ORC 171415)
- **1 item**: `1.905 CINTAS "SEU BROWNIE 80G..."` · CFOP **5.933** · qtd 1.905 · unitário **0,09** = **171,45**.
- `CODIGOORDEMPRODUCAO=162056`, `CODIGOORCAMENTO`, `GEROUESTOQUE=S`, `GEROUFATURAMENTO=S`.
- `documentocalculo`: brutos/produtos = líquido = faturado = **171,45** · todos impostos 0 (serviço, CI interna).
- Emitida 10/08/2026 por `psilva`; origem financeiro: CHAVE 259413 (`TOL_CONTASARECEBER`, 171,45, **sem baixa ainda**, saldo 171,45).

### Outras CIs recentes (10-11/08/2026)
| DOC | Pessoa | Itens | Líquido |
|---:|---:|---:|---:|
| 93317 | 5432 | 1 | 1.300,00 |
| 93319 | 28 | 1 | 5.250,00 |
| 93320 | 28 | 4 | 242,00 |
| 93315 | 9709 | 4 | 798,00 |
| 93312 | 9769 | 1 | 6.000,00 |

## 4. Exemplo real NF série 1 (produto/SEFAZ) — DOC 93250
- **1 item**: `05 JOGOS C/ 20 CHAPAS (05 POLICROMIAS) CTP...` · CFOP **5.101** · NCM **4821.10.00** · qtd 5 · unitário 140,00 = **700,00**.
- OP origem **162015** (5 unid., custo 501,998, prazo 700,00), `GEROUESTOQUE=S`, `GEROUFATURAMENTO=S`.
- `documentocalculo`: bruto = líquido = 700,00 · impostos 0 (serviços sem imposto destacado).
- NF-e (`nfe`): série 1, número 1978, **`TTS_REJEICAO`** (chave 2926...175912), FORMA TFE_NORMAL, enviada 30/07/2026 por Jodson.
- Financeiro: CHAVE 259172 (`TOL_CONTASARECEBER`, 700,00, **em aberto**, venc 30/07/2026).

> **Status NF-e** (contagem): `TTS_DANFEIMPRESSO` 1.599 · `TTS_CANCELADA` 79 · `TTS_REJEICAO` 42 ·
> `TTS_AUTORIZADA` 1 (série 1 = 1.823, série 2 = 24).

## 5. Totalizadores fiscais (`documentocalculo`)
Bruto/produtos/serviços, desconto, acréscimo, frete, seguro, outros, comissão; bases e valores de
**ICMS, ICMSST, ICMS-DIF, IPI, PIS, COFINS, ISS, INSS, IR, CSLL, Outras retenções, IBPT**
(federal/estadual/municipal), ICMS desonerado/FCP/DIFAL; **líquido** (`VALORTOTALLIQUIDO`) e
**faturado** (`VALORTOTALFATURADO`).

## 6. Comissões (`documentoitemcomissao`)
- Chave: `EMP_ID+CLASSIFICACAO+DOC_ID+SEQUENCIALITEM+CODIGOVENDEDOR`.
- `VEN_CLASSIFICACAO`: **TCV_VENDEDOR** (1.112 registros) e **TCV_AGENCIA** (29.400 registros).
- Exemplos reais: DOC 93104 vendedor 2 a 10% = 30,00 · DOC 92950 agência 4 a 15% = 42,00 · DOC 92322 vendedor 2 a 1% = 24,00.

## 7. Tipos de documento (`tipodocumento`)
| CLASSIFICACAO | Descrição |
|---|---|
| 0 | NF (venda saída, entrada, complementar, ajuste, devolução, retorno) |
| 1 | Pedido/Compra/Orçamento |
| 2 | Pedido de venda / pré-fatura |
| 3 | Pedido de compra |

## 8. Natureza de operação (`naturezaoperacao`)
`CFO_CODIGO` (CFOP), `DESCRICAO`, flags de geração: `GERARCOMISSAO`, `GERARFATURAMENTO`, `GERARESTOQUE`
(+ variantes de ajuste/complementares), `DESTACARICMS*`, CSTs padrão.

## 9. Ligação com outros módulos
1. `documentoitem.CODIGOORDEMPRODUCAO` = `ordemservico.ORS_ID` (OP); `CODIGOORCAMENTO` = `orcamento.ORC_ID`.
2. Estoque: `estoque.DOC_ID + CLASSIFICACAO + SEQUENCIALITEM` (mesma chave do item) com `ORIGEM=NF` (entrada por nota).
3. Financeiro: `financeiro.DOC_ID + CLASSIFICACAO` gera título (`TOL_CONTASARECEBER`); baixa em `TOL_BAIXACONTASREC`.
4. Pré-fatura: `PREFATURA='S'`, série `PRE`, `tipodocumento` CLASSIFICACAO 2 (pedido de venda pré-fatura).

## 10. Como reproduzir (somente leitura)
```bash
MYSQL_PWD='<senha>' mysql -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "
SELECT * FROM documentocalculo WHERE EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID=93318;
SELECT di.DOC_ID, di.DESCRICAOITEM, di.CFOP, di.NCM, di.QUANTIDADE, di.VALORUNITARIO, di.CODIGOORDEMPRODUCAO
FROM documentoitem di WHERE di.EMP_ID=1 AND di.DOC_ID=93318;
SELECT CLASSIFICACAO, DOC_ID, NUMERO, STATUS, CHAVEACESSO, TOTALNOTA FROM nfe WHERE EMP_ID=1 ORDER BY DATA_ALTERACAO DESC LIMIT 5;"
```

## 11. Parâmetros de faturamento (`_parametrofaturamento`)
`FATURARPRODUTOSEMESTOQUE`, `MULTIESTOQUE`, `NOMENCLATURANF`, `MASCARADOCUMENTONF`, `PERMFATOPACIMASALDO`,
`PERFILCOBRANCAOBRIGATORIOFAT`, `VERIFICARPENDENCIASNAEMISSAONF`, `NUMEROSERIECERTIFICADO`,
`TEXTOEMAILNFE`, `ENVIARDANFEEMAIL`, `CONSIDERARITEMSERVSENDOPROD`.
