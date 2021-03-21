function Install-Prereqs {

    if (!(Get-Command choco.exe |Out-Null)) {
        Write-host "Looks like Choco is not installed. Installing now" -ForegroundColor Yellow
        Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
    }
    else {
        Write-Host "Choco is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-Command packer.exe | Out-Null)) {
        Write-host "Looks like Packer is not installed. Installing now" -ForegroundColor Yellow
        choco install packer -y
    }
    else {
        Write-Host "Packer is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-Command python3.exe | Out-Null)) {
        Write-host "Looks like Python3 is not installed. Installing now" -ForegroundColor Yellow
        choco install Python3 -y
    }
    else {
        Write-Host "Python3 is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-item "C:\ISOS" | Out-Null)) {
        Write-Host "C:\ISOS not present. Creating Directory"
        New-Item -ItemType Directory -Path C:\ISOS | Out-Null
        Write-Host "C:\ISOS created, put your ISOS here"
    }
    else {
        Write-Host "C:\ISOS Already present, put your ISOS here" -ForegroundColor Green
    }

    if ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Disabled") {

    
        Write-Host "Installing Hyper-V" -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All  
        Write-Host "Hyper-V has been installed. You need to restart your computer." -ForegroundColor Yellow
    }
    else {
        Write-Host "Hyper-V already installed" -ForegroundColor Green
    }

    Write-Host "All Prereqs have been installed. Run the build.ps1 to get started. You might want to edit the variables files in the packer folder to point to your ISO" -ForegroundColor Green
}
Install-Prereqs







