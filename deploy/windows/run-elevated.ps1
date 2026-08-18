<#
.SYNOPSIS
  Etapas ELEVADAS do deploy do Mirante no Windows (rodar como Administrador).

.DESCRIPTION
  Executa os passos que exigem elevacao, nesta ordem:
    1. inicia o servico MongoDB e faz o provisionamento de usuarios (provision-mongodb.ps1);
    2. seed do admin (idempotente);
    3. instala/configura o nginx (copiar conf, nginx -t, servico NSSM, start);
    4. (re)inicia a API via pm2, salva o estado e registra o auto-start;
    5. libera 80/443 no firewall do Windows.

  Rode A PARTIR da raiz do repo:  .\deploy\windows\run-elevated.ps1
  (PowerShell como Administrador).

.PARAMETER RepoRoot
  Caminho do clone do repo.

.PARAMETER NginxExe
  Caminho do nginx.exe.

.EXAMPLE
  .\deploy\windows\run-elevated.ps1
#>
param(
  [string]$RepoRoot = "C:\mirante",
  [string]$NginxExe = "C:\nginx\nginx.exe"
)

$ErrorActionPreference = "Stop"
Set-Location $RepoRoot
$env:NODE_ENV = "production"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "Este script precisa de elevacao. Abra o PowerShell como Administrador e rode novamente."
  exit 1
}

# Log da execucao elevada (para leitura posterior)
$logDir = Join-Path $PSScriptRoot "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "elevated-$(Get-Date -Format yyyyMMdd-HHmmss).log"
Start-Transcript -Path $logFile -Append | Out-Null
Write-Host "==> Log em $logFile"

# 1) MongoDB: servico + provisionamento de usuarios
Write-Host "==> MongoDB: iniciando servico"
$svc = Get-Service -Name MongoDB -ErrorAction SilentlyContinue
if (-not $svc) { throw "Servico MongoDB nao encontrado. Instale o MongoDB Community Server (MSI)." }
if ($svc.Status -ne "Running") { Start-Service -Name MongoDB }

Write-Host "==> Provisionamento do MongoDB (usuarios + auth)"
& "$RepoRoot\deploy\windows\provision-mongodb.ps1" -RepoRoot $RepoRoot
if ($LASTEXITCODE -ne 0) { throw "Provisionamento do MongoDB falhou." }

# 2) Seed do admin
Write-Host "==> Seed do admin"
pnpm --filter=mirante-api seed
if ($LASTEXITCODE -ne 0) { throw "Seed do admin falhou." }

# 3) nginx: config + servico NSSM
if (-not (Test-Path $NginxExe)) {
  Write-Host "nginx nao encontrado em $NginxExe. Pule esta etapa ou ajuste -NginxExe."
} else {
  $nginxConf = "$NginxExe\..\..\conf\nginx.conf"
  $nginxConf = [System.IO.Path]::GetFullPath($nginxConf)

  Write-Host "==> nginx: backup e copia da config"
  if (Test-Path $nginxConf) {
    Copy-Item $nginxConf "$nginxConf.bak-$(Get-Date -Format yyyyMMdd-HHmmss)" -Force
  }
  Copy-Item "$RepoRoot\deploy\windows\nginx.conf" $nginxConf -Force

  Write-Host "==> nginx: validando config"
  & $NginxExe -t -p "C:\nginx"
  if ($LASTEXITCODE -ne 0) { throw "nginx -t falhou. Corrija o nginx.conf antes de instalar o servico." }

  Write-Host "==> nginx: instalando servico NSSM (se ainda nao existe)"
  $existing = Get-Service -Name nginx -ErrorAction SilentlyContinue
  if (-not $existing) {
    nssm install nginx $NginxExe
    nssm set nginx AppDirectory "C:\nginx"
    nssm set nginx AppParameters "-p C:\nginx"
  }
  if ((Get-Service -Name nginx).Status -ne "Running") { Start-Service nginx }
  Write-Host "Servico nginx: $(Get-Service nginx | Select-Object -ExpandProperty Status)"
}

# 4) pm2: API + auto-start
Write-Host "==> pm2: (re)iniciando a API e salvando o estado"
pm2 startOrReload "$RepoRoot\deploy\windows\ecosystem.config.cjs" --update-env
if ($LASTEXITCODE -ne 0) { throw "pm2 startOrReload falhou." }
pm2 save
Write-Host "==> pm2: registrando auto-start no boot"
pm2-startup install

# 5) Firewall: libera 80/443 para acesso via LAN
Write-Host "==> Firewall: liberando portas 80/443"
netsh advfirewall firewall delete rule name="Mirante nginx 80/443" 2>$null | Out-Null
netsh advfirewall firewall add rule name="Mirante nginx 80/443" dir=in action=allow protocol=TCP localport=80,443

Write-Host ""
Write-Host "Etapas elevadas concluidas."
Write-Host "Valide: curl https://192.168.1.16/api/health e abra https://192.168.1.16"
Stop-Transcript | Out-Null
