if (!(get-module pswindowsupdate)) {
    Write-Output "Installing PSWindowsUpdate"
    Install-Module PSwindowsUpdate -Force
    Write-Host "Installing Updates"
    Install-WindowsUpdate -AcceptAll -Install -Verbose -AutoReboot
}
else {
    Write-Host "Installing Updates"
    Install-WindowsUpdate -AcceptAll -Install -Verbose -AutoReboot
}
