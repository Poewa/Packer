# Runs before Packer provisioners during first boot

# We explicitly install nuget because install-module prompts for confirmation even with -Force
Install-PackageProvider -Name Nuget -Force

# Configure the network to private so we can properly configure WinRM
Install-Module WindowsBox.Network -Force
Set-NetworkToPrivate


wait 45

#Enables insecure WinRM. This is being undone in the cleanup.ps1 script.
netsh advfirewall firewall set rule group="remote administration" new enable=yes
netsh advfirewall firewall add rule name="Open Port 5985" dir=in action=allow protocol=TCP localport=5985

winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="7200000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
winrm set winrm/config/winrs '@{MaxProcessesPerShell="0"}'
winrm set winrm/config/winrs '@{MaxShellsPerUser="0"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

net stop winrm
sc.exe config winrm start= auto
net start winrm

