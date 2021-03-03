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

# system and cli
choco install curl                          --limit-output
choco install nuget.commandline             --limit-output
choco install webpi                         --limit-output
choco install git.install                   --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install nodejs-lts                    --limit-output
choco install yarn                          --limit-output
choco install notepadplusplus               --limit-output
choco install putty.install                 --limit-output
choco install jre8                          --limit-output
choco install dotnetcore-sdk                --limit-output
choco install dotnetcore-windowshosting     --limit-output
choco install python                        --limit-output
choco install tortoisegit                   --limit-output
choco install gitkraken                     --limit-output

#fonts
choco install sourcecodepro                 --limit-output

# browsers
choco install GoogleChrome                  --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome        --limit-output
choco install GoogleChrome.Canary           --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome.Canary --limit-output
choco install Firefox                       --limit-output; <# pin; evergreen #> choco pin add --name Firefox             --limit-output
choco install Opera                         --limit-output; <# pin; evergreen #> choco pin add --name Opera               --limit-output

# dev tools and frameworks
choco install Fiddler                       --limit-output
choco install vim                           --limit-output
choco install vscode                        --limit-output
choco install webstorm                      --limit-output
choco install insomnia-rest-api-client      --limit-output
choco install figma                         --limit-output
choco install filezilla                     --limit-output
choco install azure-cli                     --limit-output
choco install postman                       --limit-output

# gaming
choco install discord                       --limit-output
choco install teamspeak                     --limit-output
choco install epicgameslauncher             --limit-output
choco install steam                         --limit-output

# casual
choco install 7zip                          --limit-output
choco install icloud                        --limit-output
choco install itunes                        --limit-output
choco install spotify                       --limit-output
choco install vlc                           --limit-output
choco install teamviewer                    --limit-output
choco install thunderbird                   --limit-output
choco install lastpass                      --limit-output





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
    npm install -g gulp
    npm install -g mocha
    npm install -g node-inspector
    npm install -g yo
    npm install -g @angular/cli
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash
}

