# Esqueleto do banco wingraphex (ERP) — mapeamento até 11/08/2026

> Metodologia: somente leitura de metadados (`information_schema`, `SHOW CREATE TABLE`). Banco de produção — não fazer alterações.

## Visão geral
- **558 tabelas**, ~5,1 GB, MySQL **5.7.26** em `192.168.1.16:3307`.
- **552 InnoDB + 5 MyISAM** (+1 sem engine definida).
- **Sem FKs declaradas** — relacionamento por convenção de chaves (colunas com índice `MUL`).
- **Empresas:** `EMP_ID` 1 e 2 (cadastros duplicados, ex. `formapagto` tem 28 por empresa). Perfil completo das duas (razão/fantasia/CNPJ, volume por tabela, particularidades) → `empresas.md`.
- **Colunas padrão:** `DATA_ALTERACAO` + `USER_ALTERACAO` em todas as tabelas.

## Tabelas por módulo
| Módulo | Nr tabelas | Tamanho |
|---|---:|---:|
| Sistema/Infra (params, seguranca, cadastros base, views) | 308 | 1.852 MB |
| Fiscal/NF-e/SEFAZ | 50 | 423 MB |
| Flexografia/Máquinas | 42 | 3 MB |
| Orçamento (orc, orcservico, flexoorc*) | 29 | 810 MB |
| OP/Ordem de Serviço (op*, ordemservico*) | 21 | 58 MB |
| Integrações (bosch, export/import, replicador, salesforce) | 18 | 3 MB |
| PCP | 14 | 190 MB |
| Financeiro (financeiro, pagar/receber, cheques, cobrança) | 14 | 413 MB |
| Cadastros (cliente, vendedor, fornecedor, endereço) | 13 | 32 MB |
| Estoque/Material | 9 | 706 MB |
| Materiais de Impressão (lamina, tinta, chapa, papel) | 9 | 116 MB |
| CRM | 9 | 1 MB |
| Logs | 9 | 470 MB |
| Propostas/Recibos | 7 | 49 MB |
| Módulo Arte (xcriacaoarte*) | 6 | 0 MB |

## Fluxo de negócio ↔ tabelas (mapa de navegação)
```
ORCAMENTO → PROPOSTA → OP → PCP → FATURAMENTO → FINANCEIRO → ENTREGA
  orcamento   proposta   op   pcp*    documento*    financeiro    ordemservplanejentrega
  qtorcamento propostaorc      opflexo*  / CI / NF   pagar/receber  pcpexpedicao
```

### Ligações-chave (todas verificadas)
1. `cliente.PES_ID` → `orcamento.CLI_ID` → (aprovado) → `ordemservico.ORC_ID` + `op.ORS_ID`
2. OP faturada: `documentoitem.CODIGOORDEMPRODUCAO` = `ORS_ID`; status em `ordemservico.ORS_STATUSFATURAMENTO`
3. Baixa: `financeiro.DOC_ID`/`CLASSIFICACAO`/`SEQUENCIALITEM` → documento faturado; `financeiro.NRO_OP` referencia a OP (nem sempre preenchido)
4. CI vs NF série 1: `tipodocumento.CLASSIFICACAO=0` (nota fiscal) + `serienf.TIPO/NFE` + `documentocabecalho.SERIENF`
5. **Entrega/retirada sem status próprio** (ver `regras-de-negocio.md` §9)

## Núcleo de vendas
- **`cliente`** (`EMP_ID`, `PES_ID`) — cadastro com dados de crédito/compras embutidos (CLI_VALOR*, CLI_DATA*, limite de crédito, CLI_TIPO).
- **`orcamento`** (`EMP_ID`, `ORC_ID`) — cabeçalho; `CLI_ID`, `VEN_ID`, `FOP_ID`; flags `ORC_PROPOSTA`, `ORC_ORDEMSERVICO`, `ORC_NEGOCIACAOFINALIZADA`. Detalhe → `modulo-orcamento.md`.
- **`qtorcamento`** (`EMP_ID`, `ORC_ID`, `QTO_ID`) — quantidades/valores por item.
- **`proposta`**/`propostaorc` (`PROP_ID`+`SEQUENCIAL`) — comercial, referencia `ORC_ID`, `STP_ID` (status).
- **`op`** (`EMP_ID`, `ORS_ID`) — ordem de produção; `CLI_ID`, `ORS_SALDO`, `TIPOPROCESSO`.
- **`ordemservico`** (`EMP_ID`, `ORS_ID`) — espelho do orçamento (`QTO_*`→`ORS_*`); `ORC_ID`, `ORS_STATUSFATURAMENTO`, `ORS_SITUACAOID`, `VLR_*_REALIZADO`.
- **`ordemservicostatus`** (`EMP_ID`, `ORS_ID`, `CODIGO`) — histórico de status; liga a `DOC_ID`/`CLASSIFICACAO`/`SEQUENCIALITEM`.
- **`ordemservicolog`** — log em texto livre (68 mil linhas); não captura entrega/retirada.
- **`documentocabecalho`**/`documentoitem`/`documentocalculo`/`documentorodape` — faturamento (CI/NF). Detalhe → `modulo-faturamento.md`.

