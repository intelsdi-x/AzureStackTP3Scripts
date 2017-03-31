#Object storage services
$farm = Get-ACSFarm  -ResourceGroupName $resourceGroup
$farm | fl
$farm.Settings | fl
#metrics services
Get-ACSRoleInstance -ResourceGroupName $resourceGroup -FarmName $farm.Name -RoleType MetricsServer

$MetricsServer = Get-ACSRoleInstance -ResourceGroupName $resourceGroup -FarmName $farm.Name -RoleType MetricsServer
$MetricsServer[0]
$MetricsServer[0].Settings

#	Run the following cmdlet to get a list of Blob front-end instances in a specific farm.
Get-ACSRoleInstance -ResourceGroupName $resourceGroup -FarmName $farm.Name -RoleType HealthMonitoringserver

#	Run the following cmdlet to retrieve the properties of a specific Blob Front-end role instance.
$HealthMonitoringserver = Get-ACSRoleInstance -ResourceGroupName $resourceGroup -FarmName $farm.Name -RoleType HealthMonitoringserver
$HealthMonitoringserver[0]
#	Restart Role Instance

Restart-ACSRoleInstance -ResourceGroupName $resourceGroup -FarmName $farm.Name -RoleType HealthMonitoringserver -InstanceID ‘YourInstanceID’
