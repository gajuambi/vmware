<#
.SYNOPSIS
    add hosts to cluster.
.DESCRIPTION
    This will create distributed portgroup for your DVS
.NOTES
    File Name      : fun_cluster_addhosts.ps1
    Author         : gajendra d ambi
    Date           : January 2016
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware   
#>

#start of script
#start of function
Function fun_cluster_addhosts {
$csv = "$PSScriptRoot/addhosts.csv"
if ($csv -ne $null){Remove-Item $csv -Force}
$csv >> "$PSScriptRoot/addhosts.csv"
$csv = "$PSScriptRoot/addhosts.csv"
$csv | select vmhosts | Export-Csv $csv

Write-Host "update the csv file" -ForegroundColor Yellow
Write-Host "hit ctrl+s to save and click yes" -ForegroundColor Yellow
Write-Host "close the csv only after the script is over" -ForegroundColor Yellow
Read-Host  "hit enter/return to continue"

start-process $csv
Read-Host "Hit Enter/Return to continue"
$csv     = import-csv $csv
$cluster = Read-Host "name of the cluster?:"
$user    = Read-Host "esxi username?:"
$pass    = Read-Host "esxi password?:"
$csv

 foreach ($line in $csv){
 $vmhost   = $($line.vmhosts)
 Add-VMHost $vmhost -Location (Get-Cluster -Name $cluster) -User $user -Password $pass -force -confirm:$false
 }
}
#End of function
fun_cluster_addhosts
#End of script
