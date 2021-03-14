function Install-Prereqs {
Write-Host "!!NOTICE!!If you don't have Hyper-V installed this won't work. Please install Hyper-V it is not a part of this installation script!!NOTICE!!" -ForegroundColor Red

    if (!(Get-Command choco.exe)) {
        Write-host "Looks like Choco is not installed. Installing now" -ForegroundColor Yellow
        Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
    }
    else {
        Write-Host "Choco is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-Command packer.exe)) {
        Write-host "Looks like Packer is not installed. Installing now" -ForegroundColor Yellow
        choco install packer -y
    }
    else {
        Write-Host "Packer is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-Command python3.exe)) {
        Write-host "Looks like Python3 is not installed. Installing now" -ForegroundColor Yellow
        choco install Python3 -y
    }
    else {
        Write-Host "Python3 is already installed. Continueing" -ForegroundColor Green
    }
    if (!(Get-item "C:\ISOS")) {
        Write-Host "C:\ISOS not present. Creating Directory"
        New-Item -ItemType Directory -Path C:\ISOS | Out-Null
        Write-Host "C:\ISOS created, put your ISOS here"
    }
    else {
        Write-Host "C:\ISOS Already present, put your ISOS here" -ForegroundColor Green
    }
Write-Host "All Prereqs have been installed. Run the build.ps1 to get started. You might want to edit the variables files in the packer folder to point to your ISO" -ForegroundColor Green
}
Install-Prereqs







