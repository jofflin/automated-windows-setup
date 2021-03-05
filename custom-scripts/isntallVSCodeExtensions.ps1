# This script will download the latest version of each extension
# and install it in all supported versions of Visual Studio.
# It might take a few minutes to download and install each extension.

# To Run this Script:
#   Optional: Sign in at https://marketplace.visualstudio.com to avoid being blocked
#   due to Anonymous usage rate limits.
#   Close Visual Studio before running this script.
#   Run in PowerShell as Admin.
#   Example: PS C:\Installers\Visual Studio\VSIX> ./install

# Get more Package Names from the Visual Studio Marketplace URL itemName parameter.
#   Example: https://marketplace.visualstudio.com/items?itemName=TheDan.FindChangesetByComment

$DownloadAndInstall = $PSScriptRoot + "\helper\vsix-helper.ps1"

# !& $DownloadAndInstall -PackageName "Name from Marketplace" query: itemName=XXX
& $DownloadAndInstall -PackageName "TabNine.tabnine-vscode"
& $DownloadAndInstall -PackageName "WallabyJs.quokka-vscode"
& $DownloadAndInstall -PackageName "Angular.ng-template"
& $DownloadAndInstall -PackageName "esbenp.prettier-vscode"
& $DownloadAndInstall -PackageName "eg2.vscode-npm-script"
& $DownloadAndInstall -PackageName "eamodio.gitlens"
& $DownloadAndInstall -PackageName "dsznajder.es7-react-js-snippets"
& $DownloadAndInstall -PackageName "dbaeumer.vscode-eslint"
& $DownloadAndInstall -PackageName "burkeholland.simple-react-snippets"
& $DownloadAndInstall -PackageName "humao.rest-client"
& $DownloadAndInstall -PackageName "ritwickdey.LiveServer"
& $DownloadAndInstall -PackageName "pranaygp.vscode-css-peek"
# & $DownloadAndInstall -PackageName ""

# ? When using settings-sync
# & $DownloadAndInstall -PackageName "Shan.code-settings-sync"