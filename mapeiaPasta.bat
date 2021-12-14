@echo off
setlocal

:ping
ping SERVIDOR_DE_ARQUIVOS -n 1 -w 1000 >nul

IF %ERRORLEVEL% == 1 (

echo "Atencao! Voce esta sem rede no momento. Conecte-se na rede."
echo "O programa vai tentar novamente mapear os arquivos em 15 segundos"
echo.

timeout 15
echo.

goto ping

) ELSE (

net use * /delete /Y
net use X: \\CAMINHO_DA_PASTA /Y /user:USUARIO@DOMINIO SENHA >nul

echo "Arquivos mapeados com sucesso"
echo "Caso a pasta nao tenha sido mapeada, execute o arquivo da area de trabalho chamado MAPEAMENTO DE ARQUIVOS"
echo.

echo "Se voce encontrar problemas, entre em contato com a TI."

echo.

pause
exit

)