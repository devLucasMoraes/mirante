# Wingraphex local (Docker Compose)

Réplica local do ERP Wingraphex (gráfica, MySQL 5.7.26, latin1) para testar SQL sem tocar a
produção. Compose em `docker-compose.wingraphex.yml` (raiz); assets em `docker/wingraphex/`.

**Acesso ao banco é estritamente somente leitura (SELECT/SHOW/information_schema — nunca DML/DDL),
tanto na réplica (3308) quanto na produção (192.168.1.16:3307).**

## Primeira execução

```sh
cp docker/wingraphex/.env.example docker/wingraphex/.env
# edite docker/wingraphex/.env: preencha WINGRAPHEX_READ_PASSWORD com a senha de produção do _consulta
docker compose -f docker-compose.wingraphex.yml --env-file docker/wingraphex/.env up -d
```

Na primeira subida (volume vazio), o MySQL executa `initdb/01-schema.sql` (557 tabelas) e
`initdb/02-dados.sql` (amostra real, 42 tabelas). Aguarde os logs:

```sh
docker logs -f wingraphex-db   # aguardar "ready for connections"
```

O healthcheck do compose pode ficar healthy antes do initdb terminar.

## Conexão

Réplica (porta host **3308** — nunca confundir com a produção 3307):

```sh
MYSQL_PWD="$(awk -F= '/^MYSQL_PASSWORD=/{print $2}' docker/wingraphex/.env)" \
mysql --ssl-mode=DISABLED --default-character-set=utf8 \
  -h 127.0.0.1 -P 3308 -u _consulta wingraphex
```

> `--ssl-mode=DISABLED` é necessário porque o cliente MySQL 8.x falha (ERROR 2026) contra o
> servidor 5.7. O healthcheck do container usa socket e não sofre disso.

## Regenerar a amostra

Gera um novo `initdb/02-dados.sql` a partir da produção (somente leitura, `mysqldump
--single-transaction --skip-lock-tables`). Lê `WINGRAPHEX_READ_PASSWORD` de `docker/wingraphex/.env`:

```sh
./docker/wingraphex/scripts/extrai-dados.sh
```

Para aplicar o dump novo, recrie o volume:

```sh
docker compose -f docker-compose.wingraphex.yml --env-file docker/wingraphex/.env down -v
docker compose -f docker-compose.wingraphex.yml --env-file docker/wingraphex/.env up -d
```

## Variáveis de ambiente

| Variável | Uso | No `.env.example`? |
|---|---|---|
| `MYSQL_ROOT_PASSWORD` | usuário root da réplica local | sim (valor dev) |
| `MYSQL_PASSWORD` | usuário `_consulta` da réplica local | sim (valor dev) |
| `WINGRAPHEX_READ_PASSWORD` | usuário `_consulta` de produção (ex-`senha.txt`) | não — digite `change_me` no `.env` |

`docker/wingraphex/.env` é gitignorado — nunca commitar.

## Observações

- Imagem `mysql:5.7.26` (mesma versão da produção), com `--character-set-server=latin1` /
  `--collation-server=latin1_swedish_ci`.
- Limitações conhecidas da réplica: a view `consultaatualizaprecomedio` e as 5 rotinas
  (`ObterValorCTEItem`, `__fncObterNumeroNF`, `__fncObterProximaChave`, `__prcAtualizarSaldoFisico`,
  `__prcInserirRegistroEstoqueItemSaldo`) não foram recriadas — exigem `SHOW CREATE FUNCTION`, que
  o `_consulta` não tem. A estrutura das tabelas está completa.
- Conhecimento de schema/relatórios/fluxos: skill `wingraphex-erp`
  (`.opencode/skills/wingraphex-erp/`). Sem FKs declaradas; `EMP_ID` sempre no WHERE; usar
  `--default-character-set=utf8`.