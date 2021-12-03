REM Raiz do diretorio de dados e seta caminho do arquivo para exportacao
SET objRootDSE = GETOBJECT("LDAP://RootDSE") 
strExportFile = "C:\temp\usersAD.xlsx"  

strRoot = objRootDSE.GET("DefaultNamingContext") 
strfilter = "(&(objectCategory=Person)(objectClass=User))" 

REM Pega somente usuario e email cadastrado
strAttributes = "sAMAccountName," & _ 
                "mail,"
strScope = "subtree" 

SET cn = CREATEOBJECT("ADODB.Connection") 
SET cmd = CREATEOBJECT("ADODB.Command") 
cn.Provider = "ADsDSOObject" 
cn.Open "Active Directory Provider" 
cmd.ActiveConnection = cn 
 
cmd.Properties("Page Size") = 1000  
cmd.commandtext = "<LDAP://" & strRoot & ">;" & strFilter & ";" & _ 
                                   strAttributes & ";" & strScope 
 
SET rs = cmd.EXECUTE 

REM Configura para exportacao formato Excel
SET objExcel = CREATEOBJECT("Excel.Application") 
SET objWB = objExcel.Workbooks.Add 
SET objSheet = objWB.Worksheets(1) 
 
for x = 0 to rs.Fields.count -1
	'msgbox( rs.fields(x).name )	
next
 
objSheet.visible = true
objSheet.Range("A2").CopyFromRecordset(rs) 
objWB.SaveAs(strExportFile)  
 
rs.close 
cn.close 

SET objSheet = NOTHING 
SET objWB =  NOTHING 
objExcel.Quit() 
SET objExcel = NOTHING 
 
Wscript.echo "Planilha exportada para: " & strExportFile