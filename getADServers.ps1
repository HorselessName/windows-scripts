Import-Module ActiveDirectory
# Exportar para JSON: ConvertTo-Json | Out-File "C:\adServers.json"
Get-ADComputer -Filter "OperatingSystem -Like '*Windows Server*' -and Enabled -eq 'True'" -Property OperatingSystem, IPv4Address | Select-Object Name, DNSHostName, IPv4Address, OperatingSystem
