# SSU 

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Step 2 - Install Latest Servicing Stack Update"

Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

cd C:/Updates/SSU

dism /online /add-package /packagepath=C:\Updates\SSU\name_of_the_ssu.cab
