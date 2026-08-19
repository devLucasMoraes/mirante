# Deploy do Mirante em produção — servidor Windows (192.168.1.16)

Guia de implantação do monorepo Mirante no servidor da empresa (`192.168.1.16`),
que também hospeda o ERP Wingraphex (MySQL `:3307`). Acesso interno pela LAN,
via **HTTPS** com certificado self-signed (mkcert).

## Arquitetura alvo

```
Browser (cliente na LAN)
   │  https://192.168.1.16   (443)
   ▼
nginx (Windows, serviço via NSSM)
   ├── /      → apps/web/dist  (estático, SPA BrowserRouter)
   └── /api   → proxy → http://127.0.0.1:3000   (Fastify)
                          │
                          ├── MongoDB (serviço Windows, :27017) — usuário "app"
                          └── Wingraphex MySQL 192.168.1.16:3307 (somente leitura)
```

Tudo na **mesma origem** (`https://192.168.1.16`): os cookies httpOnly de auth são
first-party, `secure: true` funciona e não há CORS cruzado.

## Pré-requisitos (uma vez só)

| Software | Onde/Como |
|---|---|
| **Node.js 24 LTS** | https://nodejs.org (MSI). A API roda TS com type-stripping (`node src/server.ts`), sem build. |
| **pnpm 9** | `corepack enable pnpm` (vem com o Node). |
| **Git** | https://git-scm.com (MSI). |
| **MongoDB Community Server** | https://www.mongodb.com/try/download/community (MSI, instala como serviço Windows `MongoDB` na porta 27017). |
| **nginx (Windows)** | https://nginx.org/en/download.html (stable). Descompactar em `C:\nginx`. |
| **NSSM** | https://nssm.cc — roda o nginx como serviço do Windows. |
| **mkcert** | `choco install mkcert` ou `scoop install mkcert` (ou binário do GitHub). Gera a CA local + certificado. |
| **pm2** | `npm i -g pm2 pm2-windows-startup` (auto-start da API no boot). |

> O MongoDB aqui é **nativo** (MSI), não Docker — por isso o `docker-compose.prod.yml`
> não é usado no Windows. O provisionamento de usuários é feito pelo
> `provision-mongodb.ps1` (equivalente ao `docker/mongodb/init-user.js`).

## Passo a passo

### 1. Instalar pré-requisitos
Siga a tabela acima. Confirme: `node -v` (v24.x), `pnpm -v` (9.x), `mkcert -version`.

### 2. Clonar o repositório
```powershell
git clone <URL-do-repo> C:\mirante
cd C:\mirante
pnpm install --frozen-lockfile
```

### 3. Criar o `.env.production` (raiz do repo)
```powershell
Copy-Item .env.production.example .env.production
```
Edite **obrigatoriamente**:

| Variável | Valor |
|---|---|
| `MONGO_ROOT_USERNAME` / `MONGO_ROOT_PASSWORD` | root de administração do MongoDB (só admin) |
| `MONGO_INITDB_USERNAME` / `MONGO_INITDB_PASSWORD` | usuário da aplicação (usado pela API) |
| `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` / `COOKIE_SECRET` | `openssl rand -hex 32` (ou `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`) |
| `CORS_ORIGIN` | `https://192.168.1.16` |
| `WINGRAPHEX_DB_PASSWORD` | `WINGRAPHEX_READ_PASSWORD` do arquivo `docker/wingraphex/.env` (senha de leitura do ERP) |
| `COOKIE_SECURE` | deixe `true` (HTTPS). Não alterar. |

O `config.ts` lê automaticamente o `.env.production` quando `NODE_ENV=production`.

### 4. Provisionar o MongoDB (usuários + auth)
Com o serviço MongoDB rodando e auth ainda desativada (instalação nova):
```powershell
.\deploy\windows\provision-mongodb.ps1
```
Cria `admin` (db `admin`) + usuário da aplicação (`readWrite` no db `mirante`),
habilita `security.authorization` no `mongod.cfg` e reinicia o serviço.

> Se o MongoDB já tiver auth ativada, rode sem `--eval` e crie os usuários manualmente.

### 5. Gerar o certificado HTTPS
```powershell
.\deploy\windows\setup-cert.ps1
```
Gera `deploy/windows/certs/mirante.pem` + `mirante-key.pem` (pasta **gitignorada**)
para `192.168.1.16` e `localhost`, e imprime o caminho da CA.

