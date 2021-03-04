# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);

    exit
}

###############################################################################
### Security and Identity                                                     #
###############################################################################
Write-Host "Configuring System..." -ForegroundColor "Yellow"

# Set Computer Name
(Get-WmiObject Win32_ComputerSystem).Rename("R2D2") | Out-Null

## Set DisplayName for my account. Use only if you are not using a Microsoft Account
# $myIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
# $user = Get-WmiObject Win32_UserAccount | Where-Object { $_.Caption -eq $myIdentity.Name }
# $user.FullName = "Jonas Hoefflin"
# $user.Put() | Out-Null
# Remove-Variable user
# Remove-Variable myIdentity

# Enable Developer Mode
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 1
# Bash on Windows
#Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

###############################################################################
### Privacy                                                                   #
###############################################################################
Write-Host "Configuring Privacy..." -ForegroundColor "Yellow"

# General: Don't let apps use advertising ID for experiences across apps: Allow: 1, Disallow: 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
Remove-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Id" -ErrorAction SilentlyContinue

# General: Disable Application launch tracking: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start-TrackProgs" 0

# General: Disable SmartScreen Filter: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 0

# General: Disable key logging & transmission to Microsoft: Enable: 1, Disable: 0
# Disabled when Telemetry is set to Basic
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

# General: Opt-out from websites from accessing language list: Opt-in: 0, Opt-out 1
Set-ItemProperty "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1

# General: Disable SmartGlass: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "UserAuthPolicy" 0

# General: Disable SmartGlass over BlueTooth: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "BluetoothPolicy" 0

# General: Disable suggested content in settings app: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338394Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338396Enabled" 0

# Camera: Don't let apps use camera: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" "Value" "Deny"

# Microphone: Don't let apps use microphone: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" "Value" "Deny"

# Notifications: Don't let apps access notifications: Allow, Deny
# Build 1903
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny"

# Speech, Inking, & Typing: Stop "Getting to know me"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# Account Info: Don't let apps access name, picture, and other account info: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# Contacts: Don't let apps access contacts: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"

# Calendar: Don't let apps access calendar: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" "Value" "Deny"

# Call History: Don't let apps make phone calls: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"

# Call History: Don't let apps access call history: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny"

# Diagnostics: Don't let apps access diagnostics of other apps: Allow, Deny
# Build 1903
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"

# Documents: Don't let apps access documents: Allow, Deny
# Build 1903
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

# Email: Don't let apps read and send email: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"

# File System: Don't let apps access the file system: Allow, Deny
# Build 1903
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"

# Location: Don't let apps access the location: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"

# Messaging: Don't let apps read or send messages (text or MMS): Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny"

# Pictures: Don't let apps access pictures: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

# Radios: Don't let apps control radios (like Bluetooth): Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"

# Tasks: Don't let apps access the tasks: Allow, Deny
# Build 1903
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"

# Other Devices: Don't let apps share and sync with non-explicitly-paired wireless devices over uPnP: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"

# Videos: Don't let apps access videos: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

# Feedback: Windows should never ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null }
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# Feedback: Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1

# Start Menu: Disable suggested content: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0

###############################################################################
### Devices, Power, and Startup                                               #
###############################################################################
Write-Host "Configuring Devices, Power, and Startup..." -ForegroundColor "Yellow"

# Sound: Disable Startup Sound
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1

# Power: Disable Hibernation
powercfg /hibernate off

# Power: Set standby delay to 24 hours
powercfg /change /standby-timeout-ac 1440

# SSD: Disable SuperFetch
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0

# Network: Disable WiFi Sense
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" "AutoConnectAllowedOEM" 0

###############################################################################
### Explorer, Taskbar, and System Tray                                        #
###############################################################################
Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null }
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null }

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: Show file extensions by default
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: Show path in title bar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# Explorer: Avoid creating Thumbs.db files on network volumes
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Taskbar: Enable small icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# Taskbar: Don't show Windows Store Apps on Taskbar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "StoreAppsOnTaskbar" 0

# Taskbar: Disable Bing Search
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ConnectedSearch" "ConnectedSearchUseWeb" 0 # For Windows 8.1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0 # For Windows 10

# Taskbar: Disable Cortana
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0

# SysTray: Hide the Action Center, Network, and Volume icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAHealth" 1  # Action Center
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCANetwork" 1 # Network
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAVolume" 1  # Volume
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAPower" 1  # Power

