<#
.SYNOPSIS
    update nicteamingpolicy on vswitchs.
.DESCRIPTION
    this will update the number of ports assigned for a vswitch
    LoadBalanceIP - Route based on IP hash. Choose an uplink based on a hash of the source and destination IP addresses of each packet. For non-IP packets, whatever is at those offsets is used to compute the hash.
    LoadBalanceLoadBased - Route based on Nic load.
    LoadBalanceSrcMac - Route based on source MAC hash. Choose an uplink based on a hash of the source Ethernet.
    LoadBalanceSrcId - Route based on the originating port ID. Choose an uplink based on the virtual port where the traffic entered the virtual switch.
    ExplicitFailover - Always use the highest order uplink from the list of Active adapters that passes failover detection criteria.
.NOTES
    File Name      : fun_loadbalance_vss.ps1
    Author         : gajendra d ambi
    Date           : January 2016
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware   
#>

#Start of script

Function fun_loadbalance_vss {
Write-Host 
 "1 - LoadBalanceIP
  2 - LoadBalanceLoadBased
  3 - LoadBalanceSrcMac
  4 - LoadBalanceSrcId
  5 - ExplicitFailover"

$option  = Read-Host "type one of the above option:"
$cluster = Read-Host "name of the cluster(hint:type * to include all cluster):"
$vss     = Read-Host "name of the vswitch(hint:type * to include all vswitchs):"

  foreach ($vmhost in (get-cluster $cluster | get-vmhost)) {
   if ($option -eq '1') {get-vmhost $vmhost | get-virtualswitch -Name $vss | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceIP        -Confirm:$false}
   if ($option -eq '2') {get-vmhost $vmhost | get-virtualswitch -Name $vss | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased -Confirm:$false}
   if ($option -eq '3') {get-vmhost $vmhost | get-virtualswitch -Name $vss | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceSrcMac    -Confirm:$false}
   if ($option -eq '4') {get-vmhost $vmhost | get-virtualswitch -Name $vss | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceSrcId     -Confirm:$false}
   if ($option -eq '5') {get-vmhost $vmhost | get-virtualswitch -Name $vss | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy ExplicitFailover     -Confirm:$false}
  }
}
fun_loadbalance_vss
#End of script
