# These components will be loaded for all PowerShell instances

Push-Location (Join-Path (Split-Path -parent $profile) "profile-script-help/specific-scripts")

# From within the ./components directory...
. .\coreaudio.ps1
. .\git.ps1
. .\functions.ps1
. .\aliases.ps1
. .\exports.ps1
. .\extra.ps1

Pop-Location
