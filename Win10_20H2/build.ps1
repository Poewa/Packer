#
write-host "Warning this script will kill all python processes when done" -ForegroundColor Red
write-host "The script will also build up http servers over time if not allowed to finish. You can kill them with get-process python | kill-process" -ForegroundColor Red


#Defines ISO location
$WorkingDirectory = "C:\ISOS"

#Starting simple http server for ISO transfer.
write-host "Starting http server on port 8080" -ForegroundColor Green
Start-Process python -WorkingDirectory $WorkingDirectory -ArgumentList "-m http.server 8080" -WindowStyle Hidden
Start-Sleep 3

#Starting the build process
Write-Host "starting packer" -ForegroundColor Green
start-process packer -ArgumentList "build -var-file windows10/variables.json windows10/packer.json" -NoNewWindow -Wait

#killing ALL python processes
Write-Host "Killing Python process to stop http server" -ForegroundColor Green
Get-Process python | Stop-Process

#set the VHD mount folder
#$Mount="c:\mount"
#create a folder c:\mount
#Mkdir $Mount
#New-Item -ItemType Directory -Path $Mount
#mount the c:\temp\spiderip.vhd to $Mount folder

#Mount-WindowsImage -ImagePath "c:\temp\spiderip.vhd" -Path "$Mount" -Index 1
#Create new Wim image to c:\temp\spiderip.wim folder

#New-WindowsImage -CapturePath "$Mount" -Name "spiderip image" -ImagePath "c:\temp\spiderip.wim" -Description "spiderip image" -Verify
#dismount  the $Mount folder
#Dismount-WindowsImage -Path "$Mount" -Discard