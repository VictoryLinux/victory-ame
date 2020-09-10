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
    "Restorepoint",
    "Uninstall",
    "UpdateInstalledApps",
#    "InstallVictoryProgs",
    "RestartExplorer",
    "InstallAdobe",
    "InstallJava",
    "Install7Zip",
    "InstallBrave",
    "InstallChromium",
    "InstallSublimeText",
    "InstallVLC",
#    "WaitForKey",
    "SetUACLow",
    "DisableStickyKeys",
    "EnableNumlock",
    "ShowKnownExtensions",
#    "RestartExplorer",
    "Backgrounds",
    "RenameUser",
    "ChangeUserPasswd",
    "ChangeAdminPasswd",
    "Restart"
#    "Wait",
#    "LaunchSU",
#    "su",
    )

Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

Function Restorepoint {
    Write-Host "Creating a System Restore Point... " -NoNewline
    Enable-ComputerRestore -Drive "C:\"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Type DWord -Value 0
    Checkpoint-Computer -Description "FirstBackup" -RestorePointType "MODIFY_SETTINGS"
    Write-Host "Complete" -ForegroundColor Green
}

Function Uninstall {
	Write-Output "Uninstalling Thunderbird... " -NoNewline
	choco uninstall thunderbird -y
	Write-Host "Complete" -ForegroundColor Green
}
	
Function UpdateInstalledApps {
	Write-Output "Updateing Installed Packages... " -NoNewline
	choco upgrade all -y
	Write-Host "Complete" -ForegroundColor Green
}

Function RestartExplorer {
	Write-Output "Restarting Explorer.exe... " -NoNewline
	Start-Process "C:\victory-win\\explorer.bat" -Verb runas
	Start-Sleep -s 15
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallVictoryProgs {
	Write-Output "Installing Chocolatey... " -NoNewline
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallAdobe {
	Write-Output "Installing Adobe Acrobat Reader... " -NoNewline
	choco install adobereader -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallJava {
	Write-Output "Installing Java... " -NoNewline
	choco install jre8 -y
	Write-Host "Complete" -ForegroundColor Green
}

Function Install7Zip {
	Write-Output "Installing 7-Zip... " -NoNewline
	choco install 7zip -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallBrave {
	Write-Output "Installing Brave Browser... " -NoNewline
	choco install brave -y
	Copy-Item 'C:\Users\Administrator\Desktop\Brave.lnk' -Destination 'C:\Users\user\Desktop\Brave.lnk'
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallChromium {
	Write-Output "Installing Chromium Browser... " -NoNewline
	choco install chromium -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallFirefox {
	Write-Output "Installing Firefox Browser... " -NoNewline
	choco install firefox -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallSublimeText {
	Write-Output "Installing Sublime Text 3... " -NoNewline
	choco install sublimetext3 -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallVLC {
	Write-Output "Installing VLC Media Player... " -NoNewline
	choco install vlc -y
	Write-Host "Complete" -ForegroundColor Green
}

Function Backgrounds {
	Write-Output "Setting Up Desktop Wallpaper... " -NoNewline
	Copy-Item 'C:\victory-win\Backgrounds' -Destination 'C:\Users\user\Pictures'
	Write-Host "Complete" -ForegroundColor Green
}

Function RenameUser {
	Write-Output "Renaming User Account... " -NoNewline
	Rename-LocalUser -Name "user" -NewName "Nimda"
	Write-Host "Complete" -ForegroundColor Green
}

Function ChangeUserPasswd {
	Write-Output "Changing Local User Account Password... " -NoNewline
	Get-LocalUser
	$Password = Read-Host "Enter the new password" -AsSecureString
	$UserAccount = Get-LocalUser -Name "nimda"
	$UserAccount | Set-LocalUser -Password $Password
	Write-Host "Complete" -ForegroundColor Green
}

Function ChangeAdminPasswd {
	Write-Output "Changing Local Administrator Account Password... " -NoNewline
	Get-LocalUser
	$Password = Read-Host "Enter the new password" -AsSecureString
	$UserAccount = Get-LocalUser -Name "Administrator"
	$UserAccount | Set-LocalUser -Password $Password
	Write-Host "Complete" -ForegroundColor Green
}

Function Restart {
	Write-Output "Restarting Windows, to log in as New User... " -NoNewline
	Write-Host "Complete" -ForegroundColor Green
	Restart-Computer
}

# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
    $preset = Resolve-Path $($args | Select-Object -Skip 1)
    $PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
    $tweaks = $args
    If ($preset) {
        $tweaks = Get-Content $preset -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
    }
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
Stop-Transcript
	
	
