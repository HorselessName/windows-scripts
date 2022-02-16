$dell = "dell-323"
$updateInfoMsg = "Status do Windows Update: `n";
$output += Invoke-Command -ComputerName $dell -ScriptBlock {

$UpdateSession = New-Object -ComObject Microsoft.Update.Session;
$UpdateSearcher = $UpdateSession.CreateupdateSearcher();
$Updates = @($UpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0 and Type='Software'").Updates);
$Found = ($Updates | Select-Object -Expand Title);

If ($Null -eq $Found) {
    $updateInfoMsg += "Up to date";
} Else {
    $Found = ($Updates | Select-Object -Expand Title) -Join "`n";
    $updateInfoMsg += "Updates available:`n";
    $updateInfoMsg += $Found;
}

return $updateInfoMsg;
}