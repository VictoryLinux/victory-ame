# Cumulative 

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Step 3 - Install Latest Cumulative Update"

Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

cd C:/Updates/Cumulative

dism /online /add-package /packagepath=C:\Updates\Cumulative\name_of_the_cumulative.cab
