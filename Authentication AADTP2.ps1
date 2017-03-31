$AADUserName='aaadmin@sdistack.onmicrosoft.com'
$AADPassword='Intel123!'|ConvertTo-SecureString -Force -AsPlainText
$AADCredential=New-Object PSCredential($AADUserName,$AADPassword)
 
$AADTenantID = ($AADUserName -split '@')[1]

Add-AzureRmEnvironment -Name "AzureStack" `
    -ActiveDirectoryEndpoint ("https://login.windows.net/$AADTenantID/") `
    -ActiveDirectoryServiceEndpointResourceId (Invoke-RestMethod "https://api.azurestack.local/metadata/endpoints?api-version=2015-01-01").authentication.audiences[0] `
    -ResourceManagerEndpoint 'https://api.azurestack.local/' `
    -GalleryEndpoint 'https://gallery.azurestack.local:30015/' `
    -GraphEndpoint 'https://graph.windows.net/' `
    -AzureKeyVaultDnsSuffix 'https://vault.azurestack.local/'
 
 

$env = Get-AzureRmEnvironment 'AzureStack'
Add-AzureRmAccount -Environment $env -Credential $AADCredential

Get-AzureRmSubscription -SubscriptionName 'Default Provider Subscription' | Select-AzureRmSubscription