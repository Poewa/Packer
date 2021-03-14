# Runs before Packer provisioners during first boot

# We explicitly install nuget because install-module prompts for confirmation even with -Force
Install-PackageProvider -Name Nuget -Force

# Configure the network to private so we can properly configure WinRM
Install-Module WindowsBox.Network -Force
Set-NetworkToPrivate

wait 30

Install-Module WindowsBox.WinRM -Force
Enable-InsecureWinRM

wait 30
#This might be rendundant
Start-Job -ScriptBlock { C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -ExecutionPolicy Bypass -File a:\winrm.ps1 }
