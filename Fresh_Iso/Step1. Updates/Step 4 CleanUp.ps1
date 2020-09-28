# Clean Up

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Step 3 - Cleaning up after Updates"

Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

dism /online /Cleanup-Image /StartComponentCleanup
