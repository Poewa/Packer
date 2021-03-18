#Removing Boxstarter

# Remove the Chocolatey packages in a specific order!
'Boxstarter.Azure', 'Boxstarter.TestRunner', 'Boxstarter.WindowsUpdate', 'Boxstarter',
    'Boxstarter.HyperV', 'Boxstarter.Chocolatey', 'Boxstarter.Bootstrapper', 'Boxstarter.WinConfig', 'BoxStarter.Common' |
    ForEach-Object { choco uninstall $_ -y }

# Remove the Boxstarter data folder
Remove-Item -Path (Join-Path -Path $env:ProgramData -ChildPath 'Boxstarter') -Recurse -Force

# Remove Boxstarter from the path in both the current session and the system
$env:PATH = ($env:PATH -split ';' | Where-Object { $_ -notlike '*Boxstarter*' }) -join ';'
[Environment]::SetEnvironmentVariable('PATH', $env:PATH, 'Machine')

# Remove Boxstarter from the PSModulePath in both the current session and the system
$env:PSModulePath = ($env:PSModulePath -split ';' | Where-Object { $_ -notlike '*Boxstarter*' }) -join ';'
[Environment]::SetEnvironmentVariable('PSModulePath', $env:PSModulePath, 'Machine')

#Remove-Item -Path "C:\ProgramData\Boxstarter" -Recurse -Force
#Remove-Item -Path "C:\Users\Public\Desktop\Boxstarter Shell.lnk" -Force
#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Boxstarter" -Recurse -Force

Uninstall-Module WindowsBox.AutoLogon -Force
Uninstall-Module WindowsBox.Compact -Force
Uninstall-Module WindowsBox.Hibernation -Force
Uninstall-Module WindowsBox.Network -Force

#Makes sure WinRM is in a secure state and ready for reconfiguration
choco install undo-winrmconfig-during-shutdown -y