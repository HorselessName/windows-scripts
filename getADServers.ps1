Import-Module ActiveDirectory
$listaServidores = [ordered] @{}

# Raw command:
# Get-ADComputer -Filter "(OperatingSystem -Like '*' -and Enabled -eq 'True')" -Property OperatingSystem, IPv4Address | 
# Select-Object Name, DNSHostName, IPv4Address, OperatingSystem |

# Exportar para JSON: ConvertTo-Json | Set-Content -Encoding Utf8 "C:\adServers.json"
Get-ADComputer -Filter "(OperatingSystem -Like '*Windows Server*' -and Enabled -eq 'True')" -Property OperatingSystem, IPv4Address | 
Select-Object Name, DNSHostName, IPv4Address, OperatingSystem |
Group-Object {
    switch -Wildcard ($_.OperatingSystem) {
        '*Windows Server*'  { 'Windows Servers' }
        '*Windows 7*'   { 'Outdated Computers' } # I will use this later. Outdated users, need to update to Windows 10
        Default             { 'Others' } # Other devices Discovery Rules. Will dig around later
    }
} | 
ForEach-Object {
    $listaServidores[$_.Name] = 
        @($_.Group | Select-Object Name, DNSHostName, @{ Name='IP'; Expression='IPv4Address'})
}

$listaServidores | ConvertTo-Json -Depth 3 # !! -Depth is needed to avoid truncation
    # Set-Content -Encoding Utf8 "C:\adServers.json"