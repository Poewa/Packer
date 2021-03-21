<#
.SYNOPSIS
    Remove built-in apps (modern apps) from Windows 10.

.DESCRIPTION
    This script will remove all built-in apps with a provisioning package that's not specified in the 'white-list' in this script.
    It supports MDT and ConfigMgr usage, but only for online scenarios, meaning it can't be executed during the WinPE phase.

    For a more detailed list of applications available in each version of Windows 10, refer to the documentation here:
    https://docs.microsoft.com/en-us/windows/application-management/apps-in-windows-10

.EXAMPLE
    .\Invoke-RemoveBuiltinApps.ps1

.NOTES
    FileName:    Invoke-RemoveBuiltinApps.ps1
    Author:      Nickolaj Andersen
    Contact:     @NickolajA
    Created:     2019-03-10
    Updated:     2021-02-02

    Version history:
    1.0.0 - (2019-03-10) Initial script updated with help section and a fix for randomly freezing
    1.1.0 - (2019-05-03) Added support for Windows 10 version 1903 (19H1)
    1.1.1 - (2019-08-13) Removed the part where it was disabling/enabling configuration for Store updates, as it's not needed
    1.1.2 - (2019-10-03) Removed unnecessary left over functions and updated catch statements so that they actually log the current app that could not be removed
    1.2.0 - (2021-02-02) Added support for Windows 10 version 2004 (20H1) and 20H2
#>
Begin {
    # White list of Features On Demand V2 packages
    $WhiteListOnDemand = "NetFX3|DirectX|Tools.DeveloperMode.Core|Language|InternetExplorer|ContactSupport|OneCoreUAP|WindowsMediaPlayer|Hello.Face|Notepad|MSPaint|PowerShell.ISE|ShellComponents"

    # White list of appx packages to keep installed
    $WhiteListedApps = New-Object -TypeName System.Collections.ArrayList
    $WhiteListedApps.AddRange(@(
        "Microsoft.DesktopAppInstaller",
        "Microsoft.Office.OneNote",
        "Microsoft.Messaging", 
        "Microsoft.MSPaint",
        "Microsoft.Windows.Photos",
        "Microsoft.StorePurchaseApp",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCalculator", 
        "Microsoft.WindowsSoundRecorder", 
        "Microsoft.WindowsStore"
    ))

    # Windows 10 version 1809
    $WhiteListedApps.AddRange(@(
        "Microsoft.ScreenSketch",
        "Microsoft.HEIFImageExtension",
        "Microsoft.VP9VideoExtensions",
        "Microsoft.WebMediaExtensions",
        "Microsoft.WebpImageExtension"
    ))

    # Windows 10 version 1903
    # No new apps

    # Windows 10 version 1909
    $WhiteListedApps.AddRange(@(
        "Microsoft.Outlook.DesktopIntegrationServicess"
    ))

    # Windows 10 version 2004
    $WhiteListedApps.AddRange(@(
        "Microsoft.VCLibs.140.00"
    ))

    # Windows 10 version 20H2
    $WhiteListedApps.AddRange(@(
        "Microsoft.MicrosoftEdge.Stable"
    ))
}
Process {
    # Functions
    

    Write-Output "Starting Features on Demand V2 removal process"

    # Get Features On Demand that should be removed
    try {
        $OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

        # Handle cmdlet limitations for older OS builds
        if ($OSBuildNumber -le "16299") {
            $OnDemandFeatures = Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
        }
        else {
            $OnDemandFeatures = Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
        }

        foreach ($Feature in $OnDemandFeatures) {
            try {
                Write-Output "Removing Feature on Demand V2 package: $($Feature)"

                # Handle cmdlet limitations for older OS builds
                if ($OSBuildNumber -le "16299") {
                    Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
                }
                else {
                    Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
                }
            }
            catch [System.Exception] {
                Write-Output "Removing Feature on Demand V2 package failed: $($_.Exception.Message)"
            }
        }    
    }
    catch [System.Exception] {
        Write-Output "Attempting to list Feature on Demand V2 packages failed: $($_.Exception.Message)"
    }

    # Complete
    Write-Output "Completed built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"
}