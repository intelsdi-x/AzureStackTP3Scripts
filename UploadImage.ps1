Import-Module .\AzureStack.ComputeAdmin.psm1
Add-VMImage -publisher "OpenLogic" -offer "Centos" -sku "14.04.3-LTS" -version "7.2.0" -osType Linux -osDiskLocalPath 'E:\imagestoimport\OpenLogic-CentOS-7.2-Oct-04-2016.vhd' -tenantID sdistack.onmicrosoft.com
Add-VMImage -publisher "Linux" -offer "CoreOS" -sku "LTS" -version "7.0.0" -osType Linux -osDiskLocalPath 'E:\imagestoimport\coreos_production_azure_image.vhd' -tenantID sdistack.onmicrosoft.com
Add-VMImage -publisher "Windows" -offer "NanoServer" -sku "2016" -version "10.0.0" -osType Windows -osDiskLocalPath 'E:\imagestoimport\NanoServerDataCenter.vhd' -tenantID sdistack.onmicrosoft.com
Add-VMImage -publisher "Linux" -offer "Ubuntu" -sku "2016" -version "16.0.4" -osType Linux -osDiskLocalPath 'E:\imagestoimport\xenial-server-cloudimg-amd64-disk1.vhd' -tenantID sdistack.onmicrosoft.com


