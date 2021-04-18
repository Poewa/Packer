Write-Host "Sysprepping!"
Start-Process "$ENV:WINDIR\system32\sysprep\sysprep.exe" -ArgumentList "/generalize /quit /oobe" -Wait