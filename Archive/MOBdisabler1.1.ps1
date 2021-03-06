<#
.SYNOPSIS
    Disable mob on esxi hosts.

.DESCRIPTION
    It will create a shell script on the host and then delete that script from the host once the script is run.
    Add the line below to the kickstart file when you are doing an automated install of ESXi hosts.
    vim-cmd proxysvc/remove_service "/mob" "httpsWithRedirect"
    Using alan's script from http://www.virtu-al.net/2013/01/07/ssh-powershell-tricks-with-plink-exe/ to get/use the plink.
    JUst right click and run the script (from powershell) or drag and drop it on powercli.
    vSphere 6 comes with this service disabled so no need to run this.It gives you the status of mob before and after
    you run this.

.NOTES
    File Name      : MOBdisabler.ps1
    Author         : gajendra d ambi
    Prerequisite   : PowerShell V3, powercli 5.x over Vista and upper.
    Copyright      - None
    
.LINK
    Script posted over:
    http://ambitech.blogspot.in/2015/06/disable-mob-security-hardening-for.html
#>


$PlinkLocation = $PSScriptRoot + "\Plink.exe"
If (-not (Test-Path $PlinkLocation)){
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


#If using in powershell then add snapins below
Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue

#Connect to the vcenter server
connect-viserver

#Display the status of MOB on all hosts
get-vmhost | get-advancedsetting Config.HostAgent.plugins.solo.enableMob | Select-Object Entity, @{Expression="Value";Label="MOb Enabled"} | ft

#copy plink to c:\ for now
Copy-Item $PSScriptRoot\plink.exe C:\

#Variables
$pass = Read-Host "Type the esxi password"
$user = Read-Host "Type the esxi username which is usually root"
$VMHosts = Get-VMHost

#you may # out the above line and use the below line instead of you wan to apply this for a cluster
#$VMHosts = Get-Cluster "Cluster_Name" | Get-VMHost | Sort Name

##create a shell script on the esxi host
#create a text file on the host with the script
$cmd0 = "echo 'vim-cmd proxysvc/remove_service */mob* *httpsWithRedirect*' >> /tmp/mob.txt"
$cmd1 = "sed -i 's/*/\""/g' /tmp/mob.txt"
#convert the text to a shell script by just renaming
$rename = "mv /tmp/mob.txt /tmp/mob.sh"
#make the shell script executibel
$chmod = "chmod +x /tmp/mob.sh"
#run the mob shell script
$mob = "/tmp/mob.sh"
#remove the shell script
$clean = "rm -rf /tmp/mob.sh"

#Enable SSH on all hosts
Get-VMHost | Get-VMHostService | where {$_.Key -eq "TSM-SSH"} | Start-VMHostService

ForEach ($VMHost in $VMHosts)
{
echo y | C:\plink.exe -ssh $user@$VMHost -pw $pass "exit"
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $cmd0
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $cmd1
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $rename
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $chmod
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $mob
C:\plink.exe -ssh -v -noagent $VMHost -l $user -pw $pass $clean
}

#Display the status of MOB on all hosts
get-vmhost | get-advancedsetting Config.HostAgent.plugins.solo.enableMob | Select-Object Entity, @{Expression="Value";Label="MOb Enabled"} | ft

#Disable SSH on all hosts
Get-VMHost | Get-VMHostService | where {$_.Key -eq "TSM-SSH"} | Stop-VMHostService -confirm:$false

#delete plink from c:\
Remove-Item C:\plink.exe

#End Of Script
