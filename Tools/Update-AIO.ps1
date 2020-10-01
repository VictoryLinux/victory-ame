If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

$tweaks = @(
    "Menu",
    "PreRestorepoint",
    "Restart"
    )

Function Menu 
{
    Clear-Host        
    Do
    {
        Clear-Host                                                                       
        Write-Host -Object 'Please choose an option'
        Write-Host     -Object '**********************'
        Write-Host -Object 'Update Options' -ForegroundColor Yellow
        Write-Host     -Object '**********************'
        Write-Host -Object '1.  Install SSU Update'
        Write-Host -Object ''
        Write-Host -Object '2.  Install Cumulative Update'
        Write-Host -Object ''
        Write-Host -Object '3.  Clean Up After Updates'
        Write-Host -Object ''
        Write-Host -Object 'Q.  Quit'
        Write-Host -Object $errout
        $Menu = Read-Host -Prompt '(0-3 or Q to Quit)'
 
        switch ($Menu) 
        {
           1 
            {
                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Downloaded Settings File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {
                            cd C:/Updates/SSU
                            Write-Host "Selected Downloaded Settings File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Import Settings File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import Settings File Cancelled!" -ForegroundColor Yellow} 
    
                # video of Script https://channel9.msdn.com/Series/GuruPowerShell 
                # More scripts from Dan Stolts "ITProGuru" at http://ITProGuru.com/Scripts

                expand -F:* $OpenFileDialog.filename C:\Updates\Cumulative

                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Downloaded SSU Update install File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {    
                            Write-Host "Selected SSU Update install File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "SSU Update install File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import SSU Update install File Cancelled!" -ForegroundColor Yellow} 

                cd C:/Updates/SSU

                dism /online /add-package /packagepath=C:\Updates\wSSU\$OpenFileDialog.filename
                anyKey
            }
            2 
            {
                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select the Cumulative Update install File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {
                            cd C:/Updates/Cumulative
                            Write-Host "Selected Cumulative Update install File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Cumulative Update install File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import Cumulative Update install Cancelled!" -ForegroundColor Yellow} 
    
                # video of Script https://channel9.msdn.com/Series/GuruPowerShell 
                # More scripts from Dan Stolts "ITProGuru" at http://ITProGuru.com/Scripts

                expand -F:* $OpenFileDialog.filename C:\Updates\Cumulative

                $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Downloaded Settings File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {    
                            Write-Host "Selected Downloaded Settings File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Import Settings File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import Settings File Cancelled!" -ForegroundColor Yellow} 
    
                # video of Script https://channel9.msdn.com/Series/GuruPowerShell 
                # More scripts from Dan Stolts "ITProGuru" at http://ITProGuru.com/Scripts

                cd C:/Updates/Cumulative

                dism /online /add-package /packagepath=C:\SSU\$OpenFileDialog.filename
                anyKey
                anyKey
            }
            3 
            {
                Write-Output "Step 3 - Cleaning up after Updates"

                Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

                dism /online /Cleanup-Image /StartComponentCleanup
                anyKey
            }
            Q 
            {
                Exit
            }   
            default
            {
                $errout = 'Invalid option please try again........Try 0-3 or Q only'
            }
 
        }
    }
    until ($Menu -eq 'q')
}   


#Function PreRestorepoint {
#    Write-Host "Creating a System Restore Point... " -NoNewline
#    Enable-ComputerRestore -Drive "C:\"
#    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Type DWord -Value 0
#    Checkpoint-Computer -Description "PreScriptBackup" -RestorePointType "MODIFY_SETTINGS"
#    Write-Host "Complete" -ForegroundColor Green
#}

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
