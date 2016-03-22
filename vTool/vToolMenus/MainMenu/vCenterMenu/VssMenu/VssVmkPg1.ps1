﻿
#start of function
Function VssVmkPg1 
{
<#
.SYNOPSIS
    update vmkernel portgroup on vSwitch.
.DESCRIPTION
    This will update vmkernel portgroup on a chosen standard vSwitch of hosts of a chosen cluster.    
.NOTES
    File Name      : VssVmkPg1.ps1
    Author         : gajendra d ambi
    Date           : March 2016
    Prerequisite   : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware
#>
#Start of Script
 Write-Host "
A CSV file will be opened (open in excel/spreadsheet)
populate the values,
save & close the file,
Hit Enter to proceed
" -ForegroundColor Blue -BackgroundColor White
$csv = "$PSScriptRoot/VssVmPg1.csv"
get-process | Select-Object VMHost,vSwitch,Portgroup,vmk,IpV4Address,SubnetMask,vlan | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"

$csv = Import-Csv $csv
 foreach ($line in $csv) 
 {
  $vmhost = $($line.VMHost)
  $vss    = $($line.vSwitch)
  $pg     = $($line.Portgroup)
  $vmk    = $($line.vmk)
  $ip     = $($line.IpV4Address)
  $mask   = $($line.SubnetMask)
  $vlan   = $($line.vlan)
  Get-VMHost $vmhost | Get-VirtualSwitch -Name $vss | New-VirtualPortGroup -Name $pg -VLanId $vlan -Confirm:$false
  $esxcli = get-vmhost $vmhost | Get-EsxCli
  $esxcli.network.ip.interface.add($null, $null, "$vmk", $null, "1500", $null, "$pg")
  $esxcli.network.ip.interface.ipv4.set("$vmk", "$ip", "$mask", $null, "static")
 }#End of Script
}#End of function