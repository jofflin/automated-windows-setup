# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);

    exit
}


### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

$programs = @(
    # system and cli
    "curl"                          
    "git.install -params '/GitAndUnixToolsOnPath /NoShellIntegration'"
    "nodejs-lts"                    
    "yarn"                          
    "notepadplusplus"               
    "putty.install"                 
    "jre8"                          
    "python"                        
    "tortoisegit"                   
    "gitkraken"
    "azure-cli" 
    "microsoft-windows-terminal"    
  
    #fonts
    "sourcecodepro"                 
  
    # browsers
    "GoogleChrome"                  
    "GoogleChrome.Canary"           
    "Firefox"                       
    "Opera"                         
  
    # dev tools and frameworks
    "Fiddler"                       
    "vim"                           
    "vscode"                        
    "webstorm"                      
    "insomnia-rest-api-client"      
    "figma"                         
    "filezilla"                     
    "postman"                       
  
    # gaming
    "discord"                       
    "teamspeak"                     
    "epicgameslauncher"             
    "steam"                         
  
    # casual
    "7zip"                          
    "icloud"                        
    "itunes"                        
    "spotify"                       
    "vlc"                           
    "teamviewer"                    
    "thunderbird"                   
    "lastpass"                      
)

foreach ($program in $programs) {
    Write-Output "Trying to install $app"
    choco install $app --limit-output
}

Refresh-Environment


### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"
# IIS Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "IIS-BasicAuthentication", `
    "IIS-DefaultDocument", `
    "IIS-DirectoryBrowsing", `
    "IIS-HttpCompressionDynamic", `
    "IIS-HttpCompressionStatic", `
    "IIS-HttpErrors", `
    "IIS-HttpLogging", `
    "IIS-ISAPIExtensions", `
    "IIS-ISAPIFilter", `
    "IIS-ManagementConsole", `
    "IIS-RequestFiltering", `
    "IIS-StaticContent", `
    "IIS-WebSockets" `
    -NoRestart | Out-Null

# ASP.NET Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "NetFx3", `
    "NetFx4-AdvSrvs", `
    "NetFx4Extended-ASPNET45", `
    "IIS-NetFxExtensibility", `
    "IIS-NetFxExtensibility45", `
    "IIS-ASPNET", `
    "IIS-ASPNET45" `
    -NoRestart | Out-Null

# Web Platform Installer for remaining Windows features
webpicmd /Install /AcceptEula /Products:"UrlRewrite2"

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm update npm
    # npm install -g gulp
    # npm install -g mocha
    # npm install -g node-inspector
    # npm install -g yo
    npm install -g @vue/cli
    npm install -g typescript
    npm install -g @angular/cli
}

### Janus for vim
# Write-Host "Installing Janus..." -ForegroundColor "Yellow"
# if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
#     curl.exe -L https://bit.ly/janus-bootstrap | bash
# }

