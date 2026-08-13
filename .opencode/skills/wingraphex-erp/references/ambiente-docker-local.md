# Ambiente Docker local — wingraphex (réplica de teste)

Réplica local (Docker) do banco de produção, para testar SQL sem tocar em produção. Os arquivos
brutos ficam na **raiz do monorepo**: `docker/wingraphex/` (pasta irmã de `apps/`, `docker/`,
`.opencode/`) + `docker-compose.wingraphex.yml` — **nao ler `initdb/01-schema.sql` nem
`initdb/02-dados.sql` inteiros**, são grandes (627 KB / 4 MB); usar grep ou o próprio MySQL local
para consultá-los.

## Estrutura de arquivos
```
docker-compose.wingraphex.yml   → serviço MySQL 5.7.26, porta host 3308
docker/wingraphex/
├── .env.example                 → modelo de variáveis (copiar para .env, nunca commitar .env)
├── initdb/
│   ├── 01-schema.sql            → schema completo (557 tabelas), sem dados
│   └── 02-dados.sql             → amostra REAL de dados (42 tabelas), gerada por extrai-dados.sh e incrementada por incrementa-ops.sh
└── scripts/
    ├── extrai-dados.sh          → gera 02-dados.sql a partir da produção (somente leitura)
    └── incrementa-ops.sh        → ANEXA 30 OPs completas de 5 clientes a 02-dados.sql (somente leitura)
```

## 2026-08-13 — Amostra incrementada: +30 OPs completas de 5 clientes
- **O que foi testado:** anexar 30 OPs ponta-a-ponta novas (5 clientes x 6 OPs) ao `02-dados.sql`
  existente via `scripts/incrementa-ops.sh`, preservando o conteúdo anterior e sem duplicar PKs.
- **Resultado:** funciona (validação: réplica recriada com `down -v` + `up -d`, carga 100% sem
  erro de PK; contagens conferem).
- **Como reproduzir:**
  ```bash
  ./docker/wingraphex/scripts/incrementa-ops.sh   # le WINGRAPHEX_READ_PASSWORD de docker/wingraphex/.env
  ```
- **Observações:**
  - **Clientes:** 28, 10816, 6030, 606, 7379 (os mesmos da amostra; sem re-dump de cadastros).
  - **Critério de OP "completa":** faturada (`ORS_STATUSFATURAMENTO='TSF_FATURADA'`), não
    cancelada, com `pcptrabalhos`+`pcpprocessos`, `documentoitem` ligado por `CODIGOORDEMPRODUCAO`
    e `financeiro` ligado via `DOC_ID`, e com `DOC_ID` ainda fora do arquivo.
  - **O que foi anexado:** +30 `ordemservico`/`op`/`pcptrabalhos`/`orcamento`/`qtorcamento`,
    +22 `documentocabecalho`/`documentocalculo`/`documentorodape`/`receber`, +46 `financeiro`,
    +142 `ordemservicostatus`, +132 `pcpprocessos`, +98 `pcpapontamento`, +34 `documentoitem`/
    `documentoitemcalculo`/`estoque`, +33 `material`.
  - **Dedup automático:** o script lê os IDs já presentes no `02-dados.sql` (`ORDEMSERVICO`,
    `ORCAMENTO`, `DOCUMENTOCABECALHO`, `FINANCEIRO`, `MATERIAL`) e exclui-os da seleção; remove
    também as 2 linhas finais (`SET FOREIGN_KEY_CHECKS=1;`/`SET UNIQUE_CHECKS=1;`) antes de anexar
    e as reescreve no fim.
  - **`pagar` permanece vazio** (0 linhas, como na amostra).
  - **Como incrementar de novo:** subir o contador `OPS_PER_CLIENT` (ex.: 6→12) e/ou trocar
    `CLIENTS` no topo do script; rodar de novo (o dedup impede repetição).
  - **Nota:** se rodar o script **depois** de recriar a réplica, a amostra nova não carrega sozinha —
    precisa recriar o volume (ver abaixo) ou reimportar.

## 2026-08-12 — Réplica MySQL 5.7.26 com schema completo + amostra real
- **O que foi testado:** criação de ambiente local com Docker Compose idêntico ao banco de
  produção, com schema (557 tabelas) e uma amostra real de dados (multi-cliente/módulo), extraída
  somente-leitura da produção.
- **Resultado:** funciona
- **Como reproduzir:**
  - Extrair amostra nova (somente leitura, gera `initdb/02-dados.sql`):
    ```bash
    ./docker/wingraphex/scripts/extrai-dados.sh   # le WINGRAPHEX_READ_PASSWORD de docker/wingraphex/.env
    ```
  - Subir o ambiente (1ª vez popula o volume):
    ```bash
    docker compose -f docker-compose.wingraphex.yml --env-file docker/wingraphex/.env up -d
    ```
  - Aguardar healthy (o healthcheck pode passar cedo; conferir `docker logs` por "ready for connections").
  - Conexão local:
    ```bash
    mysql --ssl-mode=DISABLED --default-character-set=utf8 -h 127.0.0.1 -P 3308 -u _consulta -p"..." wingraphex
    ```
