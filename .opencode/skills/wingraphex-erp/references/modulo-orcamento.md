# Módulo Orçamento do Wingraphex (ERP) — levantamento 11/08/2026

> Baseado em consultas somente leitura ao banco de produção + dump do schema. Medidas reais.

## Visão geral
- **29 tabelas** do módulo (`orc*`, `flexoorc*`, `qtorcamento`), ~810 MB.
- Orçamento **aprovado** → gera a Ordem de Produção (`ordemservico`/`op`). Só vira OP quando aprovado.
- Empresa 1 e 2 (cadastros duplicados por empresa).

## 1. Camadas do orçamento (estrutura de dados)
```
orcamento (cabeçalho, EMP_ID+ORC_ID)
  │
  ├── qtorcamento (EMP_ID+ORC_ID+QTO_ID)  → quantidades/valores por item (QTO_*)
  │     ├── orclamina (ORL_ID)            → lâminas/páginas por item (papel, gramatura, cores frente/verso)
  │     ├── orclamtinta / orclamtintaqt   → tinta por lâmina/quantidade
  │     ├── orcmaqacab / *lamina / *matprima / *quant → máquina de acabamento
  │     ├── orcservico / orcservicogeral (+parametros, +lamina) → serviços e scripts
  │     └── orcmatdiversos / orcmtdiverso (+qt) → materiais diversos
  ├── orcamentoservico (+matdiv)          → serviços agregados ao orçamento
  ├── orcamentolog                        → auditoria (criado/alterado/gerou OP/duplicado)
  ├── orcagencia / orcprodutor            → comissão de agência/produtor
  └── flexoorc* (14 tabelas)              → variante de cálculo "flexo" (linhas e bobinas)
```
### Tabelas flexo (variante)
`flexoorcamento`, `flexoorcquantidade`, `flexoorclamina`(+bobina, faca, tinta, servico, cab, mtdiverso,
impostos, produtor, vendedores, maqacabamento, observacoes) — espelham o cálculo tradicional numa
segunda forma de precificação.

## 2. Encadeamento de chaves (verificado)
1. `orcamento.ORC_ID` (PK) → `qtorcamento.ORC_ID` (itens, PK `EMP_ID+ORC_ID+QTO_ID`).
2. Aprovado: `ordemservico.ORC_ID` + `ordemservico.QTO_ID` (espelho do orçamento na OP).
3. `op.ORS_ID` = `ordemservico.ORS_ID` (mesma chave; `op` guarda saldo/processo).
4. Itens do orçamento por lâmina: `orclamina.ORL_ID` liga a `orcmaqacablamina`, `orcservicolamina`,
   `orclamtinta`, `orcmaqacablaminaquant`, `orcservicomatdivlamqt`.
5. Não há FKs declaradas — relacionamento por convenção (índices MUL).
6. Comissão agência: `orcagencia`/`ordemservicoagencia` (PES_ID, percentual). Comissão produtor: `orcprodutor`.

## 3. Fórmula de precificação — exemplo real ORC 171415 (1.905 unid.)
| Componente | Valor |
|---|---:|
| Papel (`QTO_VLRPAPEL`) | 38,64 |
| Papel perda (`QTO_VLRPAPELPERDA`) | 0,84 |
| Tempo impressão (30 min × 80,00/h) | dentro do custo |
| Chapas (`QTO_QTCHAPAS`=2) | 0 |
| **Custo total** (`QTO_VLRCUSTO`) | **119,48** |
| Impostos: ISS 6,84 + Simples Federal 20,44 | **27,28** |
| Margem de lucro (`QTO_VLRMARGEMLUCRO`) | 24,69 (14,40%) |
| **Preço a prazo** (`QTO_VLRFINALPRAZO`) | **171,45** |
| Preço à vista (`QTO_VLRFINALVISTA`) | 171,45 |

- `QTO_VLRCONTRIBMARGINAL` = 104,69 · `QTO_VLRCOMVENDEDOR` = 0 (sem comissão neste caso).
- Impostos individualizados (cada um com `QTO_CALCULA*` S/N e `QTO_PERC*`): `QTO_VLRPIS`, `QTO_VLRCOFINS`,
  `QTO_VLRICMS`, `QTO_VLRIPI`, `QTO_VLRISS`, `QTO_VLRIMPOSTORENDA`, `QTO_VLRCSLL`, `QTO_VLRSIMPLESFEDERAL`,
  `QTO_VLRSIMPLESESTADUAL`, `QTO_VLRTAXAADM`, `QTO_VLRICMSREVENDA`.
- Variantes de preço sem IPI: `QTO_VLRUNITPRAZOSEMIPI`, `QTO_VLRFINALVISTASEMIPI`, etc.
- `*_LP` = cálculo pela lâmina/página. `orcservicogeral` carrega `OSG_*` (quantidade, unitário, total, LP, frete).

