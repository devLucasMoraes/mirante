@echo off
setlocal EnableExtensions
rem ============================================================
rem Mirante - start/stop/restart do app completo (Windows)
rem Componentes: nginx (servico) + API (pm2) [+ MongoDB se "db"]
rem
rem Uso:
rem   restart-mirante.bat            -> restart (nginx + API)
rem   restart-mirante.bat start      -> start (nginx + API)
rem   restart-mirante.bat stop       -> stop (nginx + API)
rem   restart-mirante.bat restart db -> restart incluindo MongoDB
rem   restart-mirante.bat start db   -> start incluindo MongoDB
rem ============================================================

set "PM2_HOME=C:\Users\Admin\.pm2"
set "PATH=C:\Program Files\nodejs;C:\Users\Admin\AppData\Roaming\npm;%PATH%"
set "ECOSYSTEM=C:\mirante\deploy\windows\ecosystem.config.cjs"

set "ACTION=restart"
if /i "%~1"=="start" set "ACTION=start"
if /i "%~1"=="stop" set "ACTION=stop"
if /i "%~1"=="restart" set "ACTION=restart"

set "WITH_DB=0"
if /i "%~1"=="db" set "WITH_DB=1"
if /i "%~2"=="db" set "WITH_DB=1"

rem --- auto-elevacao (stop/start de servicos exige admin) ---
net session >nul 2>&1
if errorlevel 1 (
  echo Elevando para administrador...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
  exit /b
)

echo.
echo ==== Mirante: %ACTION% ====
echo.

if "%ACTION%"=="stop"   goto :stop
if "%ACTION%"=="start"  goto :start

rem ---------------- restart ----------------
:restart
echo -- nginx: restart --
net stop nginx >nul 2>&1
net start nginx
if errorlevel 1 (
  echo ERRO: falha ao iniciar o nginx.
) else (
  echo nginx: OK
)
echo -- API (pm2): restart --
call pm2 restart mirante-api --update-env
if errorlevel 1 (
  echo AVISO: pm2 restart falhou; tentando start via ecosystem...
  call pm2 start %ECOSYSTEM% --update-env
)
call pm2 save
if "%WITH_DB%"=="1" (
  echo -- MongoDB: restart --
  net stop MongoDB >nul 2>&1
  net start MongoDB
  if errorlevel 1 ( echo ERRO: falha ao iniciar o MongoDB. ) else ( echo MongoDB: OK )
)
goto :done

rem ---------------- start ----------------
:start
echo -- nginx: start --
net start nginx >nul 2>&1
sc query nginx | findstr /C:"RUNNING" >nul && echo nginx: OK || echo AVISO: nginx nao esta RUNNING
echo -- API (pm2): start --
call pm2 resurrect
call pm2 startOrReload %ECOSYSTEM% --update-env
call pm2 save
echo -- API (pm2): status --
call pm2 status
if "%WITH_DB%"=="1" (
  echo -- MongoDB: start --
  net start MongoDB >nul 2>&1
  sc query MongoDB | findstr /C:"RUNNING" >nul && echo MongoDB: OK || echo AVISO: MongoDB nao esta RUNNING
)
goto :done

rem ---------------- stop ----------------
:stop
echo -- nginx: stop --
net stop nginx >nul 2>&1
sc query nginx | findstr /C:"RUNNING" >nul && echo AVISO: nginx continua rodando || echo nginx: OK
echo -- API (pm2): stop --
call pm2 stop mirante-api
if "%WITH_DB%"=="1" (
  echo -- MongoDB: stop --
  net stop MongoDB >nul 2>&1
  sc query MongoDB | findstr /C:"RUNNING" >nul && echo AVISO: MongoDB continua rodando || echo MongoDB: OK
)
goto :done

:done
echo.
echo ==== Mirante: %ACTION% concluido ====
echo -- Health check: --
curl -s -m 10 http://127.0.0.1:3000/health
echo.
if /i not "%ACTION%"=="stop" (
  echo -- Logs: abrindo janelas de visualizacao --
  call "%~dp0logs-mirante.bat"
)
endlocal