## Financeiro
- **`financeiro`** (`EMP_ID`, `CHAVE`, `CHAVEBAIXAPAGAR`, `CHAVEBAIXARECEBER`) — lançamento único a pagar/receber.
- **`formapagto`** (28/empresa) — `A_VISTA`/`A_PRAZO`. **Não há forma "50/50 ou conforme retirada" ativa.**
- **`pagar`**/`receber` — estendem `financeiro`. **`cheque`**/`chequebaixas` — controle de cheques.
- **`carteira`**+`carteiraparametros` — layout boleto, remessa/retorno, juros/multa.
- **`banco`**/`contabancaria` — bancos e contas; `contabancaria.INCLUIRFLUXOCAIXA` marca conta de caixa.
- **`_parametrofinanceiro`** — contas padrão, carteira padrão, comissões, controle de cheque.
- **`tipostatusordemservico`** — 12 estados da OP (ver `regras-de-negocio.md` §6).
- **Não existe tabela "caixa"** — fechamento de caixa é `financeiro` + `contabancaria`(INCLUIRFLUXOCAIXA).
- **`operador`**/`operadorlogterminal` — funcionários e batidas de ponto. `turno`/`tipoturno` — escalas.
- Detalhe completo → `modulo-financeiro.md`.

## PCP / Produção / Entrega
- **`pcpprocessos`** — operações por máquina de cada OP. **`pcpapontamento`** — apontamento de produção real.
- **`pcpexpedicao`**(`LOTE`+`CODIGOTRABALHO`) e `pcpprocessoentrega` — expedição/entrega por lotes ("chato de usar").
- **`ordemservplanejentrega`**/`opflexoplanejamentoentrega` — agendamento de entregas por OP.
- **`expedicaopedido`** — liga faturamento (`DOC_ID`) à quantidade expedida — **quase não usada** (4 registros).
- **`ordemservicolocalentrega`** — endereço de entrega diferente (destino, transportadora, frete).
- Detalhe completo → `modulo-pcp.md`.

## Estoque / Material
- **`material`** (284 mil) — catálogo; `MTR_CLASSIFICACAO`: TC_PRODUTO(323k), TC_MATERIAPRIMA(274), TC_SERVICO(2).
- **`estoque`** (774 mil) — movimentação; `ORIGEM` EP/BR/NF/OP/AC/PC/EM; liga a `DOC_ID`/`CLASSIFICACAO`/`SEQUENCIALITEM` e `CODIGOOS`.
- **`estoqueitemsaldo`** — saldo físico atual agregado.
- **`requisicaoestoque`**/`requisicaoestoqueitem` — pedidos de retirada de material p/ produção.
- **`localestoque`** — locais/galpões.

## NF-e / SEFAZ
- **`nfe`** — status SEFAZ (série 1 = 1.823 produto/SEFAZ, série 2 = 24).
- **`danfe`** — DANFE/PDF consolidado. **`serienf`** — séries (TIPO, flags NFE/NFCE/MDFE/NFSE/SPED).
- **`nfemanifestacaodest`** — manifestação de destinatário. **`recopi`** — recepção de NF-e de terceiros (compra).
- **`tipodocumento.CLASSIFICACAO`** — 0=NF, 1=Pedido/Compra/Orçamento, 2=Pedido de venda(pré-fatura), 3=Pedido de compra.
- **`naturezaoperacao`** — CFOP, flags GERARESTOQUE/GERARFATURAMENTO/GERARCOMISSAO.
- Apoio fiscal: `cfopoficial`, `ncm`, `cest_ncm`, `ibpt`, `cnae`, `cidade`, `estado`, `impostoestado`, `situacaotributaria`.

## CRM
- **`crmevento`**/`crmatendimento`/`crmtarefa`/`crmanotacao`/`crmocorrencia`/`crmnotificacao`/`crmpesquisasatisfacao`.
- **`campanha`**/`campanhagrupocliente`/`campanhamidia` — campanhas (datas, status, receita/custo/lucro).
- **`compromisso`**/`tarefa` — agenda. **`mailing`** — disparo de e-mail. **`_parametroscrm`**.

## Custos
- **`mapacusto`**/`mapacustovalores` — mapa de custo mensal por centro. **`centrocusto`**/`identificadorcusto`.
- **`rateiocentrocustos`**/`rateiodespesas`/`rateiofuncionarios` — rateio adm→produtivo.
- Liga a `orçamento`/`material` via `IDENT_ID` e `CODIGOCENTROCUSTO`.

