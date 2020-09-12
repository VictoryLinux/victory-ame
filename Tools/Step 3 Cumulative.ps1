# Cumulative 

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Step 3 - Install Latest Cumulative Update"

cd C:/SSU

dism /online /add-package /packagepath=C:\Cumulative\name_of_the_cumulative.cab