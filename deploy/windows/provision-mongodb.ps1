<#
.SYNOPSIS
  Provisiona o MongoDB Community Server (instalacao MSI) com os usuarios do Mirante.

.DESCRIPTION
  Replica o docker/mongodb/init-user.js para instalacao NATIVA do MongoDB no Windows:
  - cria o usuario root (db admin) e o usuario da aplicacao (readWrite no db do app);
  - habilita a autenticacao (security.authorization: enabled) no mongod.cfg;
  - reinicia o servico e verifica a conexao com o usuario da aplicacao.

  Presume instalacao NOVA (auth ainda desativada). Credenciais sao lidas do
  .env.production na raiz do repo (MONGO_ROOT_* e MONGO_INITDB_*), com opcao de
  sobrescrever por parametro.

.EXAMPLE
  .\deploy\windows\provision-mongodb.ps1
#>
param(
  [string]$RepoRoot = "C:\mirante",
  [string]$MongoBin = "C:\Program Files\MongoDB\Server",
  [string]$ServiceName = "MongoDB",
  [string]$RootUsername,
  [string]$RootPassword,
  [string]$AppUsername,
  [string]$AppPassword,
  [string]$AppDb = "mirante"
)

$ErrorActionPreference = "Stop"

function Get-EnvValue {
  param([string]$File, [string]$Key)
  if (-not (Test-Path $File)) { return $null }
  $match = Select-String -Path $File -Pattern "^$Key=(.*)$"
  if ($match) { return $match.Matches[0].Groups[1].Value.Trim() }
  return $null
}

# 1) Credenciais: parametro > .env.production
$envFile = Join-Path $RepoRoot ".env.production"
$rootUser = if ($RootUsername) { $RootUsername } else { Get-EnvValue $envFile "MONGO_ROOT_USERNAME" }
$rootPass = if ($RootPassword) { $RootPassword } else { Get-EnvValue $envFile "MONGO_ROOT_PASSWORD" }
$appUser  = if ($AppUsername)  { $AppUsername  } else { Get-EnvValue $envFile "MONGO_INITDB_USERNAME" }
$appPass  = if ($AppPassword)  { $AppPassword  } else { Get-EnvValue $envFile "MONGO_INITDB_PASSWORD" }

if (-not $rootUser -or -not $rootPass -or -not $appUser -or -not $appPass) {
  throw "Nao foi possivel obter as credenciais. Defina MONGO_ROOT_* e MONGO_INITDB_* em $envFile (ou passe via parametro)."
}

# 2) Localizar mongod.cfg / mongosh.exe
$mongodCfg = Get-ChildItem "$MongoBin\*\bin\mongod.cfg" -ErrorAction SilentlyContinue |
  Sort-Object FullName -Descending | Select-Object -First 1
if (-not $mongodCfg) {
  throw "mongod.cfg nao encontrado em $MongoBin. Instale o MongoDB Community Server (MSI) primeiro."
}
Write-Host "mongod.cfg: $($mongodCfg.FullName)"

$mongosh = Get-ChildItem "$MongoBin\*\bin\mongosh.exe" -ErrorAction SilentlyContinue |
  Sort-Object FullName -Descending | Select-Object -First 1
if (-not $mongosh) { throw "mongosh.exe nao encontrado em $MongoBin." }

# 3) Servico MongoDB rodando
$svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if (-not $svc) { throw "Servico '$ServiceName' nao encontrado. Instale o MongoDB como servico do Windows." }
if ($svc.Status -ne "Running") {
  Write-Host "Iniciando servico '$ServiceName'..."
  Start-Service -Name $ServiceName
}

# 4) Criar os usuarios (presume auth desativada). Idempotente: se o usuario ja existe, ignora.
#    Obs.: se a auth JAH estiver ativada, esta etapa falha e nao ha suporte a re-provisionamento.
$eval = @"
const root = db.getSiblingDB('admin');
try {
  root.createUser({ user: '$rootUser', pwd: '$rootPass', roles: [{ role: 'root', db: 'admin' }] });
  print('root criado');
} catch (e) {
  if (e.codeName === 'DuplicateKey') { print('root ja existe'); }
  else { throw e; }
}
const app = db.getSiblingDB('$AppDb');
try {
  app.createUser({ user: '$appUser', pwd: '$appPass', roles: [{ role: 'readWrite', db: '$AppDb' }] });
  print('usuario do app criado');
} catch (e) {
  if (e.codeName === 'DuplicateKey') { print('usuario do app ja existe'); }
  else { throw e; }
}
"@

Write-Host "Criando usuarios '$rootUser' (admin) e '$appUser' (db $AppDb)..."
& $mongosh.FullName --quiet --eval $eval
if ($LASTEXITCODE -ne 0) {
  Write-Host "Falha ao criar usuarios. Se o MongoDB ja estava com auth ativada, crie os usuarios manualmente (root no admin, app com readWrite em $AppDb)."
  exit $LASTEXITCODE
}

# 5) Habilitar authorization no mongod.cfg
$cfgText = Get-Content $mongodCfg.FullName -Raw
if ($cfgText -match "(?m)^\s*authorization:") {
  Write-Host "Authorization ja habilitado no mongod.cfg."
} else {
  Add-Content $mongodCfg.FullName "`nsecurity:`n  authorization: enabled`n"
  Write-Host "Authorization habilitado no mongod.cfg."
}

# 6) Reiniciar o servico para aplicar a configuracao
Restart-Service -Name $ServiceName
Write-Host "Servico '$ServiceName' reiniciado com auth ativada."

# 7) Verificar conexao como usuario da aplicacao (authSource = db do app)
$uri = "mongodb://$appUser:$appPass@127.0.0.1:27017/$AppDb?authSource=$AppDb"
& $mongosh.FullName --quiet $uri --eval "db.runCommand({ ping: 1 }).ok"
if ($LASTEXITCODE -eq 0) {
  Write-Host "OK - MongoDB autenticado com o usuario da aplicacao."
} else {
  Write-Host "Falha na verificacao. Confira mongod.cfg, servico e credenciais."
  exit $LASTEXITCODE
}