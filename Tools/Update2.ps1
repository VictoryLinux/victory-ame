

############################################################
####    Author: VictoryLinux                            ####
####                                                    ####    
####    This Script is a personal project. One script   ####    
####    to Update them all. To set up a fresh Windows   ####    
####    install with my personal prefrences.            ####
############################################################

Start-Transcript -path C:\victory-win\Log.txt -append

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Function Menu 
{
    Clear-Host        
    Do
    {
        Clear-Host                                                                       
        Write-Host -Object 'Please choose an option'
        Write-Host     -Object '**********************'
        Write-Host -Object 'Update Windows 10 AME' -ForegroundColor Yellow
        Write-Host     -Object '**********************'
        Write-Host -Object '1.  Download Update Files '
        Write-Host -Object ''
        Write-Host -Object '2.  Install SSU Update '
        Write-Host -Object ''
        Write-Host -Object '3.  Install Cumulative Update '
        Write-Host -Object ''
        Write-Host -Object '4.  Clean Up After Updates '
        Write-Host -Object ''
        Write-Host -Object '5.  Ameliorate '
        Write-Host -Object ''
        Write-Host -Object '6.  Restart '
        Write-Host -Object ''
        Write-Host -Object 'Q.  Quit'
        Write-Host -Object $errout
        $Menu = Read-Host -Prompt '(0-5 or Q to Quit)'
 
        switch ($Menu) 
        {
           1 
            {
                $dir = "C:\Updates"
                if(!(Test-Path -Path $dir )){
                    New-Item -ItemType directory -Path $dir
                    Write-Host "Updates folder created"
                }
                else
                {
                  Write-Host "Updates Folder already exists"
                }
                $dir = "C:\Updates\SSU"
                if(!(Test-Path -Path $dir )){
                    New-Item -ItemType directory -Path $dir
                    Write-Host "SSU folder created"
                }
                else
                {
                  Write-Host "SSU Folder already exists"
                }
                $dir = "C:\Updates\Cumulative"
                if(!(Test-Path -Path $dir )){
                    New-Item -ItemType directory -Path $dir
                    Write-Host "Cumulative folder created"
                }
                else
                {
                  Write-Host "Cumulative Folder already exists"
                }
                Start-Process "https://support.microsoft.com/en-us/help/4555932/windows-10-update-history"
                Start-Process "https://www.catalog.update.microsoft.com/Home.aspx"            
                Write-Host "Press any key to create a post script restore point and restart... " -NoNewline
            	[Console]::ReadKey($true) | Out-Null
            	Write-Host "Complete" -ForegroundColor Green
            }
            2 
            {
                    cd C:/Updates/SSU 
                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Downloaded SSU File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {
                            Write-Host "Selected Downloaded SSU File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Import SSU File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import SSU File Cancelled!" -ForegroundColor Yellow} 
    
                

                    expand -F:* $OpenFileDialog.filename C:\Updates\SSU

                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select SSU CAB install File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {    
                            Write-Host "Selected SSU CAB install File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "SSU CAB install File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import SSU CAB install File Cancelled!" -ForegroundColor Yellow} 

                cd C:/Updates/SSU

                dism /online /add-package /packagepath=C:\Updates\SSU\$OpenFileDialog.filename
                anyKey
            }
            3 
            {
                cd C:/Updates/Cumulative 
                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Downloaded Cumulative File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {
                            Write-Host "Selected Downloaded Cumulative File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Import Cumulative File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import Cumulative File Cancelled!" -ForegroundColor Yellow} 
    
                

                    expand -F:* $OpenFileDialog.filename C:\Updates\Cumulative

                    $openFileDialog = New-Object windows.forms.openfiledialog   
                    $openFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
                    $openFileDialog.filter = "All files (*.*)| *.*"   
                    $openFileDialog.ShowHelp = $True   
                    Write-Host "Select Cumulative CAB install File... (see FileOpen Dialog)" -ForegroundColor Green  
                    $result = $openFileDialog.ShowDialog()   # Display the Dialog / Wait for user response 
                    # in ISE you may have to alt-tab or minimize ISE to see dialog box 
                    $result 
                    if($result -eq "OK")    {    
                            Write-Host "Selected Cumulative CAB install File:"  -ForegroundColor Green  
                            $OpenFileDialog.filename   
                            # $OpenFileDialog.CheckFileExists 
             
                            # Import-AzurePublishSettingsFile -PublishSettingsFile $openFileDialog.filename  
                            # Unremark the above line if you actually want to perform an import of a publish settings file  
                            Write-Host "Cumulative CAB install File Imported!" -ForegroundColor Green 
                        } 
                        else { Write-Host "Import Cumulative CAB install File Cancelled!" -ForegroundColor Yellow} 

                cd C:/Updates/Cumulative

                dism /online /add-package /packagepath=C:\Updates\Cumulative\$OpenFileDialog.filename
                anyKey
                anyKey
            }
            4 
            {
                Write-Output "Step 3 - Cleaning up after Updates"

                Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

                dism /online /Cleanup-Image /StartComponentCleanup
                anyKey
            }
            5 
            {
                RevertSpecificVMSnapshot
                anyKey
            }
            6 
            {
                Restart-computer
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
 
# Launch The Menu
Menu
Stop-Transcript
