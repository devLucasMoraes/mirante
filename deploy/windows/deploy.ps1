<#
.SYNOPSIS
  Deploy/atualizacao do Mirante no servidor Windows (192.168.1.16).

.DESCRIPTION
  - git pull (atualiza o codigo);
  - pnpm install --frozen-lockfile;
  - cria .env.production a partir do exemplo, se ainda nao existir;
  - build do web com VITE_API_URL=/api (mesma origem via proxy nginx);
  - seed do admin (idempotente);
  - (re)inicia a API via pm2 e salva o estado (auto-start);
  - valida e recarrega o nginx.

  Requer: Node 24 + pnpm, pm2 global, nginx instalado em C:\nginx (ou passe -NginxExe),
  repo clonado em C:\mirante (ou passe -RepoRoot).

.PARAMETER RepoRoot
  Caminho do clone do repo.

.PARAMETER NginxExe
  Caminho do nginx.exe.

.PARAMETER SkipInstall
  Pula o pnpm install.

.PARAMETER SkipBuild
  Pula o build do web.

.PARAMETER SkipSeed
  Pula o seed do admin.

.EXAMPLE
  .\deploy\windows\deploy.ps1
#>
param(
  [string]$RepoRoot = "C:\mirante",
  [string]$NginxExe = "C:\nginx\nginx.exe",
  [switch]$SkipInstall,
  [switch]$SkipBuild,
  [switch]$SkipSeed
)

$ErrorActionPreference = "Stop"
Set-Location $RepoRoot
$env:NODE_ENV = "production"

Write-Host "==> git pull"
git pull

if (-not $SkipInstall) {
  Write-Host "==> pnpm install"
  pnpm install --frozen-lockfile
}

if (-not (Test-Path ".env.production")) {
  Write-Host "==> criando .env.production a partir do exemplo"
  Copy-Item ".env.production.example" ".env.production"
  Write-Host "ATENCAO: edite .env.production (senhas, CORS_ORIGIN, WINGRAPHEX_DB_PASSWORD) antes de continuar!"
}

if (-not $SkipBuild) {
  Write-Host "==> build do web (VITE_API_URL=/api, --force p/ ignorar cache turbo)"
  $env:VITE_API_URL = "/api"
  pnpm build --filter=mirante-web --force
}

if (-not $SkipSeed) {
  Write-Host "==> seed do admin"
  pnpm --filter=mirante-api seed
}

Write-Host "==> pm2 (API)"
pm2 startOrReload "$RepoRoot\deploy\windows\ecosystem.config.cjs" --update-env
pm2 save

Write-Host "==> nginx"
if (-not (Test-Path $NginxExe)) {
  Write-Host "nginx nao encontrado em $NginxExe. Pule esta etapa ou ajuste -NginxExe."
} else {
  $nginxPrefix = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($NginxExe))
  & $NginxExe -t -p "$nginxPrefix"
  if ($LASTEXITCODE -ne 0) { throw "nginx -t falhou. Nao foi feito reload." }
  & $NginxExe -s reload -p "$nginxPrefix"
}

Write-Host ""
Write-Host "Deploy concluido. Acesse https://192.168.1.16 (verifique /health no /api)."