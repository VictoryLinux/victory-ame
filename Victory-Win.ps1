############################################################
####    Author: VictoryLinux                          ####
####                                                    ####    
####    This Script is a personal project. One script   ####    
####    to rule them all. To set up a fresh Windows     ####    
####    install with my personal prefrences.            ####
############################################################

Write-Output "Running Victory Windows Setup Script for Laptops"

Write-Output "DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."


Write-Output "Logging Output"
Start-Transcript -path C:\LenovoSetup\Log.txt -append

$tweaks = @(
    "RequireAdmin",
#    "wifi",
#    "Unzip",
    "Restorepoint",
#    "InstallVictoryProgs",
    "InstallAdobe",
    "InstallJava",
    "Install7Zip",
    "InstallBrave",
    "InstallChromium",
    "InstallSublimeText",
    "InstallVLC",
#	"WaitForKey",
    "SetUACLow",
#    "EnableSMB1",
    "DisableStickyKeys",
    "EnableNumlock",
#    "UpgradeEdge",
    "ShowKnownExtensions",
#    "Patchmypc",
#    "RestartExplorer",
    "RenameUser",
    "ChangeUserPasswd",
    "ChangeAdminPasswd",
    "Wait",
#    "LaunchSU",
    "su",
    )

Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

Function Uninstall {
	Write-Output "Uninstalling Thunderbird"
	choco uninstall thunderbird -y
}
	

Function InstallVictoryProgs {
	Write-Output "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
}

Function InstallAdobe {
	Write-Output "Installing Adobe Acrobat Reader"
	choco install adobereader -y
}

Function InstallJava {
	Write-Output "Installing Java"
	choco install jre8 -y
}

Function Install7Zip {
	Write-Output "Installing 7-Zip"
	choco install 7zip -y
}

Function InstallBrave {
	Write-Output "Installing Brave Browser"
	choco install brave -y
}

Function InstallChromium {
	Write-Output "Installing Chromium Browser"
	choco install chromium -y
}

Function InstallFirefox {
    Write-Output "Installing Firefox Browser"
    choco install firefox -y
}

Function InstallSublimeText {
	Write-Output "Installing Sublime Text 3"
	choco install notepadplusplus -y
}

Function InstallVLC {
	Write-Output "Installing VLC Media Player"
	choco install vlc -y
}

Function {
	Rename-LocalUser -Name "User" -NewName "Nimda"
}

Function {
	Get-LocalUser
	$Password = Read-Host "Enter the new password" -AsSecureString
	$UserAccount = Get-LocalUser -Name "nimda"
	$UserAccount | Set-LocalUser -Password $Password
	
	
	
