#Esse script salva o nome do computador e o IP na coluna Info do usuário.
Param(
[Parameter(Position=0)]
[ValidateSet("Nome do PC","IP")]
[string]$Status="Unknown"
)

#Get IP Address
$env:HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

#Remove espaços do filtro
[adsisearcher]$searcher="samaccountname=$env:username"
#Utiliza o usuario atual
$find = $searcher.FindOne()
#Criar objeto usuario
[adsi]$user = $find.Path
#Salvar IP e Nome do Computador
$note = "Nome do PC: {0}, Endereco IP: {1}" -f $env:computername,$env:HostIP
#Atualizar coluna Info do usuario
$user.Info=$note
#Commitar alteracoes
$user.SetInfo()