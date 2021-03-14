if (!(get-module pswindowsupdate)) {
    Write-Output "Isntalling PSWindowsUpdate"
    Install-Module PSwindowsUpdate -Force
    Write-Host "Installing Updates"
    Install-WindowsUpdate -AcceptAll -Install -Verbose -AutoReboot
}
else {
    Write-Host "Installing Updates"
    Install-WindowsUpdate -AcceptAll -Install -Verbose -AutoReboot
}
