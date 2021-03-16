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

  ##HAS NO EFFECT##
  #Removes en-US Keyborad from keyboard layouts. I have no clue why it's there.
  #$List = Get-WinUserLanguageList
  #$List.Remove("en-US")
  #Set-WinUserLanguageList $List -Force


  if ($env:devtools -eq $true) {
    Write-Output "Installing optional software"
    # Install Linux subsystem
    Install-Module WindowsBox.DevMode -Force
    Enable-DevMode

    # Install chocolatey and use it to install dev tools
    choco install googlechrome -y
    choco install fiddler4 -y
    choco install sql-server-management-studio -y
    choco install nmap -y
    choco install vscode -y
    choco install wireshark -y
    }



