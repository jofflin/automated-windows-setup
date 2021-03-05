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

$DownloadAndInstall = $PSScriptRoot + "\install-vsix.ps1"

# !& $DownloadAndInstall -PackageName "Name from Marketplace" query: itemName=XXX
& $DownloadAndInstall -PackageName "SergeyVlasov.VisualCommander"
& $DownloadAndInstall -PackageName "MBulli.SmartCommandlineArguments"
& $DownloadAndInstall -PackageName "mayerwin.RenameVisualStudioWindowTitle"
& $DownloadAndInstall -PackageName "VisualCppDevLabs.CQuickFixes2017"
& $DownloadAndInstall -PackageName "TomasRestrepo.Viasfora"
& $DownloadAndInstall -PackageName "MadsKristensen.MarkdownEditor"
& $DownloadAndInstall -PackageName "PeterMacej.MultilineSearchandReplace"
& $DownloadAndInstall -PackageName "GitHub.GitHubExtensionforVisualStudio"
& $DownloadAndInstall -PackageName "TheDan.FindChangesetByComment"
& $DownloadAndInstall -PackageName "caphyon.ClangPowerTools"