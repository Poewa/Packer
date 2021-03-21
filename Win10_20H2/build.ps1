[CmdletBinding()]
param (
    [Parameter()]
    [Boolean]
    $convertToWIM = $false 
)
#
write-host "Warning this script will kill all python processes when done" -ForegroundColor Red
write-host "The script will also build up http servers over time if not allowed to finish. You can kill them with get-process python | kill-process" -ForegroundColor Red


#Defines Variables
###########################
$WorkingDirectory = "C:\ISOS"
$ImagePath = "C:\Packer\Win10_20H2\output-hyperv-iso\Virtual Hard Disks\20H2 Golden Dansk.vhdx"
$ImageOutput = "C:\temp\Win10_20H2_DA.wim"
$MountPath = "C:\mount"
$packerArgument = "build -var-file windows10/variables_English.json windows10/packer_English.json"
###########################



#Starting simple http server for ISO transfer.
write-host "Starting http server on port 8080" -ForegroundColor Green
Start-Process python -WorkingDirectory $WorkingDirectory -ArgumentList "-m http.server 8080" -WindowStyle Hidden
Start-Sleep 3

#Starting the build process
Write-Host "starting packer" -ForegroundColor Green
start-process packer -ArgumentList $packerArgument -NoNewWindow -Wait

#killing ALL python processes
Write-Host "Killing Python process to stop http server" -ForegroundColor Green
Get-Process python | Stop-Process

if ($convertToWIM = $true) {
    
    #create a folder c:\mount
    if (Get-Item "$MountPath") {
        Write-Host "Mount directory already present"
    }
    else {
        New-Item -ItemType Directory -Path $MountPath
    }



    #mount the c:\temp\spiderip.vhd to $Mount folder
    Mount-WindowsImage -ImagePath "$ImagePath"  -Path "$MountPath" -Index 1


    #Create new Wim image to c:\temp\spiderip.wim folder
    New-WindowsImage -CapturePath "$MountPath" -Name "Win10_20H2_DA" -ImagePath "$ImageOutput" -Description "Windows 10 image med dansk sprog" -Verbose
    #dismount  the $Mount folder
    Dismount-WindowsImage -Path "$MountPath" -Discard
}