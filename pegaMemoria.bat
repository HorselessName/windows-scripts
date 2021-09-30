@echo off

REM Get memory from proccess using service name
REM Exemplo no CMD: pegaMemoria.bat MSSQLSERVER (Onde MSSQLSERVER = %1)
set serviceName=%1

REM Pega o PID do processo
for /f "tokens=2 delims=," %%A in ('tasklist /svc /fi "SERVICES eq %%serviceName%%" /FO csv /NH
') do (
	REM Store PID
	@Set "pidSvc=%%~A"
)

REM Get memory from process with PID
for /f "tokens=5 delims= " %%B in ('tasklist /fi "pid eq %%pidSvc%%" /NH') do (
REM Put memory value on var
@Set memSvc=%%~B
)

REM Remove a virgula do resultado
@Set memSvc=%memSvc:,=%
@Echo %memSvc%