Write-Host "Sysprepping!"
Start-Process "$ENV:WINDIR\system32\sysprep\sysprep.exe" -ArgumentList "/generalize /shutdown /oobe" -Wait