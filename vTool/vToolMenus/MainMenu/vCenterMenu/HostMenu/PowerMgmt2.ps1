﻿#start of function
function PowerMgmt
{
<#
.SYNOPSIS
    Perform power actions on esxi
.DESCRIPTION
    When we poweroff, shutdown, reboot a host we need to provide a reason to do so. This is especially
    boring and time consuming if you have a lot of hosts on which you have to do this. This is to ease
    that pain. It has 4 options to choose from
     A. Enter Maintenance Mode
     B. Exit Maintenance Mode
     C. Shutdown
     D. Reboot 
    It will ask the reason to perform that action and it will input that reason before it performs the 
    chosen action.
.NOTES
    File Name      : PowerMgmt.ps1
    Author         : gajendra d ambi
    Date           : March 2016
    last update    : April 2017
    Prerequisite   : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware
#>
#Start of script#
Write-Host "
1.Enter Maintenance Mode
2.Exit Maintenance Mode
3.Shutdown (the hosts which are in maintenance mode)
4.Reboot (the hosts which are in maintenance mode)
" -ForegroundColor Blue -BackgroundColor White
$axn     = Read-Host "Type a number from 1 to 4"
$vmhosts = clusterHosts # custom function

$stopWatch = [system.diagnostics.stopwatch]::startNew()
$stopWatch.Start()

if ($axn -eq 1) {$vmhosts | set-vmhost -State Maintenance}
if ($axn -eq 2) {$vmhosts | set-vmhost -State Connected}
if ($axn -eq 3) 
 {Write-Host "enter a reason for this action" -ForegroundColor Yellow
  $reason = Read-Host "what is the reason?"
  foreach ($vmhost in $vmhosts) {
        $esxcli = get-vmhost $vmhost | get-esxcli -v2
        $esxcliset = $esxcli.system.shutdown.poweroff
        $args = $esxcliset.CreateArgs()
        $args.reason = "$reason"
        $esxcliset.Invoke($args) } }
if ($axn -eq 4) 
 {Write-Host "enter a reason for this action" -ForegroundColor Yellow
  $reason = Read-Host "what is the reason?"
  foreach ($vmhost in $vmhosts) {
        $esxcli = get-vmhost $vmhost | get-esxcli -v2
        $esxcliset = $esxcli.system.shutdown.reboot
        $args = $esxcliset.CreateArgs()
        $args.reason = "$reason"
        $esxcliset.Invoke($args) }
 }

$stopWatch.Stop()
Write-Host "Elapsed Runtime:" $stopWatch.Elapsed.Hours "Hours" $stopWatch.Elapsed.Minutes "minutes and" $stopWatch.Elapsed.Seconds "seconds." -BackgroundColor White -ForegroundColor Black
#End of Script#
}#End of function

