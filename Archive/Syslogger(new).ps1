
<#
.SYNOPSIS
    This powercli script should set many of the commonly used syslog settings as per the industry stanards or suggested by VMware.
.DESCRIPTION
    This script uses the newer cmdlts of powercli to call the advanced settings and set it.
.NOTES
    File Name      : Syslogger(new).ps1
    Author         : gajendra d ambi
    Prerequisite   : PowerShell V3, Powercli 5.5+ over Vista and upper.
    Copyright     - None
.LINK
    Script posted over:
    ambitech.blogspot.in/2015/04/set-multiple-syslog-servers-on-multiple.html?
#>

#connect to vcenter
connect-viserver

$Syslogs = "1.1.1.1,2.2.2.2"

get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.hostd.rotate | Set-AdvancedSetting -Value 80 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.hostd.size | Set-AdvancedSetting -Value 10240 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.vmkernel.rotate | Set-AdvancedSetting -Value 80 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.vmkernel.size | Set-AdvancedSetting -Value 10240 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.fdm.rotate | Set-AdvancedSetting -Value 80 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.loggers.vpxa.rotate | Set-AdvancedSetting -Value 20 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.global.defaultRotate | Set-AdvancedSetting -Value 20 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.global.defaultSize | Set-AdvancedSetting -Value 10240 -Confirm:$false
get-vmhost | Get-AdvancedSetting -Name Syslog.global.logHost | Set-AdvancedSetting -Value $Syslogs -Confirm:$false
get-vmhost | Get-VMHostFirewallException -Name "syslog" | Set-VMHostFirewallException -enabled:$true
