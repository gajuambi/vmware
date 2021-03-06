﻿#Start of function
function CoreDump 
{
<#
.SYNOPSIS
    configure Coredump on esxi hosts
.DESCRIPTION
    This will check the version of the esxi and based on the version of it, it will set the coredump settings on the host
.NOTES
    File Name      : CoreDump.ps1
    Author         : gajendra d ambi
    Date           : January 2016
    Last updae     : August 2017
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware   
#>
#start of the function
$DumpTarget = Read-Host "Type the DumpTarget?:"
$vmk        = Read-Host "Type the vmk number?:"

$stopWatch = [system.diagnostics.stopwatch]::startNew()
$stopWatch.Start()

 foreach ($vmhost in (get-vmhost | sort)) {
 $vmhost.name
        $esxcli = get-vmhost $vmhost | Get-EsxCli -v2
        $esxcliset =$esxcli.system.coredump.network.set
        $args = $esxcliset.CreateArgs()
        $args.interfacename = "$vmk"
        $args.serveripv4 = "$DumpTarget"
        $args.serverport = "6500"        
        $esxcliset.Invoke($args)

        $esxcliset = $esxcli.system.coredump.network.set
        $args = $esxcliset.CreateArgs()
        $args.enable = "true"
        $esxcliset.Invoke($args)  
        $esxcli.system.coredump.network.get.Invoke()      
          }
$stopWatch.Stop()
Write-Host "Elapsed Runtime:" $stopWatch.Elapsed.Hours "Hours" $stopWatch.Elapsed.Minutes "minutes and" $stopWatch.Elapsed.Seconds "seconds." -BackgroundColor White -ForegroundColor Black
}#End of function