### 6. Configurar o nginx
1. Backup do `conf/nginx.conf` original e copie o nosso:
   ```powershell
   Copy-Item deploy\windows\nginx.conf C:\nginx\conf\nginx.conf
   ```
2. Teste a config: `C:\nginx\nginx.exe -t`
3. Rode o nginx como serviço (uma vez):
   ```powershell
   nssm install nginx "C:\nginx\nginx.exe"
   nssm set nginx AppDirectory "C:\nginx"
   nssm set nginx AppParameters "-p C:\nginx"
   nssm start nginx
   ```
   > Ajuste `C:/mirante/...` dentro do `nginx.conf` se o repo estiver em outro caminho.

### 7. Subir a API com pm2
```powershell
pm2 start deploy\windows\ecosystem.config.cjs
pm2 save
pm2-startup install     # registra o auto-start no boot (pede elevação)
```
O `ecosystem.config.cjs` roda `apps/api/src/server.ts` com `NODE_ENV=production` e
`LOG_LEVEL=info`. Ajuste o `cwd` se o repo não estiver em `C:\mirante`.

### 8. Build do web + seed do admin

O build de produção usa `VITE_API_URL=/api` (mesma origem via proxy nginx).
Isso é garantido de três formas: o `apps/web/.env.production` (criado pelo
`deploy.ps1` a partir do exemplo, `VITE_API_URL=/api`), a variável de ambiente
`VITE_API_URL=/api` no `deploy.ps1`, e o fallback do `client.ts` (em produção,
sem env var, usa `/api`). Ou seja, um `pnpm build` manual **nunca** vai
embutir `http://localhost:3000/api` (valor do `.env` de dev) no bundle.

```powershell
pnpm build --filter=mirante-web --force
pnpm --filter=mirante-api seed  # cria/atualiza o admin (SEED_ADMIN_*)
```

> **Ou** rode tudo de uma vez com `.\deploy\windows\deploy.ps1` (passos 6–8 + reloads).

### 9. Instalar a CA nas máquinas clientes
Cada computador que acessar o app precisa confiar na CA do mkcert. Copie o
`rootCA.pem` (caminho impresso pelo `setup-cert.ps1`, geralmente
`%LOCALAPPDATA%\mkcert\rootCA.pem`) e instale:
> Clique 2x → **Instalar Certificado** → Usuário Atual → **Autoridades de Certificacao Raiz Confiaveis** → Concluir.

Sem isso o navegador bloqueia com `ERR_CERT_AUTHORITY_INVALID`.

### 10. Validar
```powershell
pm2 status            # mirante-api online
curl https://192.168.1.16/api/health
```
Espere: `{"status":"ok","db":1,"wingraphex":true}`. Depois abra
`https://192.168.1.16` e faça login.

## Atualizações futuras
```powershell
.\deploy\windows\deploy.ps1
```
(git pull → install → build web com `VITE_API_URL=/api` → seed → pm2 reload → nginx reload)

## Troubleshooting

| Sintoma | Causa provável / Solução |
|---|---|
| Login não persiste / cookie não é salvo | `COOKIE_SECURE=true` sem HTTPS → acesse via `https://`; ou CA não instalada no cliente |
| Erro de CORS em produção (`localhost:3000`) | Build do web feito sem `VITE_API_URL=/api` → o bundle chama o localhost do cliente. Refaça o build (fallback do `client.ts` e `apps/web/.env.production` garantem `/api`). |
| `ERR_CERT_AUTHORITY_INVALID` no navegador | Instale o `rootCA.pem` do mkcert na máquina cliente |
| `503` nos endpoints `/api/wingraphex/*` | MySQL do ERP inacessível — a API sobe mesmo assim (pool lazy). Verifique `192.168.1.16:3307` e o `WINGRAPHEX_DB_PASSWORD` |
| `wingraphex:false` no `/api/health` | Pool não conectou no `SELECT 1` — confira credenciais/firewall |
| Rate limit 429 ao usar a LAN | `trustProxy` foi ativado (`app.ts`) para o IP real chegar; se ainda limitar, aumente `max` no `@fastify/rate-limit` |
| npm/pm2 não reconhecidos no PowerShell | Abra um terminal novo após instalar; pm2 global exige o PATH atualizado |