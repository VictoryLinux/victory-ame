############################################################
####    Author: VictoryLinux                            ####
####                                                    ####    
####    This Script is a personal project. One script   ####    
####    to rule them all. To set up a fresh Windows     ####    
####    install with my personal prefrences.            ####
############################################################

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit

Write-Output "Running Victory Windows Setup Script for Laptops"

Write-Output "DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."


Write-Output "Logging Output"
Start-Transcript -path C:\LenovoSetup\Log.txt -append

### PLACE A # IN FRONT OF THE FUNCTION YOU WANT TO STOP FROM RUNNING ###

$tweaks = @(
    "Restorepoint",
    "SetBIOSTimeUTC",
    "UnpinTaskbarIcons",
    "HideTaskbarSearch",
    "UnpinStartMenuTiles"
    "Update","WaitForKey",
#    "wifi",
    "UpdateInstalledApps",
#    "InstallVictoryProgs",
    "RestartExplorer",
#    "InstallAdobe",
#    "InstallJava",
#    "Install7Zip",
#    "Installwinrar",
#    "InstallVNC",
#    "InstallTeamviewer",
#    "InstallGIMP",
#    "InstallBitwarden",
#    "InstallVirtualbox",
#    "InstallPartitionwizard",
#    "InstallBrave",
#    "InstallChromium",
#    "InstallSublimeText",
#    "InstallVLC",
#    "InstallDiscord",
#    "InstallTwitch",
#    "InstallTukui",
#    "InstallLenovo-thinkvantage-system-update",
#    "WaitForKey",
    "SetUACLow",
    "DisableStickyKeys",
    "EnableNumlock",
    "ShowKnownExtensions",
    "Backgrounds",
    "SetLockscreen",
    "SetWallpaperSlideshow",
#    "RenameUser",
#    "ChangeUserPasswd",
#    "ChangeAdminPasswd",
    "Restart"
#    "Wait",
#    "LaunchSU",
#    "su",
    )


# Set BIOS time to UTC
Function SetBIOSTimeUTC {
    Write-Output "Setting BIOS time to UTC..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
}

Function UnpinTaskbarIcons {
    Write-Output "Unpinning all Taskbar icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue
}

Function HideTaskbarSearch {
    Write-Output "Hiding Taskbar Search icon / box..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    taskkill /IM explorer.exe /F
    explorer.exe
}

Function UnpinStartMenuTiles {
    Write-Output "Unpinning all Start Menu tiles..."
    #Requires -RunAsAdministrator

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

$layoutFile="C:\Windows\StartMenuLayout.xml"

#Delete layout file if it already exists
If(Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}

#Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}

#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
Stop-Process -name explorer
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Stop-Process -name explorer

# Uncomment the next line to make clean start menu default for all new users
Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

Remove-Item $layoutFile
}

# Stop and disable Windows Search indexing service
Function DisableIndexing {
    Write-Output "Stopping and disabling Windows Search indexing service..."
    Stop-Service "WSearch" -WarningAction SilentlyContinue
    Set-Service "WSearch" -StartupType Disabled
}

Function Update {
    Write-Host "Download the latest Updates for your Windows version on a PC with internet access. The Websites are listed below... " -NoNewline
    New-Item -Path "c:\" -Name "Updates" -ItemType "directory"
    New-Item -Path "c:\Updates" -Name "SSU" -ItemType "directory"
    New-Item -Path "c:\Updates" -Name "Cumulative" -ItemType "directory"
#    Write-Host "Place the updates in their coresponding folders in the C:/Updates dir... " -NoNewline
#    Write-Host "Start https://support.microsoft.com/en-us/help/4555932/windows-10-update-history"
#    Write-Host "Start https://www.catalog.update.microsoft.com/Home.aspx"
}

Function Restorepoint {
    Write-Host "Creating a System Restore Point... " -NoNewline
    Enable-ComputerRestore -Drive "C:\"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Type DWord -Value 0
    Checkpoint-Computer -Description "FirstBackup" -RestorePointType "MODIFY_SETTINGS"
    Write-Host "Complete" -ForegroundColor Green
}
	
Function UpdateInstalledApps {
	Write-Output "Updateing Installed Packages... " -NoNewline
	choco upgrade all -y
	Write-Host "Complete" -ForegroundColor Green
}

Function RestartExplorer {
	Write-Output "Restarting Explorer.exe... " -NoNewline
	Start-Process "C:\victory-win\AME_Iso\explorer.bat" -Verb runas
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

Function Installwinrar {
	Write-Output "Installing WinRAR... " -NoNewline
	choco install winrar -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallVNC {
	Write-Output "Installing VNC... " -NoNewline
	choco install vnc-viewer vnc-connect -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallTeamviewer {
	Write-Output "Installing Teamviewer... " -NoNewline
	choco install teamviewer -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallGIMP {
	Write-Output "Installing GIMP... " -NoNewline
	choco install gimp -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallBitwarden {
	Write-Output "Installing Bitwarden... " -NoNewline
	choco install bitwarden -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallVirtualbox {
	Write-Output "Installing Virtualbox... " -NoNewline
	choco install virtualbox -y
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

Function InstallPartitionwizard {
	Write-Output "Installing Partition Wizard... " -NoNewline
	choco install partitionwizard -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallDiscord {
	Write-Output "Installing Discord... " -NoNewline
	choco install discord -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallTwitch {
	Write-Output "Installing Twitch... " -NoNewline
	choco install twitch -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallTukui {
	Write-Output "Installing Tukui... " -NoNewline
	choco install tukui -y
	Write-Host "Complete" -ForegroundColor Green
}

Function InstallLenovo-thinkvantage-system-update {
	Write-Output "Installing Lenovo System Update... " -NoNewline
	choco install lenovo-thinkvantage-system-update -y
	Write-Host "Complete" -ForegroundColor Green
}

Function Backgrounds {
	Write-Output "Setting Up Desktop Wallpaper... " -NoNewline
	Move-Item 'C:\victory-win\Tools\Backgrounds' -Destination 'C:\Users\user\Pictures'
	Write-Host "Complete" -ForegroundColor Green
}

Function SetLockscreen {
	Write-Output "Setting Lockscreen Image... " -NoNewline
	$Lockscreen = "victory35.jpg"
    If (!(Test-Path "C:\Lockscreen")) {
        New-Item -Path "C:\Lockscreen" -type directory -Force | Out-Null
        }
	Copy-Item 'C:\Users\user\Pictures\Backgrounds\victory35.jpg' -Destination 'C:\Lockscreen'
	$strPath3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization -Force
	Set-ItemProperty -Path $strPath3 -Name LockScreenImage -value "C:\Lockscreen\$Lockscreen"
	Write-Host "Complete" -ForegroundColor Green
}

Function SetWallpaperSlideshow {
	Write-Output "Setting Up Wallpaper Slideshow... " -NoNewline
	copy-item 'C:\victory-win\AME_Iso\slideshow.ini' -Destination 'C:\Users\user\AppData\Roaming\Microsoft\Windows\Themes'
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

Function Wait {
    Write-Host "This Script has finished successfully." -BackgroundColor Red
}

# Wait for key press
Function WaitForKey {
    Write-Host "Press any key to restart... " -NoNewline
    [Console]::ReadKey($true) | Out-Null
    Write-Host "Complete" -ForegroundColor Green
}

Function Restart {
	Write-Output "Restarting Windows, to log in as New User... " -NoNewline
	Write-Host "Complete" -ForegroundColor Green
	Start-Sleep -s 15
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
	
	




