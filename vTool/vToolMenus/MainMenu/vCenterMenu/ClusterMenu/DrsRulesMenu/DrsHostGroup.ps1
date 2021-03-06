﻿#start of function
Function DrsHostGroup 
{
<#
.SYNOPSIS
    Create DrsHostGroup DRS Rule.
.DESCRIPTION
    This uses custom functions to create DRS DrsHostGroup rules between VMs where VMs will be made to stay on the same host by the DRS.
.NOTES
    File Name      : DrsHostGroup.ps1
    Author         : gajendra d ambi
    Date           : February 2016
    Prerequisite   : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware
#>

#Start of Script
$cluster    = Read-Host "Name of the Cluster?"
$vmhosts    = Read-Host "Type the Name of the host/hosts (separated only by a comma and no spaces)"
$vmhosts    = $vmhosts.split(',')
$hostgroup  = Read-Host "Type the Name of the Hostgroup"

$stopWatch = [system.diagnostics.stopwatch]::startNew()
$stopWatch.Start()

Get-Cluster $cluster | Get-VMHost $vmhosts | New-DrsHostGroup -Name $hostgroup

$stopWatch.Stop()
Write-Host "Elapsed Runtime:" $stopWatch.Elapsed.Hours "Hours" $stopWatch.Elapsed.Minutes "minutes and" $stopWatch.Elapsed.Seconds "seconds." -BackgroundColor White -ForegroundColor Black
#End of Script
}#End of function