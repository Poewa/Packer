  #Installing Modules for provisioning
  Write-Output "Installing modules"
  Install-Module WindowsBox.AutoLogon -Force
  Install-Module WindowsBox.Compact -Force
  Install-Module WindowsBox.Hibernation -Force

  #Install Chocolatey
  Write-Host "Installing Chocolatey"
  Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

#Install BoxStarter
  Write-Output "Installing Boxstarter"
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

 
  #Configures common Windows settings
  Write-Output "Configuring Windows Settings"
  Disable-AutoLogon
  Disable-Hibernation
  Enable-UAC
  Disable-BingSearch
  Disable-GameBarTips
  Enable-RemoteDesktop
  Set-WindowsExplorerOptions -EnableShowFileExtensions
  
  #Disable Cortana
  New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' | Out-Null
  New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' | Out-Null

  #Disables IE
  Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online -NoRestart


#Install Office365 with userlocal as language.
choco install microsoft-office-deployment --params="'/Product:O365BusinessRetail /Exclude:Lync'" -y

#Install .NET3.5
choco install dotnet3.5 -y

  #Imports the default startmenu. The file has been placed by packer.
  Write-Output "Installing default startmenu layout"
  Import-StartLayout -LayoutPath "C:\Startmenu.xml" -MountPath "C:\"
  Remove-Item -Path "C:\startmenu.xml" 

  #If packer variable is set to true install these programs.
  if ($env:apps -eq $true) {
    Write-Output "Installing optional software"

    # Install chocolatey and use it to install dev tools
    choco install googlechrome -y
    choco install fiddler4 -y
    choco install sql-server-management-studio -y
    choco install nmap -y
    choco install vscode -y
    choco install wireshark -y
    }



