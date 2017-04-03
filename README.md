# AzureStackTP3Scripts
Script for Autorization and Marketplace Items

To work with the Azure’s Resource Manager on setup and get Authorization Token use this scripts:<br>

Requirement: Install Module AzureRM by on time run :<br><a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/onetimerun.ps1>onetimerun.ps1</a><br>

<b>For Azure Stack TP2<br>
<a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/Authentication%20AADTP2.ps1>Authentication AADTP2.ps1</a></b><br>
Or <br>
<b> For Azure Stack TP3<br>
<a href= https://github.com/aisog/AzureStackTP3Scripts/blob/master/Authorization%20AADTP3.ps1>Authorization AADTP3.ps1</a>
</b></br><br>
When Your Metrics Server indicate failed state of services use this script to reset metrics services in your Farm<br>
<a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/checks.ps1>checks.ps1</a><br>
<br>
For Azure Active Directory deployments, you can register Azure Stack with Azure to download marketplace items from Azure .RegisterToAzure.ps1 runs local scripts to connect your Azure Stack to Azure. After connecting with Azure, you can test marketplace syndication.  <br>
To register use <a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/RegisterWithAzure.ps1>RegisterWithAzure.ps1</a><br>
To run this script, you must have a public Azure subscription of any type. The owner of the subscription cannot be an MSA or 2FA account. <br>
Usage: 
.\RegisterWithAzure.ps1 -azureDirectory <i>yourdirectory</i>.onmicrosoft.com -azureSubscriptionId <i>azureSubscriptionId</i> -azureSubscriptionOwner owner@yourdirectory.onmicrosoft.com
<br><br>
<b>Tools for using Azure and Azure Stack</b><br>
To use these tools, obtain Azure Stack compatible Azure PowerShell module. Execute script <a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/azurestack-tools.ps1>azurestack-tools.ps1</a>To install required modulles and download tools. More info goto: <a href=https://github.com/Azure/AzureStack-Tools>AzureStack-Tools</a><br><br>
To Upload your images to marketplace in AzureStack use script :<a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/UploadImage.ps1>UploadImage.ps1</a><br>
Requirement: Downloaded Azure Tools and then make sure the following modules are imported:.\AzureStack.ComputeAdmin.psm1. <br>
Script Below include required modules and provide example path wit images to import:<br>
<a href=https://github.com/aisog/AzureStackTP3Scripts/blob/master/UploadImage.ps1>UploadImage</a><br> 




