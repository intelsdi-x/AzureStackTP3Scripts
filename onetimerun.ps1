Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    $AzureModule = "c:\Program Files\WindowsPowerShell\Modules\AzureRM\1.2.6\AzureRM.psd1"
    if (Test-Path $AzureModule){
        Import-Module $AzureModule -Global
          } else { 
                Install-Module -Name AzureRM -RequiredVersion 1.2.6 
                }
    Import-Module -Name "AzureRM" -Erroraction SilentlyContinue 