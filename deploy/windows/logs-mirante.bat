@echo off
setlocal EnableExtensions
rem ============================================================
rem Mirante - abre janelas de terminal com os logs ao vivo
rem Uso:
rem   logs-mirante.bat          -> abre as 3 janelas (API + nginx)
rem
rem As janelas ficam abertas acompanhando os logs em tempo real.
rem Fechar uma janela apenas encerra o acompanhamento, nao o servico.
rem ============================================================

set "PM2_HOME=C:\Users\Admin\.pm2"
set "PATH=C:\Program Files\nodejs;C:\Users\Admin\AppData\Roaming\npm;%PATH%"

rem --- API (pm2): log em tempo real ---
start "Mirante API - logs" cmd /k "pm2 logs mirante-api --lines 50"

rem --- nginx: log de acesso em tempo real ---
start "Mirante nginx - acesso" cmd /k powershell -NoProfile -Command "Get-Content 'C:\nginx\logs\access.log' -Wait -Tail 30"

rem --- nginx: log de erros em tempo real ---
start "Mirante nginx - erros" cmd /k powershell -NoProfile -Command "Get-Content 'C:\nginx\logs\error.log' -Wait -Tail 30"

endlocal