## 4. Cabeçalho (colunas-chave de `orcamento`)
- Datas: `ORC_DTORCAMENTO`, `ORC_DTVALIDADEORC` (validade típica: 1 ano).
- Cliente: `CLI_ID` + denormalizado `CLI_DESCRICAO`, `CLI_CIDADE`, `CLI_UF`, `CLI_FONE`, `CLI_RESPONSAVEL`.
- Venda: `VEN_ID`, `FOP_ID` (forma pagto), `VEN_PERCCOMISSAO`.
- Medidas do impresso: `ORC_MEDALTURA`/`ORC_MEDLARGURA`, `TPI_ID` (tipo impresso), `ORC_NROVIAS`, `ORC_QTJOGOSPAGINAS`.
- Tributação: `PERC_ICMS`, `PERC_ICMSREVENDA`, `ORC_CSTICMS/IPI/PIS/COFINS`, `ORC_CNAE`, `CODPERFILIMPOSTO`, `ORC_CREDITAPISCOFINS`.
- Flags de fluxo: `ORC_PROPOSTA`, `ORC_ORDEMSERVICO`, `ORC_NEGOCIACAOFINALIZADA`, `ORC_PADRAO`.
- Preço: `ORC_DEFINIRVLRUNITMANUAL` (S/N), `ORC_VLRUNITARIOMANUAL`, `ORC_USARLISTAPRECO` (`LTP_ID`).

> ⚠️ **`orcamento.ORC_VLRCUSTO` está 0** em vários orçamentos recentes. Os valores reais estão em
> `qtorcamento.QTO_VLRCUSTO`. **Não usar o custo do cabeçalho como fonte confiável.**

## 5. Ciclo de vida (auditoria `orcamentolog` — exemplo ORC 166303)
| Código | Data | Usuário | Texto |
|---|---|---|---|
| 1 | 20/06/2025 | Leilan | Orçamento foi criado |
| 2 | 20/06/2025 | Leilan | Atualização dos dados da base |
| 3 | 20/06/2025 | Leilan | Orçamento foi alterado |
| 4 | 20/06/2025 | Leilan | **Geração de O.P. número: 157682.** |
| 5-6 | 20/06/2025 | Leilan | Orçamento foi alterado |
| 7 | 31/07/2026 | Leilan | Orçamento duplicado para: 171364 |

- **OP só é gerada quando aprovado** → confirma `ORC_ORDEMSERVICO='S'` + log "Geração de O.P.".
- `orcamentolog` é o histórico textual — análogo ao `ordemservicolog` das OPs.

## 6. Exemplo real completo — ORC 166303 → OP 157682
- 30.000 unid., BAHIA ARTES GRÁFICAS LTDA, FEIRA DE SANTANA/BA, vendedor 2, forma pagto 1.
- `qtorcamento`: papel 49.144,56 · acabamento 12.995,74 · **custo 86.822,62** · impostos 11.646,12 · **prazo 73.200,00**.
- **10 lâminas** (`orclamina`): `TL_FOLHA`, gramatura 56, 1 cor frente + 1 verso, 14×21 cm, Miolo 01-10.
- 5 `orcmaqacab` + 1 `orcservicogeral` + 7 logs de auditoria.
- **Margem negativa** (−25.268,74): custo+impostos (98.468,74) supera o preço vendido (73.200) — preço manual abaixo do custo.

## 7. Achado: margem negativa frequente nos recentes
| ORC | Custo | Impostos | Margem | Preço prazo |
|---:|---:|---:|---:|---:|
| 171421 | 3.090,30 | 167,06 | **−2.207,36** | 1.050,00 |
| 171425 | 1.243,44 | 9,86 | **−1.203,30** | 50,00 |
| 171417 | 715,82 | 9,86 | **−675,68** | 50,00 |
| 171424 | 235,50 | 57,19 | −2,69 | 290,00 |

Orçamentos recentes costumam ser salvos com **preço final definido manualmente** (margem negativa
frequente); a fórmula completa só se aplica quando o cálculo é refeito/efetivo. Custo do cabeçalho
zerado reforça isso — nunca confie em `orcamento.ORC_VLRCUSTO`.

## 8. Como reproduzir (somente leitura)
```bash
MYSQL_PWD='<senha>' mysql -h 192.168.1.16 -P 3307 -u _consulta wingraphex -e "
SELECT * FROM qtorcamento WHERE EMP_ID=1 AND ORC_ID='171415';
SELECT ORL_ID, ORL_TIPOLAMINA, ORL_GRAMATURAPAPEL, ORL_QTCORFRENTE, ORL_QTCORVERSO, ORL_DESCRICAO
FROM orclamina WHERE EMP_ID=1 AND ORC_ID='166303';
SELECT CODIGO, DATA, NOMEUSUARIO, TEXTO FROM orcamentolog WHERE EMP_ID=1 AND ORC_ID='166303' ORDER BY CODIGO;"
```

## 9. Parâmetros que regem o cálculo
- `_parametrosorc` e `_parametrosorcflexo` — margem padrão, validade, comissão, forma de cálculo.
- `_parametroimposto` — crédito PIS/COFINS por insumo.
- `_dicionario` (7.321 registros) — decodifica tabela/campo físico → nome de negócio.
