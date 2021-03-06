<#
.SYNOPSIS
    update NumPorts on vswitchs.
.DESCRIPTION
    this will update the number of ports assigned for a vswitch
.NOTES
    File Name      : fun_NumPorts_vss.ps1
    Author         : gajendra d ambi
    Date           : December 2015
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware   
#>

#Start of script
#start of function
Function fun_NumPorts_vss {
$cluster = Read-Host "name of the cluster(hint:type * to include all cluster)"
$vss     = Read-Host "name of the vswitch(hint:type * to include all vswitchs)"
$ports   = Read-Host "number of ports?"
  foreach ($vmhost in (get-cluster $cluster | get-vmhost))
  {
   get-vmhost | get-virtualswitch -Name $vss | set-virtualswitch -NumPorts $ports -Confirm:$false    
  }
}
#end of function
fun_NumPorts_vss
#End of script
