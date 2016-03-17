﻿
#start of function
Function Pgef 
{
<#
.SYNOPSIS
    update virtual machine portgroup's loadbalancing to ExplicitFailover on vSwitch.
.DESCRIPTION
    This will update virtual machine portgroup's loadbalancing to ExplicitFailover on a chosen standard portgroup of hosts of a chosen cluster.    
.NOTES
    File Name      : Pgef.ps1
    Author         : gajendra d ambi
    Date           : March 2016
    Prerequisite   : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware
#>
#Start of Script
$cluster = Read-Host "name of the cluster[type * to include all clusters]?"
$pg      = Read-Host "Name of the portgroup?"
Get-cluster $cluster | Get-VMHost | Get-VirtualPortGroup -Name $pg | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy ExplicitFailover -Confirm:$false
#End of Script
}#End of function