- **Observações:**
  - **Imagem:** `mysql:5.7.26` (mesma versão da produção). Servidor iniciado com
    `--character-set-server=latin1 --collation-server=latin1_swedish_ci` (espelha produção).
  - **Porta:** host **3308** → container 3306 (produção usa 3307; nunca confundir as duas). Usuário
    local `_consulta`; senhas de dev só no `docker/wingraphex/.env` (copiar de `.env.example`, nunca
    colar em texto puro).
  - **Validação:** `SELECT VERSION()` = 5.7.26; 557 tabelas (552 InnoDB + 5 MyISAM); collation
    `latin1_swedish_ci`; acentuação round-trip OK com `--default-character-set=utf8`; relatório
    validado `ops-em-aberto` (cliente 5011) retorna OP 161816 igual ao esperado.
  - **Amostra carregada (42 tabelas):** cadeia ponta-a-ponta orcamento 171415 → ordemservico/op
    162056 → documento* DOC 93318 (CI) → financeiro CHAVE 259413; clientes 5011, 6030, 5432, 7379,
    9709, 10970, 10816, 28, 9769, 267, 606; mais apoio (formapagto, meiospagamento, tipodocumento,
    naturezaoperacao, estado, cidade, cfopoficial, banco/contabancaria/carteira, serienf,
    parametros, `_dicionario` 7.321, `_seggrupousuario`).
  - **Após incremento de 2026-08-13:** 35 `ordemservico`, 36 `orcamento`, 29 `documentocabecalho`,
    62 `financeiro`, 143 `pcpprocessos`, 298 `pcpapontamento`, 163 `ordemservicostatus`, 47
    `estoque`, 46 `material` (as OPs antigas 161816/162015/162056/162060/162061 continuam lá).
  - **Caveat cliente 8.0.46 ↔ servidor 5.7:** usar `--ssl-mode=DISABLED` na conexão local (senão
    erro SSL handshake `ERROR 2026`). No healthcheck do compose usa socket (`--protocol=socket`),
    sem problema.
  - **Limitação:** view `consultaatualizaprecomedio` e as 5 rotinas (`ObterValorCTEItem`,
    `__fncObterNumeroNF`, `__fncObterProximaChave`, `__prcAtualizarSaldoFisico`,
    `__prcInserirRegistroEstoqueItemSaldo`) não foram recriadas (exigem `SHOW CREATE FUNCTION`, que
    `_consulta` não tem). Estrutura das tabelas está completa.
  - **Dados de produção podem divergir do conhecimento registrado em `regras-de-negocio.md` e nos
    relatórios:** ex.: título 259413 do DOC 93318 está com baixa PIX (saldo 0) no dump atual, embora
    documentação anterior registrasse "sem baixa" — a amostra reflete o estado real na data da
    extração. Ao validar um relatório contra o ambiente local, checar a data da extração antes de
    apontar divergência como erro.
  - Se refazer o ambiente com `02-dados.sql` novo, apagar o volume:
    `docker compose -f docker-compose.wingraphex.yml --env-file docker/wingraphex/.env down -v`.

## Quando usar o ambiente local vs produção
- **Testar/depurar um SQL novo antes de rodar em produção** → ambiente local (3308). Mais seguro
  para iterar, mesmo sendo somente leitura em ambos.
- **Relatório precisa da carteira completa/dados atuais** → produção (3307) — a amostra local só
  tem as ~11 pessoas e documentos listados acima, não serve para ABC de carteira inteira.
- **Ampliar a amostra local** (mais clientes/tabelas) → editar as variáveis `DOCS`/`OPS`/`ORCS`/`PESSOAS`
  no topo de `docker/wingraphex/scripts/extrai-dados.sh` e rodar de novo, **ou** anexar mais OPs
  com `docker/wingraphex/scripts/incrementa-ops.sh` (ver seção 2026-08-13).

## Script `extrai-dados.sh` — o que ele faz
Gera `initdb/02-dados.sql` via `mysqldump --no-create-info --single-transaction --skip-lock-tables`
(somente leitura, sem LOCK TABLES) filtrando por listas fixas de `DOC_ID`/`ORS_ID`/`ORC_ID`/`PES_ID`
no topo do arquivo. Cobre, na ordem: cadastros (pessoa/cliente/vendedor) → orçamento → OP/PCP →
faturamento → financeiro → estoque → tabelas de apoio/infra (`_dicionario`, parâmetros). Para ver a
lista exata de tabelas e filtros, ler `../../../docker/wingraphex/scripts/extrai-dados.sh`
diretamente (arquivo pequeno, ~130 linhas) — não precisa desta reference repetir o script inteiro.
