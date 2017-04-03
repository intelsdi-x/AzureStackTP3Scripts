# AzureStackTP3Scripts
Script for Autorization and Marketplace Items


## To work with the Azure’s Resource Manager on setup and get Authorization Token use this scripts:<br>

Requirement: Install Module AzureRM by on time run: onetimerun.ps1
For Azure Stack TP2 use - Authentication AADTP2.ps1
Or
For Azure Stack TP3 use - Authorization AADTP3.ps1

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

##To Upload your images to marketplace in AzureStack use script: UploadImage.ps1
Requirement: Downloaded Azure Tools and then make sure the following modules are imported:.\AzureStack.ComputeAdmin.psm1.
Script include required modules and provide example path wit images to import - UploadImage.ps1




