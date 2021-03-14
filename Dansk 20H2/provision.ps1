  # Runs after Windows Updates have been applied

  Install-Module WindowsBox.AutoLogon -Force
  Install-Module WindowsBox.Compact -Force
  Install-Module WindowsBox.Explorer -Force
  Install-Module WindowsBox.Hibernation -Force
  Install-Module WindowsBox.VagrantAccount -Force
  Install-Module WindowsBox.VMGuestTools -Force

Write-Output "Configuring Windows Settings"
  Disable-AutoLogon
  Set-ExplorerConfiguration
  Disable-Hibernation




  if ($env:devtools -eq $true) {
    Write-Output "Installing optional software"
    # Install Linux subsystem
    Install-Module WindowsBox.DevMode -Force
    Enable-DevMode

    # Install chocolatey and use it to install dev tools
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

    choco install googlechrome -y
    choco install fiddler4 -y
    choco install sql-server-management-studio -y
    choco install nmap -y
    choco install vscode -y
    choco install wireshark -y
    }