## Integrações
- `xintegracaobosch`/`xintegracaoboschnotas` — BOSCH. `salesforcehistorico` — Salesforce (JSON em `CONTEUDO_JSON`).
- `_exportacao*`/`_importacao*`/`integracaoperfil`(+configuração). `_replicador*`/`transferenciaempresas`.

## Módulo Arte
- **`xcriacaoarte`** — criação de arte (~100 campos de pergunta: logo/etiqueta/selo/capa/mousepad/ingresso/pulseira); liga a `material` via `ORIGEMPRODUTO`/`ID_PRODUTOSERVICO`.
- `xcriacaoartealteracoes`/`xcriacaoartearquivos`/`xcriacaoartecontatos`/`xcriacaoartelogemail`(+anexo).

## Segurança
- **`_segusuario`**/`_segusuario2` — usuários. ⚠️ `USU_SENHA` em texto claro — nunca usar.
- **`_segpermissoes`**(`PER_ID`+`GU_ID`+`FUNCAO_ID`) — permissões por grupo/função.
- `_segusuariomodulo`, `_segusuarioempresa`, `_seggrupousuario`(+vendedor).
- `_segpermissoesacoesespeciais`, `_segpermissoesconspersonalizada`, `_segpermissoesrelpersonalizado`.

## Bremen.net (gerenciador de relatórios)
- **`_brelpasta`** — pastas de relatórios. **`_brelitem`** — modelos (`BRI_TEMPLATE` longblob, `BRI_ATIVO`).
- `_brellocal` — localização do item. `_brelitemlog` — log de execução.

## Balcão/PDV
- Sem tabelas próprias — usa `documento*` normal.
- `documentoitemcomanda` — status de item por comanda. `statuscomanda`/`logstatuscomanda`.

## Infra/Parâmetros
- `_parametrosorc`/`_parametrosorcflexo` — cálculo de orçamento.
- `_parametrofaturamento` — emissão NF/CI, SEFAZ, e-mail, certificado, comissão.
- `_parametrofinanceiro` — contas/carteira padrão, comissões, controle de cheque.
- `_parametrospcp` — apontamento, fila, tempos. `_parametroestoque` — baixas, requisições, locais, preço médio.
- `_parametroimposto` — crédito PIS/COFINS por insumo.
- **`_dicionario`** ⭐ — 7.321 entradas `tabela/campo` ↔ nome de negócio em português. Consultar primeiro ao mapear tabela desconhecida.
- `_notificacoesperfil` — relatórios/notificações agendadas (SQL, e-mail, frequência).
- ⚠️ `_configsistema` — colunas com nomes ofuscados (valores sensíveis do sistema).

## As 10 tabelas mais pesadas (medido 10/08/2026)
| # | Tabela | Rows (est.) | Tamanho |
|---|---|---:|---:|
| 1 | `estoque` | 774.027 | 543 MB |
| 2 | `financeiro` | 184.962 | 397 MB |
| 3 | `_logwingraph` | 1.037.803 | 314 MB |
| 4 | `material` | 283.958 | 238 MB |
| 5 | `ordemservico` | 152.111 | 234 MB |
| 6 | `emailanexo` | 4.638 | 190 MB |
| 7 | `qtorcamento` | 162.184 | 163 MB |
| 8 | `orcamento` | 155.847 | 162 MB |
| 9 | `documentoitem` | 155.412 | 148 MB |
| 10 | `documentoitemcalculo` | 152.423 | 137 MB |

## Riscos / notas operacionais
- **Banco de produção: somente leitura.** Nunca DML/DDL.
- Evitar `SELECT` pesado; preferir `information_schema`, `SHOW CREATE TABLE`, `LIMIT`+`ORDER BY` em coluna indexada.
- Tabelas de log sem valor de negócio (candidatas a purga se fosse admin): `_logwingraph` (314 MB), `_notificacoesresultadodetalhe` (112 MB), `loggeral`(+item).
- `longblob`: `emailanexo` (190 MB, anexos NF-e XML/PDF), `documentoarquivos` — consumir só metadados.
- Views: `_vpesquisamateriais`, `_vpesquisaprodutos`, `_vpesquisaservicos`, `consultaatualizaprecomedio`.
- Tabela `pessoa` tem **10.947 `PES_ID` duplicados** — nunca fazer `LEFT JOIN pessoa` direto (duplica linhas); usar subquery com `LIMIT 1` para pegar o nome.

## Como buscar uma tabela específica no DDL completo
O arquivo `schema-wingraphex.sql` (mysqldump --no-data, 13.785 linhas, 557 tabelas)
está nesta mesma pasta. Nunca ler o arquivo inteiro — buscar a tabela específica:
```bash
grep -A 40 "CREATE TABLE \`nome_tabela\`" references/schema-wingraphex.sql
```
