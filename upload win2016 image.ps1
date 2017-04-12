 
 cd C:\Users\AzureStackAdmin\Desktop\AzureStack-Tools-master

 Import-Module .\Connect\AzureStack.Connect.psm1 
 Import-Module .\ComputeAdmin\AzureStack.ComputeAdmin.psm1

 Set-Item wsman:\localhost\Client\TrustedHosts -Value "192.168.200.65" -Concatenate

$Password = ConvertTo-SecureString "Password" -AsPlainText -Force
$aadTenant = Get-AzureStackAadTenant -HostComputer 192.168.200.65 -Password $Password
Login-AzureRMAccount

 $ISOPath = "E:\imagestoimport\win2016.ISO"
 New-Server2016VMImage -ISOPath $ISOPath -TenantId $aadTenant -IncludeLatestCU