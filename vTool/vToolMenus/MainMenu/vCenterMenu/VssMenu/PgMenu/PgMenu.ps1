#Start of PgMenu
Function PgMenu
{
 do {
 do {         
     Write-Host -BackgroundColor White -ForegroundColor Black "`nVssMenu"
     Write-Host "
     A. Create VM Portgroup
     B. Create VMkernel Portgroup
     C. Rename Portgroup
     D. Update Portgroup's Vlan
     E. Delete VM Portgroup
     F. Delete VMkernel Portgroup  
     G. Sync portgroup with vSwitch(inherit all properties of vswitch to portgroup)
     H. Add TCP/IP stack (vmotion, provisioning etc.)
     I. L3 vMotion gateway (requires hostname resolution)
     J. LoadBalanceIP
     K. LoadBalanceSrcMac
     L. LoadBalanceSrcId
     M. ExplicitFailover 
     " #options to choose from...

     Write-Host "
     X. Previous Menu
     Y. Main Menu
     Z. Exit 
     " -BackgroundColor White -ForegroundColor Black

     $user   = [Environment]::UserName
     $choice = Read-Host "choose one of the above"  # Get user's entry
     $ok     = $choice -match '^[abcdefghijklmxyz]+$'
     if ( -not $ok) { write-host "Invalid selection" -BackgroundColor Red }
    } until ( $ok )
    switch -Regex ($choice) 
    {
     "A" { VssVmPg }
     "B" { VssVmkPg }
     "C" { PgRename }
     "D" { PgVlan }
     "E" { ShootVmPg }
     "F" { ShootVmkPg }
     "G" { PgSync }
     "H" { PgTcpIpStack }
     "I" { L3VmotionGateway }
     "J" { Pglbip }
     "K" { Pglbsm }
     "L" { Pglbsi }
     "M" { Pgef }     
        
     "X" { VssMenu }
     "Y" { MainMenu }      
    }
    } until ( $choice -match "Z" )
} #End of PgMenu