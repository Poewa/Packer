
#Defines Variables
###########################
$WorkingDirectory = "C:\ISOS"
$ImagePath = "F:\Packer\Win10_20H2\output-hyperv-iso\Virtual Hard Disks\21H2 DK.vhdx"
$ImageOutput = "C:\tmp\Win10_21H2_DA.wim"
$MountPath = "C:\mount"
$packerArgument = "build -var-file F:\Packer\Win10_20H2\windows10\Variables_dk.json F:\Packer\Win10_20H2\windows10\packer.json"
$convertToWIM = $false
$port = "8080"
$wimName = "Win10_21H2_DA"
###########################

write-host "Warning this script will kill all python processes when done" -ForegroundColor Red
write-host "The script will also build up http servers over time if not allowed to finish. You can kill them with get-process python | kill-process" -ForegroundColor Red

#Starting simple http server for ISO transfer.
write-host "Starting http server on port $port" -ForegroundColor Green
Start-Process python -WorkingDirectory $WorkingDirectory -ArgumentList "-m http.server $port" -WindowStyle Hidden
Start-Sleep 3

#Starting the build process
Write-Host "starting packer" -ForegroundColor Green
start-process packer -ArgumentList $packerArgument -NoNewWindow -Wait

#killing ALL python processes
Write-Host "Killing Python process to stop http server" -ForegroundColor Green
Get-Process python | Stop-Process

if ($convertToWIM -eq $true) {
    
    #create a folder c:\mount
    if (Get-Item "$MountPath") {
        Write-Host "Mount directory already present" -ForegroundColor Green
    }
    else {
        New-Item -ItemType Directory -Path $MountPath
    }
    Write-Host "Mounting VHDX" -ForegroundColor Green
    Mount-WindowsImage -ImagePath "$ImagePath"  -Path "$MountPath" -Index 1
    Write-Host "Creating WIM file. This might take awhile" -ForegroundColor Green
    New-WindowsImage -CapturePath "$MountPath" -Name $wimName -ImagePath "$ImageOutput" -Verbose
    #dismount  the $Mount folder
    Write-Host "Dismounting VHDX" -ForegroundColor Green
    Dismount-WindowsImage -Path "$MountPath" -Discard
}