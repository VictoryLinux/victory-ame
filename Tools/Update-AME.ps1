If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
        Exit
    }

Write-Output "Logging Output"
Start-Transcript -path C:\Updates\Log.txt -append

Function Menu 
{
    Clear-Host        
    Do
    {
        Clear-Host                                                                       
        Write-Host -Object 'Please choose an option'
        Write-Host     -Object '**********************'
        Write-Host -Object 'Manual Update Windows 10 AME' -ForegroundColor Yellow
        Write-Host     -Object '**********************'
        Write-Host -Object '1.  Download Updates'
        Write-Host -Object ''
        Write-Host -Object '2.  Install SSU Update'
        Write-Host -Object ''
        Write-Host -Object '3.  Install Cumulative Update'
        Write-Host -Object ''
        Write-Host -Object '4.  Clean Up After Updates'
        Write-Host -Object ''
        Write-Host -Object '5.  Ameliorate'
        Write-Host -Object ''
        Write-Host -Object 'Q.  Quit'
        Write-Host -Object $errout
        $Menu = Read-Host -Prompt '(0-5 or Q to Quit)'
 
        switch ($Menu) 
        {
           1 
            {
                Download            
                AnyKey
            }
            2 
            {
                SSU
                AnyKey
            }
            3 
            {
                Cumulative
                AnyKey
            }
            4 
            {
                Clean
                AnyKey
            }
            5 
            {
                Ameliorate
                AnyKey
            }
            Q 
            {
                Exit
            }   
            default
            {
                $errout = 'Invalid option please try again........Try 0-5 or Q only'
            }
 
        }
    }
    until ($Menu -eq 'q')
}   

Function Download {
	$DIRE = "C:\Updates\SSU"

if ( Test-Path $DIRE ) {
    echo "Directory Exists"
} else {
    Expand-Archive -LiteralPath C:\LenovoSetup\setup.Zip -DestinationPath C:\LenovoSetup
}
	$DIRE = "C:\Updates\Cumulative"

if ( Test-Path $DIRE ) {
    echo "Directory Exists"
} else {
    Expand-Archive -LiteralPath C:\LenovoSetup\setup.Zip -DestinationPath C:\LenovoSetup
}
	Write-Host "Download Latest SSU & Cumulative Updates, save them to C:\Updates\Respective_Folder... " -NoNewline
	Start-Process "https://support.microsoft.com/en-us/help/4555932/windows-10-update-history"
	Start-Process "https://www.catalog.update.microsoft.com/Home.aspx"
}
Function SSU {
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
Function Cumulative {
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
}
Function Clean {
	 Write-Output "Step 3 - Cleaning up after Updates"

         Write-Output "THIS MAY TAKE SEVERAL MINUTES" -BackgroundColor Red

         dism /online /Cleanup-Image /StartComponentCleanup
}
Function Ameliorate {

}

Function AnyKey {
	Write-Host "Press any key to return to the menu... " -NoNewline
	[Console]::ReadKey($true) | Out-Null
	Write-Host "Complete" -ForegroundColor Green
}
 
# Launch The Menu
Menu

Stop-Transcript