# Taskbar: Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 1

# Titlebar: Disable theme colors on titlebar
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\DWM" "ColorPrevalence" 0

# Recycle Bin: Disable Delete Confirmation Dialog
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0

# Sync Settings: Disable automatically syncing settings with other Windows 10 devices
# Theme
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" "Enabled" 0
# Passwords
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" "Enabled" 0
# Language
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" "Enabled" 0
# Accessibility / Ease of Access
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" "Enabled" 0
# Other Windows Settings
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" "Enabled" 0

###############################################################################
### Default Windows Applications                                              #
###############################################################################
Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

#   Description:
# This script removes unwanted Apps that come with Windows. If you  do not want
# to remove certain Apps comment out the corresponding lines below.

Write-Output "Elevating privileges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output "Uninstalling default apps"
$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    #"Microsoft.FreshPaint"
    "Microsoft.GamingServices"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    #"Microsoft.WindowsStore"   # can't be re-installed
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"
    #"Microsoft.MSPaint"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    "Microsoft.ScreenSketch"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"

    # non-Microsoft
    "*.PicsArt-PhotoStudio"
    "*.EclipseManager"
    "*.Netflix"
    "*.PolarrPhotoEditorAcademicEdition"
    "*.Wunderlist"
    "*.LinkedInforWindows"
    "*.AutodeskSketchBook"
    "*.Twitter"
    "*.DisneyMagicKingdoms"
    "*.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "*.Plex"  
    "ClearChannelRadioDigital.iHeartRadio"
    "*.FarmVille2CountryEscape"
    "*.Duolingo-LearnLanguagesforFree"
    "*.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "*.Facebook"
    "*.FitbitCoach"
    "*.Flipboard"
    "*.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "NORDCURRENT.COOKINGFEVER"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "*.SpotifyMusic"
    #"TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    "flaregamesGmbH.RoyalRevolt2"
    "king.com.*"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "*Dropbox*"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"

    # apps which other apps depend on
    "Microsoft.Advertising.Xaml"
)

foreach ($app in $apps) {
    Write-Output "Trying to remove $app"

    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers

    Get-AppXProvisionedPackage -Online |
    Where-Object DisplayName -EQ $app |
    Remove-AppxProvisionedPackage -Online
}

# Prevents Apps from re-installing
$cdm = @(
    "ContentDeliveryAllowed"
    "FeatureManagementEnabled"
    "OemPreInstalledAppsEnabled"
    "PreInstalledAppsEnabled"
    "PreInstalledAppsEverEnabled"
    "SilentInstalledAppsEnabled"
    "SubscribedContent-314559Enabled"
    "SubscribedContent-338387Enabled"
    "SubscribedContent-338388Enabled"
    "SubscribedContent-338389Enabled"
    "SubscribedContent-338393Enabled"
    "SubscribedContentEnabled"
    "SystemPaneSuggestionsEnabled"
)

if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager")) { New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Type Folder | Out-Null }
foreach ($key in $cdm) {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" $key 0
}

if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Type Folder | Out-Null }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" "AutoDownload" 2

# Prevent "Suggested Applications" from returning
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Type Folder | Out-Null }
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1


###############################################################################
### Lock Screen                                                               #
###############################################################################

## Enable Custom Background on the Login / Lock Screen
## Background file: C:\someDirectory\someImage.jpg
## File Size Limit: 256Kb
# Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Personalization" "LockScreenImage" "C:\someDirectory\someImage.jpg"

###############################################################################
### Accessibility and Ease of Use                                             #
###############################################################################
Write-Host "Configuring Accessibility..." -ForegroundColor "Yellow"

# Turn Off Windows Narrator
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null }
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"

# Disable "Window Snap" Automatic Window Arrangement
# Set-ItemProperty "HKCU:\Control Panel\Desktop" "WindowArrangementActive" 0

# Disable automatic fill to space on Window Snap
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapFill" 0

# Disable showing what can be snapped next to a window
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

# Disable automatic resize of adjacent windows on snap
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "JointResize" 0

# Disable auto-correct
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "EnableAutocorrection" 0

###############################################################################
### Windows Update & Application Updates                                      #
###############################################################################
Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Type Folder | Out-Null }

# Enable Automatic Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

# Disable automatic reboot after install
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1

