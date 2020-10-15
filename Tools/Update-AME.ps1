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
                anyKey
            }
            2 
            {
                SSU
                anyKey
            }
            3 
            {
                Cumulative
                anyKey
            }
            4 
            {
                Clean
                anyKey
            }
            5 
            {
                Ameliorate
                anyKey
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
	
}
Function Clean {
	
}
Function Ameliorate {

}
 
# Launch The Menu
Menu

Stop-Transcript
