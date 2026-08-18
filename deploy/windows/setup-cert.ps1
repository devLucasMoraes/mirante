<#
.SYNOPSIS
  Gera o certificado HTTPS self-signed do Mirante com o mkcert.

.DESCRIPTION
  - Instala a CA local do mkcert no trust store do usuario atual;
  - gera o certificado para os hosts informados (default: 192.168.1.16 e localhost)
    em deploy/windows/certs/;
  - imprime o caminho da CA para instalar nas maquinas clientes (rootCA.pem).

  O certificado e self-signed porque o servico roda em IP privado (192.168.1.16) -
  o Let's Encrypt nao emite certificados para IPs/ranges privados.

.PARAMETER CertDir
  Pasta de saida dos certificados (gitignorada).

.PARAMETER Hosts
  Hosts (IPs/dominios) cobertos pelo certificado.

.EXAMPLE
  .\deploy\windows\setup-cert.ps1 -Hosts @("192.168.1.16", "localhost")
#>
param(
  [string]$CertDir = (Join-Path $PSScriptRoot "certs"),
  [string[]]$Hosts = @("192.168.1.16", "localhost")
)

$ErrorActionPreference = "Stop"

# 1) mkcert disponivel?
$mkcert = Get-Command mkcert -ErrorAction SilentlyContinue
if (-not $mkcert) {
  Write-Host @"

mkcert nao encontrado no PATH. Instale-o de uma destas formas:

  - Chocolatey:  choco install mkcert
  - Scoop:       scoop install mkcert
  - Manual: baixe o binario em https://github.com/FiloSottile/mkcert/releases
              e coloque mkcert.exe em uma pasta do PATH.

Depois rode este script novamente.
"@
  exit 1
}

# 2) Instalar a CA local no trust store (do usuario que executa)
& mkcert -install
if ($LASTEXITCODE -ne 0) { throw "Falha ao instalar a CA do mkcert." }

# 3) Gerar o certificado
New-Item -ItemType Directory -Force -Path $CertDir | Out-Null
$certFile = Join-Path $CertDir "mirante.pem"
$keyFile  = Join-Path $CertDir "mirante-key.pem"

& mkcert -cert-file $certFile -key-file $keyFile $Hosts
if ($LASTEXITCODE -ne 0) { throw "Falha ao gerar o certificado." }

Write-Host ""
Write-Host "Certificados gerados:"
Write-Host "  $certFile"
Write-Host "  $keyFile"
Write-Host ""

# 4) Instrucoes para as maquinas clientes
$caRoot = (& mkcert -CAROOT).Trim()
Write-Host @"

PROXIMO PASSO - MAQUINAS CLIENTES:
  Cada computador que vai acessar https://192.168.1.16 precisa confiar na CA do mkcert,
  senao o navegador acusa certificado nao confiavel (ERR_CERT_AUTHORITY_INVALID).

  Copie o arquivo abaixo para cada cliente e instale em
  Certificados > Autoridades de Certificacao Raiz Confiaveis:
    $caRoot\rootCA.pem

  No Windows, basta clicar 2x no rootCA.pem -> Instalar Certificado ->
  Maquina Local / Usuario Atual -> Armazenamento: "Autoridades de Certificacao Raiz Confiaveis".
"@