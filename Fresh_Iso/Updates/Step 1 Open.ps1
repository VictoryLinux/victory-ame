# Unzip

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Step 3 - Decompressing Update Files"

New-Item -Path "C:\" -Name "Updates" -ItemType "directory"

Move-item 'C:\victory-win\Fresh_Iso\Step1. Updates\SSU' -Destination C:\Updates'
Move-item 'C:\victory-win\Fresh_Iso\Step1. Updates\Cumulative' -Destination C:\Updates'

expand -F:* C:\Updates\SSU\name_of_the_ssu_package.msu C:\Updates\SSU

expand -F:* C:\Updates\Cumulative\name_of_the_cumulative_package.msu C:\Updates\Cumulative