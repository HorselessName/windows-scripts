@echo off
setlocal
REM Force UTF-8 to fix some output problems
chcp 65001 > nul

REM #######################################################################################################################
REM → Ferramentas utilizadas: ←
REM → OpenVPN Portable: https://portapps.io/app/openvpn-portable/ ←
REM → Instalador do TAP Adapter: app\win*\bin\tapinstall.exe ←
REM → Config da VPN, dentro do arquivo zipado. ←
REM #######################################################################################################################

set pasta_de_trabalho=C:\Workdir
set ferramentas=C:\Tools

REM Create folders that do not exist ---- Ajuste as pastas caso necessário. 
REM ** Destino → Pasta global utilizada por todos os usuários **
if not exist "%ferramentas%" mkdir "%ferramentas%"
if not exist "%pasta_de_trabalho%" mkdir "%pasta_de_trabalho%"
if not exist "%pasta_de_trabalho%\VPN" mkdir "%pasta_de_trabalho%\VPN"
if not exist "%pasta_de_trabalho%\VPN\config" mkdir "%pasta_de_trabalho%\VPN\config"
if not exist "%pasta_de_trabalho%\VPN\logs" mkdir "%pasta_de_trabalho%\VPN\logs"

REM Download 7Zip tool
bitsadmin /transfer 7Zip /download /priority high https://dl.dropbox.com/s/4g696tvh60bbhbh/7za.exe %ferramentas%\7za.exe >nul

REM Como conseguir o arquivo VPN.zip → Exporte o arquivo de dentro do seu VPN Server.

REM Extract files in archive and rename OVPN file.
for %%f in (%pasta_de_trabalho%\VPN.zip) do (

"%ferramentas%\7za.exe" e "%%f" -ba -y -so -r *\*.ovpn 1>%ferramentas%\openvpn\data\config\Empresa.ovpn 2>nul
"%ferramentas%\7za.exe" e "%%f" -ba -y -r *\*.p12 -o%ferramentas%\openvpn\data\config >nul
"%ferramentas%\7za.exe" e "%%f" -ba -y -r *\*.key -o%ferramentas%\openvpn\data\config >nul

) >nul

REM #######################################################################################################
REM Informações interessantes com relação ao entendimento do OpenVPN
REM O Open VPN procura os arquivos de log/config no path regedit → HKEY_CURRENT_USER\SOFTWARE\OpenVPN-GUI
REM #######################################################################################################

REM Instala TAP Adapter - Syntax: "Tapinstall" "Install" "Driver" "ID do Hardware que ficará salvo"
REM Como conseguir o Instalador TAP e os Drivers: Extraindo o executável do OpenVPN Installer. 
REM Procurar pelo executável "tapinstall" e pelos Drivers.

REM Install só funciona se for executado como ADM
wmic nic get name | FIND "TAP" /I /C >nul
if %errorlevel% equ 0 (
REM Adaptador já existe. Não faço nada
) else (
REM Adaptador TAP precisa ser criado - Verifique se existe os drivers na pasta abaixo...
    "%ferramentas%\tapinstall.exe" install "%ferramentas%\tap_drivers\OemVista.inf" tap0901
)

REM Initialize OpenVPN GUI with its respective parameters, in the background.
START "" /B "%ferramentas%\openvpn\openvpn-portable.exe" >nul

PAUSE
endlocal