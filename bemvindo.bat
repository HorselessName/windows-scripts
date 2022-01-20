@echo off
for /f "tokens=2*" %%a in ('net user "%Username%" /domain ^| find /i "Nome completo"') do set DisplayName=%%b
title Bem vindo!
echo Ola! Seja bem vindo %DisplayName%.
timeout -t 15 >nul
exit