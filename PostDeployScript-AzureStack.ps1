#requires -Version 5
<#

        .NOTES  

        File Name  	: PostDeployScript-AzureStack.ps1
        Version		: 0.9
        Author     	: Ruud Borst - ruud@ruudborst.nl
        Requires   	: PowerShell V5+

        .LINK  

        https://azurestack.blog/2017/01/azure-stack-post-deployment-script
        
        .LINK  

        https://gallery.technet.microsoft.com/Azure-Stack-Post-a8fc1fd5
	
        .SYNOPSIS

        This post-deployment script clears up space and improves the performance of your Azure Stack enviroment. 

        .DESCRIPTION
        
        This script cleans up winrm, tracing and diagnostic logfiles and disables the services and scheduled tasks generating them. 
        Not clearing the WinRM log files is a well-known bug in TP2 and can fill up the available space in increments of 4GB per day on the Host and on every fabric VM. 
        The script also disables 'Windows Update' (downloads), the 'Error Reporting service' (dumps) and disables 'Windows Defender'. 
        Saving up space and gaining more performance on the host and its VMs, in particular, on the the MAS-XRP01. 'IE Enhanced Security' and 'User Account Control'
        are also by default disabled on the Host and on the MAS-CON01, all for your management convenience. 
        And it fixes, if necessary, the MAS-BGPNAT Windows activation bug and the default domain password policy bug so you can use the Azure Stack environment 
        without being locked-out.  See: 
        
        https://social.msdn.microsoft.com/Forums/azure/en-US/home?forum=AzureStack&announcementId=f35560ea-b0d2-4be0-b407-e20fe631d9fe
        https://docs.microsoft.com/en-us/azure/azure-stack/azure-stack-run-powershell-script#reset-the-password-expiration-to-180-days

        .PARAMETER CheckLogsOnly
         Specify if you want to check the WinRM and diagnostic log files and their total size.

        .PARAMETER SkipDisablingDefender
         Specify if you dont want to disable Windows Defender realtime monitoring.

        .PARAMETER SKipDisablingUAC
         Specify the SKipDisablingUAC switch parameter if you don't want to disable User Account Control on MAS-CON01 and the Host.

        .EXAMPLE 
         .\PostDeployScript-AzureStack.ps1
        .EXAMPLE 
         .\PostDeployScript-AzureStack.ps1 -CheckLogsOnly

#>
[CmdletBinding()]
Param(
    [Parameter(HelpMessage = 'Specify if you only want to check the WinRM and diagnostic log files and their total size.')] 
    [switch]$CheckLogsOnly
)

# 
# Prerequisites check

$WindowsIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()

if ($WindowsIdentity.name -ne 'AZURESTACK\AzureStackAdmin'){
      Write-error -Message "`nScript is running under $($WindowsIdentity.name) , please execute with 'AZURESTACK\AzureStackAdmin'." 
      break
} # end if AzureStackAdmin check

if (!([Security.Principal.WindowsPrincipal] $WindowsIdentity).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) 
{
 Write-error -Message "`nThis session is running under non-admin priviliges.`nPlease restart with Admin priviliges (runas Administrator)." 
 break
} # end if admin check

$Netadapter = Get-NetAdapter Deployment -ea 0
if (!$Netadapter){
      Write-error -Message "`nPlease run this script on the Azure Stack host with the external 'Deployment' network adapter active." 
      break
} # end if AzureStackAdmin check

$MASHost = $env:computername
$SessionOption = New-PSSessionOption -NoCompression -MaxConnectionRetryCount 1  -OpenTimeout 2000 -OperationTimeout 8000
$VersionXMLPath = '\\su1fileserver\SU1_ManagementLibrary_1\CloudMedia\Configuration\Version\Version.xml'
$LogDirs = 'C:\winrm\logs','c:\cpiservices\diagnostics','c:\crpservices\diagnostics','c:\frpservices\diagnostics'

