Get-AzureRmResourceGroupDeployment -ResourceGroupName TestResource1
Test-AzureRmResourceGroupDeployment -ResourceGroupName TestResource1 -TemplateFile https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-two-vm-extensions/azuredeploy.json
New-AzureRmResourceGroupDeployment -ResourceGroupName TestResource1 -TemplateFile https://raw.githubusercontent.com/Azure/AzureStack-QuickStart-Templates/master/101-two-vm-extensions/azuredeploy.json -vmName Win2012Data
