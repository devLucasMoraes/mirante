# MongoDB local (Docker Compose)

MongoDB 7 + Mongo Express para desenvolvimento local. Nenhuma credencial é hard-coded — cada
ambiente usa seu próprio arquivo de env. A aplicação **nunca** deve conectar com o usuário
root; use o `MONGO_INITDB_USERNAME` (não-root, `readWrite` em `MONGO_INITDB_DATABASE`), criado
automaticamente na primeira inicialização por `docker/mongodb/init-user.js`.

## Primeira execução

```sh
cp .env.development.example .env.development
# edite as senhas em .env.development
docker compose --env-file .env.development up -d
```

MongoDB: `mongodb://<MONGO_INITDB_USERNAME>:<MONGO_INITDB_PASSWORD>@localhost:<MONGODB_PORT>/<MONGO_INITDB_DATABASE>?authSource=<MONGO_INITDB_DATABASE>`
Mongo Express (apenas dev): `http://localhost:<MONGO_EXPRESS_PORT>` (basic auth via `ME_CONFIG_BASICAUTH_*`)

## Ambientes

| Env  | Comando |
|------|---------|
| dev  | `docker compose --env-file .env.development up -d` (carrega automaticamente `docker-compose.override.yml` → adiciona o Mongo Express) |
| test | `docker compose -f docker-compose.yml -f docker-compose.test.yml --env-file .env.test up -d` |
| prod | `docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.production up -d` |

- `docker compose ... down` — para os containers (os dados são mantidos).
- `docker compose ... down -v` — para e **apaga o volume de dados**.

## Observações

- Os volumes de dados são isolados por ambiente: `mongo_data`, `mongo_data_test`, `mongo_data_prod`.
- Test usa a porta `27018` por padrão (`MONGODB_PORT_TEST`); dev/prod usam `MONGODB_PORT` (`27017`).
- O script de inicialização e o provisionamento do usuário de `MONGO_INITDB_DATABASE` rodam apenas uma vez, em volume vazio.
- Mongo Express é uma ferramenta de inspeção de dev e nunca é incluído em test/prod.

## FAQ

### O que é o `init-user.js`?

Script de inicialização do MongoDB (`docker/mongodb/init-user.js`), montado em
`/docker-entrypoint-initdb.d/`. Na primeira subida com volume vazio, a imagem oficial
`mongo` executa automaticamente os scripts desse diretório. Ele lê as variáveis
`MONGO_INITDB_DATABASE`, `MONGO_INITDB_USERNAME` e `MONGO_INITDB_PASSWORD` e cria o
**usuário da aplicação** com permissão `readWrite` apenas no banco da aplicação — em vez
de a aplicação usar a conta root (que tem acesso a todos os bancos).

- Só roda **uma vez** (volume vazio). Se você alterar as senhas depois, precisa rodar
  `down -v` e subir o container novamente para recriar do zero.
- `db = db.getSiblingDB(dbName)` aqui é o objeto global do `mongosh`, não uma variável de aplicação.

### O que é o `docker-compose.override.yml`?

Arquivo de override **automático** do Docker Compose. Quando você roda `docker compose up`
sem passar `-f`, o Compose faz o merge de `docker-compose.yml` + `docker-compose.override.yml`.
No nosso caso, ele adiciona o serviço `mongo-express` (painel de inspeção com basic auth)
**apenas em desenvolvimento**.

- Quando você lista os arquivos com `-f` (test/prod), o override **não** é carregado.
- Por isso o Mongo Express nunca aparece em test/prod.

### Por que o Mongo Express mostra `ERR_TOO_MANY_RETRIES` no navegador?

Geralmente **não é um problema do servidor** — é o Chrome reenviando uma credencial de
basic auth errada/antiga para `localhost:8081` em loop, até desistir. Para resolver:

1. Abra uma **janela anônima** e acesse `http://localhost:8081/` (login:
   `ME_CONFIG_BASICAUTH_USERNAME` / `ME_CONFIG_BASICAUTH_PASSWORD`). Se carregar, é cache do navegador.
2. Limpe as credenciais salvas: `chrome://settings/content/siteData` → busque `localhost` → excluir
   (ou `chrome://settings/passwords` e remova a senha de `localhost`).
3. Recarregue com `Ctrl+Shift+R`.

Confirme o servidor com `curl -u <user>:<pass> -o /dev/null -w "%{http_code}" http://localhost:8081/`
(esperado `200`).
