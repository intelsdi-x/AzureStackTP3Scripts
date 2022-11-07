DISCONTINUATION OF PROJECT. 

This project will no longer be maintained by Intel.

This project has been identified as having known security escapes.

Intel has ceased development and contributions including, but not limited to, maintenance, bug fixes, new releases, or updates, to this project.  

Intel no longer accepts patches to this project.
# AzureStackTP3Scripts
1. Scripts for Autorization and Marketplace Items
2. Scripts for Pre and PostDeployments Checks

## 1. To work with the Azure’s Resource Manager on setup and get Authorization Token use this scripts:<br>

Requirement: Install Module AzureRM by on time run: onetimerun.ps1
For Azure Stack TP2 use 
- Authentication AADTP2.ps1<br>
Or
For Azure Stack TP3 use 
- Authorization AADTP3.ps1

## When Your Metrics Server indicate failed state of services use this script to reset metrics services in your Farm
- checks.ps1

## For Azure Active Directory deployments, you can register Azure Stack with Azure to download marketplace items from Azure .
RegisterToAzure.ps1 runs local scripts to connect your Azure Stack to Azure. After connecting with Azure, you can test marketplace syndication.
To register use - RegisterWithAzure.ps1
To run this script, you must have a public Azure subscription of any type. The owner of the subscription cannot be an MSA or 2FA account.
Usage: 
```powershell
.\RegisterWithAzure.ps1 -azureDirectory yourdirectory.onmicrosoft.com -azureSubscriptionId azureSubscriptionId -azureSubscriptionOwner owner@yourdirectory.onmicrosoft.com
```

## Tools for using Azure and Azure Stack
To use these tools, obtain Azure Stack compatible Azure PowerShell module. Execute script - azurestack-tools.ps1 To install required modulles and download tools. More info goto: <a href=https://github.com/Azure/AzureStack-Tools>AzureStack-Tools</a>

## To Upload your images to marketplace in AzureStack TP2 use script: UploadImage.ps1
Requirement: Downloaded Azure Tools and then make sure the following modules are imported:.\AzureStack.ComputeAdmin.psm1.
Script include required modules and provide example path wit images to import 
- UploadImage.ps1

## To Upload Windows Server image from ISO file to marketplace in AzureStack TP3 
Requirement: Downloaded Azure Tools and then make sure the following modules are imported:.\AzureStack.ComputeAdmin.psm1 and Import-Module .\Connect\AzureStack.Connect.psm1 
 
Script include required modules and provide example path wit images to import 
- Upload_win2016_image.ps1

## To Import Linux images vhd to marketplace in AzureStack TP3
Require Install AzureRM Bootstrapper and set API version
- Import Linux images TP3.ps1

## 2. Deployment Checker for Azure Stack Technical Preview
This script goes through the pre-requisites checks done by the setup for Azure Stack technical previews, starting. It provides a way to confirm you are meeting the hardware and software requirements 
- Invoke-AzureStackDeploymentPreCheck.ps1

## Post Deploy Script AzureStack For TP2
This post-deployment script fixes several important bugs (PasswordPolicy/NAT/WinRM), clears up logs (WinRM/Tracing) and improves the overall performance of your Azure Stack environment 
- PostDeployScript-AzureStack.ps1

## The Right Order to start all VMs in AzureStack
Run this script to bring to onlie all Azure Stack services in Cluster 
- Start_vms.ps1

## Deployment from GIT
This script show how to deploy example extensions from GIT repo into VM run in specific ResourceGroup in our AzureStack 
- Deployment from GIT.ps1


