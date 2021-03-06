<#
.SYNOPSIS
    This powercli script should set many of the commonly used syslog settings as per the industry stanards or suggested by VMware.
.DESCRIPTION
    This script uses the old method of calling the advanced setting and setting it. These commands are deprecated. Nonetheless it works.
.NOTES
    File Name      : Syslogger(old).ps1
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

#set the syslog servers
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.hostd.rotate -Value 80 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.hostd.size -Value 10240 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.vmkernel.rotate -Value 80 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.vmkernel.size -Value 10240 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.fdm.rotate -Value 80 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.loggers.vpxa.rotate -Value 20 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.global.defaultRotate -Value 20 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.global.defaultSize -Value 10240 -Confirm:$false
get-vmhost | Set-VmHostAdvancedConfiguration -Name Syslog.global.logHost -Value $Syslogs -Confirm:$false
get-vmhost | Set-VMHostFirewallException -Name "syslog" -enabled:$true
