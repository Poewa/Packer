#Removing Boxstarter

Remove-Item -Path "C:\ProgramData\Boxstarter" -Recurse -Force
Remove-Item -Path "C:\Users\Public\Desktop\Boxstarter Shell.lnk" -Force
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Boxstarter" -Recurse -Force

Uninstall-Module WindowsBox.AutoLogon -Force
Uninstall-Module WindowsBox.Compact -Force
Uninstall-Module WindowsBox.Hibernation -Force
