$profileDir = Split-Path -parent $profile
$helperDir = Join-Path $profileDir "profile-script-help"
$scriptDir = Join-Path $profileDir "custom-scripts"

New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $helperDir -ItemType Directory -Force -ErrorAction SilentlyContinue
New-Item $scriptDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./profile-script-help/** -Destination $helperDir -Recurse  -Include **
Copy-Item -Path ./custom-scripts/** -Destination $scriptDir -Include **

Remove-Variable profileDir
Remove-Variable helperDir
Remove-Variable scriptDir