# Detecting Azure Stack version 
[xml]$ASVersioninfo = Get-Content $VersionXMLPath -ea 0
$ASver = ($ASVersioninfo.Version) -replace "`n",''

if (!$ASver){
    Write-Error "No Azure Stack deployment version detected at '$VersionXMLPath'."
    break
} elseif ($ASver -ne '1.0.1104.1') {
    Write-error "You are running Azure Stack version $ASver. This script is tested and compatible with Azure Stack TP2 Refresh version 1.0.1104.1."
    write-error 'Please download an updated script on TechNet or reach out to me at ruud@ruudborst.nl if your version is greater then 1.0.1104 and there is no updated version available.' 
    break
} # end if version check

if (!$CheckLogsOnly){
    Write-Warning "This script disables tracing, logging and dumps for WinRM (logfile build up bug) and several other services like 'NetTrace, NrpTracing, FrpTraceCollector','CRPTraceCollector','CPITraceCollector'. Halt the script when you actively work with Microsoft with this deployment or if you plan to troubleshoot these services later on." -debug
} #end if CheckLogsOnly

#
# Begin script

# Retrieves all fabric VMs plus host, need elevated priviliges
$CompArr = (get-vm | where notes -notmatch '[a-z]').Name + $MASHost

# Check logfile sizes on all VM's if parameter CheckLogsOnly is specified
if ($CheckLogsOnly){

  $LogsOutput = Invoke-Command -ea continue -SessionOption $SessionOption -ArgumentList $LogDirs -computername $CompArr {
    $computername = $env:computername 
    $Logs = gci $Args -Recurse -ea 0 | select fullname,@{n='MB';e={[math]::round(($_.length /1mb))}} 
      if ($Logs){
        $Logs
      } else {
        Write-host "[$computername]`t No logs found."
      } # end if Logs
  } # end invoke-command

  $LogsOutput | sort mb | ft pscomputername,mb,fullname 
  [String]$TotalLogs = [string]($LogsOutput.mb | Measure-Object -Sum).sum + ' MB'
  Write-host "Total used logspace: " -NoNewline; write-host "$TotalLogs" -ForegroundColor Red 

} else { 

    
  # Executes the invoke-command in parallel

  Invoke-Command -ea continue -SessionOption $SessionOption -ArgumentList $MASHost,$LogDirs,$SkipDisablingDefender,$SKipDisablingUAC -computername $CompArr  {

        $computername = $env:computername
        $MasHost,$Logdirs = $args[0],$args[1]

        write-host "[$computername]`tCleaning Up logfiles and stop logging."

        # Stop logging
        cd c:\winrm
        .\stop-logging.ps1

        # Disables the Azure Stack WinRm debug logging task at system startup mainly responsible for the logfile build up
        get-scheduledtask WinRmDebugLogging -ea 0 | Disable-ScheduledTask -ea 0 | out-null

	    if ($computername -eq 'mas-xrp01'){
            write-host "[$computername]`tClearing diag folders and stopping tracing services. (performance/space)"
            $XRPTraceServices =  get-service 'FrpTraceCollector','CRPTraceCollector','CPITraceCollector'
            $XRPTraceServices | stop-service -NoWait
            $XRPTraceServices | set-service -StartupType Disabled
            get-scheduledtask StartNrpTracing | Disable-ScheduledTask -ea 0 | out-null

	    } # end if mas-xrp01

        # Remove all logfiles, some can remain because they are in use by system, 
        # rerun after mas-xrp01 is rebooted to clear them up.
       $logdirs | rd -Force -Recurse -Confirm:$false -ea 0

        # Disable IE Enhanced Security, User Account Control on MAS-CON01 and the Host.
        if ($computername -eq 'mas-con01'){
            # Disable IE Hardening
            write-host "[$computername]`tDisabling IE Enhanced Security"
            $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
            Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
            if (!$SKipDisablingUAC){
            write-host "[$computername]`tDisabling User Account Control"
            New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force | out-null
            } # end if SKipDisablingUAC
         } # end if mas-con01,host

        if ($computername  -eq $Mashost){
         $logscriptexists= test-path c:\winrm\start-loggingren.ps1
              if (!$logscriptexists){
              ren .\Start-Logging.ps1 -NewName start-loggingren.ps1 -ea 0 | out-null
               "sleep 10 `n ## renamed to start-loggingren.ps1 by the post-deployment script, see https://gallery.technet.microsoft.com/Azure-Stack-Post-a8fc1fd5" | out-file c:\winrm\start-logging.ps1
              }
         } # end if

    }  # end invoke-command

    if ((Get-ADDefaultDomainPasswordPolicy).maxpasswordage.days -eq 42){
    Set-ADDefaultDomainPasswordPolicy -MaxPasswordAge 180.00:00:00 -Identity azurestack.local 
    write-host "[$MASHost] Updated Password Policy to 180 days instead of the incorrect 42 days preventing MAS lockout." -ForegroundColor DarkYellow
    } # end if maxpasswordage


   # Checking NAT MAS-BGPNAT01 OS activation bug
   Invoke-Command -SessionOption $SessionOption -computername MAS-BGPNAT01 {

    $NetNatName = "BGPNAT"
    $SLProduct = Get-WmiObject -ClassName SoftwareLicensingProduct | where ApplicationId -EQ 55c92734-d682-4d71-983e-d6ec3f16059f | where PartialProductKey
    $NetNatEA = Get-NetNatExternalAddress -NatName $NetNatName  | ? { $_.portstart -eq 1024 -and $_.externaladdressid -eq 0}
    if ($NetNatEA) {$Ipconfig = (get-netipaddress $NetNatEA.ipaddress -ea 0).PrefixOrigin}
    
    if ($NetNatEA -and $Activation.licensestatus -ne 1 -and $Ipconfig -eq 'manual'){
        write-host "[MAS-BGPNAT01]`tFound NAT activation bug on MAS-BGPNAT01. Fixing NAT ..." -ForegroundColor DarkYellow
        try {
            $IPAddress = $NetNatEA.IPAddress
            $ExternalAddressID = $NetNatEA.ExternalAddressID
            $IPAddressConfig = Get-NetIPAddress -IPAddress $IPAddress
            $InterfaceAlias = $IPAddressConfig.InterfaceAlias
            $PrefixLength = $IPAddressConfig.PrefixLength
            Remove-NetNatExternalAddress -ExternalAddressID $ExternalAddressID -Confirm:$false  | out-null
            New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $PrefixLength | out-null
            Add-NetNatExternalAddress -NatName $NetNatName -IPAddress $IPAddress -PortStart 4096 -PortEnd 49151 | out-null
            write-host "[MAS-BGPNAT01]`tTrying to activate Windows .." -ForegroundColor DarkYellow
            sleep 10
            $SLProduct.activate() | out-null
            write-host "[MAS-BGPNAT01]`tActivated Windows and fixed NAT bug on MAS-BGPNAT01." -ForegroundColor DarkYellow
        } catch {
            write-warning '[MAS-BGPNAT01]`tActivation unsuccessful, please try to fix it manually. See https://social.msdn.microsoft.com/Forums/azure/en-US/home?forum=AzureStack&announcementId=f35560ea-b0d2-4be0-b407-e20fe631d9fe'
        } # end try/catch
    } # end if netnaea/activation

  } # end invoke BGPNAT01

$VerbosePreference = 'Continue'
write-host ''
write-verbose "Finished. Reboot the Host or the VM's to clear the remaining 'MAS-*.network.etl'logs."
Write-verbose "Check with '-CheckLogsOnly' if there are any logs left, script can be executed multiple times."
write-Warning 'Dont forget to change the 15 days storage account retention period in the portal. See : https://docs.microsoft.com/en-us/azure/azure-stack/azure-stack-manage-storage-accounts#set-retention-period'
} # end if checklogs