# Opt-In to Microsoft Update
$MU = New-Object -ComObject Microsoft.Update.ServiceManager -Strict
$MU.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
Remove-Variable MU

# Delivery Optimization: Download from 0: Http Only [Disable], 1: Peering on LAN, 2: Peering on AD / Domain, 3: Peering on Internet, 99: No peering, 100: Bypass & use BITS
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization")) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null }
if (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization")) { New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null }
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
Set-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0

###############################################################################
### Windows Defender                                                          #
###############################################################################
Write-Host "Configuring Windows Defender..." -ForegroundColor "Yellow"

# Disable Cloud-Based Protection: Enabled Advanced: 2, Enabled Basic: 1, Disabled: 0
# ConfigDefender\Set-MpPreference -MAPSReporting Disabled

# Disable automatic sample submission: Prompt: 0, Auto Send Safe: 1, Never: 2, Auto Send All: 3
# ConfigDefender\Set-MpPreference -SubmitSamplesConsent NeverSend

###############################################################################
### Internet Explorer                                                         #
###############################################################################
Write-Host "Configuring Internet Explorer..." -ForegroundColor "Yellow"

# Set home page to `about:blank` for faster loading
Set-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank"

# Disable 'Default Browser' check: "yes" or "no"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" "Check_Associations" "no"

# Disable Password Caching [Disable Remember Password]
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "DisablePasswordCaching" 1


###############################################################################
### Disk Cleanup (CleanMgr.exe)                                               #
###############################################################################
Write-Host "Configuring Disk Cleanup..." -ForegroundColor "Yellow"

$diskCleanupRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"

# Cleanup Files by Group: 0=Disabled, 2=Enabled
Set-ItemProperty $(Join-Path $diskCleanupRegPath "BranchCache"                                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Downloaded Program Files"                     ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Internet Cache Files"                         ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Offline Pages Files"                          ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Old ChkDsk Files"                             ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Previous Installations"                       ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Recycle Bin"                                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "RetailDemo Offline Content"                   ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Service Pack Cleanup"                         ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Setup Log Files"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error memory dump files"               ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error minidump files"                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Files"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Setup Files"                        ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Thumbnail Cache"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Update Cleanup"                               ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Upgrade Discarded Files"                      ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "User file versions"                           ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Defender"                             ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Archive Files"        ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Queue Files"          ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Archive Files" ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Queue Files"   ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Temp Files"           ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows ESD installation files"               ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Upgrade Log Files"                    ) "StateFlags6174" 0   -ErrorAction SilentlyContinue

Remove-Variable diskCleanupRegPath

###############################################################################
### PowerShell Console                                                        #
###############################################################################
Write-Host "Configuring Console..." -ForegroundColor "Yellow"

# Make 'Source Code Pro' an available Console font
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' 000 'Source Code Pro'

@(`
        "HKCU:\Console\%SystemRoot%_System32_bash.exe", `
        "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe", `
        "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe", `
        "HKCU:\Console\Windows PowerShell (x86)", `
        "HKCU:\Console\Windows PowerShell", `
        "HKCU:\Console"`
) | ForEach {
    If (!(Test-Path $_)) {
        New-Item -path $_ -ItemType Folder | Out-Null
    }

    # Dimensions of window, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
    Set-ItemProperty $_ "WindowSize"           0x002D0078 # 45h x 120w
    # Dimensions of screen buffer in memory, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
    Set-ItemProperty $_ "ScreenBufferSize"     0x0BB80078 # 3000h x 120w
    # Percentage of Character Space for Cursor: 25: Small, 50: Medium, 100: Large
    Set-ItemProperty $_ "CursorSize"           100
    # Name of display font
    Set-ItemProperty $_ "FaceName"             "Source Code Pro"
    # Font Family: Raster: 0, TrueType: 54
    Set-ItemProperty $_ "FontFamily"           54
    # Dimensions of font character in pixels, not Points: 8-byte; 4b height, 4b width. 0: Auto
    Set-ItemProperty $_ "FontSize"             0x00110000 # 17px height x auto width
    # Boldness of font: Raster=(Normal: 0, Bold: 1), TrueType=(100-900, Normal: 400)
    Set-ItemProperty $_ "FontWeight"           400
    # Number of commands in history buffer
    Set-ItemProperty $_ "HistoryBufferSize"    50
    # Discard duplicate commands
    Set-ItemProperty $_ "HistoryNoDup"         1
    # Typing Mode: Overtype: 0, Insert: 1
    Set-ItemProperty $_ "InsertMode"           1
    # Enable Copy/Paste using Mouse
    Set-ItemProperty $_ "QuickEdit"            1
    # Background and Foreground Colors for Window: 2-byte; 1b background, 1b foreground; Color: 0-F
    Set-ItemProperty $_ "ScreenColors"         0x0F
    # Background and Foreground Colors for Popup Window: 2-byte; 1b background, 1b foreground; Color: 0-F
    Set-ItemProperty $_ "PopupColors"          0xF0
    # Adjust opacity between 30% and 100%: 0x4C to 0xFF -or- 76 to 255
    Set-ItemProperty $_ "WindowAlpha"          0xF2

    # The 16 colors in the Console color well (Persisted values are in BGR).
    # Theme: Jellybeans
    Set-ItemProperty $_ "ColorTable00"         $(Convert-ConsoleColor "#151515") # Black (0)
    Set-ItemProperty $_ "ColorTable01"         $(Convert-ConsoleColor "#8197bf") # DarkBlue (1)
    Set-ItemProperty $_ "ColorTable02"         $(Convert-ConsoleColor "#437019") # DarkGreen (2)
    Set-ItemProperty $_ "ColorTable03"         $(Convert-ConsoleColor "#556779") # DarkCyan (3)
    Set-ItemProperty $_ "ColorTable04"         $(Convert-ConsoleColor "#902020") # DarkRed (4)
    Set-ItemProperty $_ "ColorTable05"         $(Convert-ConsoleColor "#540063") # DarkMagenta (5)
    Set-ItemProperty $_ "ColorTable06"         $(Convert-ConsoleColor "#dad085") # DarkYellow (6)
    Set-ItemProperty $_ "ColorTable07"         $(Convert-ConsoleColor "#888888") # Gray (7)
    Set-ItemProperty $_ "ColorTable08"         $(Convert-ConsoleColor "#606060") # DarkGray (8)
    Set-ItemProperty $_ "ColorTable09"         $(Convert-ConsoleColor "#7697d6") # Blue (9)
    Set-ItemProperty $_ "ColorTable10"         $(Convert-ConsoleColor "#99ad6a") # Green (A)
    Set-ItemProperty $_ "ColorTable11"         $(Convert-ConsoleColor "#c6b6ee") # Cyan (B)
    Set-ItemProperty $_ "ColorTable12"         $(Convert-ConsoleColor "#cf6a4c") # Red (C)
    Set-ItemProperty $_ "ColorTable13"         $(Convert-ConsoleColor "#f0a0c0") # Magenta (D)
    Set-ItemProperty $_ "ColorTable14"         $(Convert-ConsoleColor "#fad07a") # Yellow (E)
    Set-ItemProperty $_ "ColorTable15"         $(Convert-ConsoleColor "#e8e8d3") # White (F)
}

# Customizing PoSh syntax
# Theme: Jellybeans
Set-PSReadlineOption -Colors @{
    "Default"   = "#e8e8d3"
    "Comment"   = "#888888"
    "Keyword"   = "#8197bf"
    "String"    = "#99ad6a"
    "Operator"  = "#c6b6ee"
    "Variable"  = "#c6b6ee"
    "Command"   = "#8197bf"
    "Parameter" = "#e8e8d3"
    "Type"      = "#fad07a"
    "Number"    = "#cf6a4c"
    "Member"    = "#fad07a"
    "Emphasis"  = "#f0a0c0"
    "Error"     = "#902020"
}


# Remove property overrides from PowerShell and Bash shortcuts
# Reset-AllPowerShellShortcuts
# Reset-AllBashShortcuts

echo "Done. Note that some of these changes require a logout/restart to take effect. You may also want to look in your MS Store and Programs to delete remaining unwanted Software, especially Company-specific (HP, Dell,...)!"



shutdown /t 120 /r /c "Reboot required to finish installing WSL2"
$cancelReboot = Read-Host 'Cancel reboot for now (you still need to reboot and rerun to finish installing WSL2; For "N" it will Reboot in 120s) [y/N]'
if ($cancelReboot.Length -ne 0) {
    if ($cancelReboot.Substring(0, 1).ToLower() -eq 'y') {
        shutdown /a
    }
}