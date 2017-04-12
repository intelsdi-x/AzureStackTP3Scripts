# One time requirement

Install-Module -Name AzureRM -RequiredVersion 1.2.8
Install-Module -Name AzureStack
 
set-location C:\Users\AzureStackAdmin\Desktop
Invoke-WebRequest -UseBasicParsing -Uri https://github.com/Azure/AzureStack-Tools/archive/master.zip -OutFile master.zip
Expand-Archive -Path .\master.zip -DestinationPath . -Force
$Folder = New-Item -ItemType Directory -Path ~\Documents\WindowsPowerShell\Modules -Force
Get-ChildItem -Path .\AzureStack-Tools-master -Directory | ForEach-Object -Process {
    if (Get-ChildItem -Path $_.FullName -Filter *.psm1) {
        $PSM1 = Get-ChildItem -Path $_.FullName -Filter *.psm1
        Copy-Item -Path $_.FullName -Destination "$($Folder.FullName)\$($PSM1.BaseName)" -Recurse
        New-ModuleManifest -Path "$($Folder.FullName)\$($PSM1.BaseName)\$($PSM1.BaseName).psd1" -RootModule $PSM1.BaseName
    }
} 
#endregion
 
$Password = ConvertTo-SecureString "Password" -AsPlainText -Force
$AadTenant = Get-AzureStackAadTenant -HostComputer 192.168.200.65 -Password $Password
 
# Use this command to access the administrative portal
Add-AzureStackAzureRmEnvironment -AadTenant $AadTenant -Name AzureStack
# Use this command to access the tenant portal
Add-AzureStackAzureRmEnvironment -AadTenant $AadTenant -ArmEndpoint https://publicapi.local.azurestack.external -Name AzureStack
 
Login-AzureRmAccount -EnvironmentName "AzureStack" -TenantId $AadTenant


Get-AzureRmSubscription -SubscriptionName 'Default Provider Subscription' | Select-AzureRmSubscription