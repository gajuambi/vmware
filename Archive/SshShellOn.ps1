<#
.SYNOPSIS
    Enable SSH/Shell and suppress warning.
.DESCRIPTION
    1. Enable SSH
    Enable SSH
    2. Enable SSH+SSH Policy ON
    Enable the SSH and turn on the SSH policy to keep the SSH persistently on across reboots.
    3. Disable SSH+SSH Policy OFF
    Disable the SSH and turn off the SSH policy so that SSH will be disabled after reboot.
    4. Enable Shell
    Enable ESXi Shell
    5. Enable Shell+Shell Policy ON
    Enable the ESXi Shell and turn on the ESXi Shell policy to keep the ESXi Shell persistently on across reboots.
    6. Disable Shell+Shell Policy OFF
    Disable the ESXi Shell and turn off the ESXi Shell policy so that ESXi Shell will be disabled after reboot.
    7. Disable SSH/Shell warning
    Disable the warning on esxi hosts about the ssh and shell being enabled.
    Copy the plink.exe to the directory of the script and also to the c drive to avoid any user right conflicts because the script tries to download the
    plink from the internet to the root directory of the script and then copy it to the c drive and run plink.exe from c drive.
.NOTES
    File Name      : SshShellOn.ps1
    Author         : gajendra d ambi
    Date           : Feb 2016
    recommended    : PowerShell v4+, powercli 6+ over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/gajuambi/vmware   
#>
#start of script

#Get Plink
$PlinkLocation = $PSScriptRoot + "\Plink.exe"
If (-not (Test-Path $PlinkLocation)){
#http://www.virtu-al.net/2013/01/07/ssh-powershell-tricks-with-plink-exe/
   Write-Host "Plink.exe not found, trying to download..."
   $WC = new-object net.webclient
   $WC.DownloadFile("http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe",$PlinkLocation)
   If (-not (Test-Path $PlinkLocation)){
      Write-Host "Unable to download plink.exe, please download from the following URL and add it to the same folder as this script: http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe"
      Exit
   } Else {
      $PlinkEXE = Get-ChildItem $PlinkLocation
      If ($PlinkEXE.Length -gt 0) {
         Write-Host "Plink.exe downloaded, continuing script"
      } Else {
         Write-Host "Unable to download plink.exe, please download from the following URL and add it to the same folder as this script: http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe"
         Exit
      }
   }  
}

Write-Host "
1. Enable SSH
2. Enable SSH+SSH Policy ON
3. Disable SSH+SSH Policy OFF
4. Enable Shell
5. Enable Shell+Shell Policy ON
6. Disable Shell+Shell Policy OFF
7. Disable SSH/Shell warning
8. Reenable SSH/Shell warning
" -ForegroundColor Yellow
Write-Host "choose one of the above" -ForegroundColor Yellow
$option  = Read-Host 
$cluster = "*"

if ($option -eq 1) {get-cluster $cluster | get-vmhost | get-vmhostservice | where Key -EQ TSM-SSH | Start-VMHostService}
if ($option -eq 2) {get-cluster $cluster | get-vmhost | Get-VMHostService | where Key -EQ TSM-SSH | Start-VMHostService | Set-VMHostService -Policy On}
if ($option -eq 3) {get-cluster $cluster | get-vmhost | Get-VMHostService | where Key -EQ TSM-SSH | Stop-VMHostService | Set-VMHostService -Policy Off}
if ($option -eq 4) {get-cluster $cluster | get-vmhost | get-vmhostservice | where Key -EQ TSM | Start-VMHostService}
if ($option -eq 5) {get-cluster $cluster | get-vmhost | get-vmhostservice | where Key -EQ TSM | Start-VMHostService | Set-VMHostService -Policy On}
if ($option -eq 6) {get-cluster $cluster | get-vmhost | get-vmhostservice | where Key -EQ TSM | Stop-VMHostService | Set-VMHostService -Policy Off}
if ($option -eq 7) {
#X server's credentials
$user = Read-Host "Host's username?"
$pass = Read-Host "Host's password?"

#copy plink to c:\ for now
Copy-Item $PSScriptRoot\plink.exe C:\

##variables
#put the name of the cluster between quotes (replacing star). Enter multiple cluster names & separate them by a comma (no space in between)
$VMHosts = get-cluster $cluster | Get-VMHost | sort

ForEach ($VMHost in $VMHosts){
#Enable SSH on all hosts
get-cluster $cluster | Get-VMHost $VMHost | Get-VMHostService | where Key -EQ TSM-SSH | Start-VMHostService

echo y | C:\plink.exe -ssh $user@$VMHost -pw $pass "exit"

#Suppress Shell warning
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass 'vim-cmd hostsvc/advopt/update UserVars.SuppressShellWarning long 1'

#do not modify the below line
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass "hostname"

#Disable SSH on all hosts
get-cluster $cluster | Get-VMHost $VMHost | Get-VMHostService | where Key -EQ TSM-SSH | Stop-VMHostService -confirm:$false
}

#delete plink from c:\
Remove-Item C:\plink.exe
}
if ($option -eq 8) {
#X server's credentials
$user = Read-Host "Host's username?"
$pass = Read-Host "Host's password?"

#copy plink to c:\ for now
Copy-Item $PSScriptRoot\plink.exe C:\

##variables
#put the name of the cluster between quotes (replacing star). Enter multiple cluster names & separate them by a comma (no space in between)
$cluster = "*"
$VMHosts = get-cluster $cluster | Get-VMHost | sort

 ForEach ($VMHost in $VMHosts){
 #Enable SSH on all hosts
 get-cluster $cluster | Get-VMHost $VMHost | Get-VMHostService | where Key -EQ TSM-SSH | Start-VMHostService
 
 echo y | C:\plink.exe -ssh $user@$VMHost -pw $pass "exit"
 
 #Suppress Shell warning
 C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass 'vim-cmd hostsvc/advopt/update UserVars.SuppressShellWarning long 0'
 
 #do not modify the below line
 C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass "hostname"
 
 #Disable SSH on all hosts
 get-cluster $cluster | Get-VMHost $VMHost | Get-VMHostService | where Key -EQ TSM-SSH | Stop-VMHostService -confirm:$false
 }

#delete plink from c:\
Remove-Item C:\plink.exe
}

#End of Script
