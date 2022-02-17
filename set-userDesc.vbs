' Coloca HOSTNAME e IP na descrição do usuário no AD
Set objSysInfo = CreateObject("ADSystemInfo")
Set objUser = GetObject("LDAP://" & objSysInfo.UserName)
Set objComputer = GetObject("LDAP://" & objSysInfo.ComputerName)

strComputer = "." 
Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set IPs = objWMIService.ExecQuery _ 
 ("Select IpAddress from Win32_networkadapterconfiguration where IPEnabled = True") 
For Each IP in IPs
 strIPaddr = IP.IPAddress(i)
Next
strMessage = objComputer.CN & " - " & strIPaddr
objUser.Description = strMessage
objUser.SetInfo

Msgbox "Procedimento completo"