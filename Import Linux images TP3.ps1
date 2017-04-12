

#Trust the PSGallery (optional)
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

#Install the AzureRM Bootstrapper and set API version
Install-Module -Name AzureRm.BootStrapper
Use-AzureRmProfile -Profile 2017-03-09-profile

$Password = ConvertTo-SecureString "Password" -AsPlainText -Force
$aadTenant = Get-AzureStackAadTenant -HostComputer 192.168.200.65 -Password $Password
Login-AzureRMAccount

$location = "eastus"
$providers = Get-AzureRmVMImagePublisher -Location $location
$offers = Get-AzureRmVMImageOffer -Location $location -PublisherName "Canonical"
$skus = Get-AzureRmVMImageSku -Location $location -PublisherName "Canonical" -Offer "UbuntuServer"

Get-AzureRmVMImage -Location $location -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "16.04-LTS"

#download image from: https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.vhd.zip to:\\SU1fileserver\SU1_Infrastructure_1\

Import-Module .\AzureStack-Tools-master\Connect\AzureStack.Connect.psm1
Import-Module .\AzureStack-Tools-master\ComputeAdmin\AzureStack.ComputeAdmin.psm1
$vhdlocation = "\\su1fileserver\SU1_Infrastructure_1\xenial-server-cloudimg-amd64-disk1.vhd"

$azurestackcredential = Get-Credential

Add-VMImage -publisher Canonical -offer UbuntuServer -sku "16.04-LTS" -version "16.04.201703270" `
 -osDiskLocalPath $vhdlocation -osType Linux -tenantID $aadTenant -location local `
 -azureStackCredentials $azurestackcredential -title "Ubuntu Server 16.04 LTS" -Verbose