param ($type = "all")

$file = Get-Content "../program-list.txt"

# Get the list of apps corresponding to the type mentioned in the txt-file
function Get-List {
  param($apps, $file)

  $regex = "Apps::$([regex]::escape($apps))(.*?)Apps::$([regex]::escape($apps))"
  $list = [regex]::match($file, $regex) -split " "
  $list = $list.Where( { $_.Length })
  $list = $list.Where( { $_ -notmatch "^Apps::.*$" })
  return $list
}

# Get the list
$appsToInstall = Get-List $type $file


# If list is empty, get all apps
if ([string]::IsNullOrWhiteSpace($appsToInstall) -eq $true) {
  $appsToInstall = Get-List "all" $file
}

# Check if choco is installed, if not install it
if ([string]::IsNullOrWhiteSpace($appsToInstall) -eq $false) {
  try {
    choco config get cacheLocation
  }
  catch {
    Write-Output "Chocolatey not detected, trying to install now"
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
}

# Install every app
if ([string]::IsNullOrWhiteSpace($appsToInstall) -eq $false) {   
  Write-Host "Chocolatey Apps Specified"  
    
  foreach ($app in $appsToInstall) {

    Write-Host "Installing $app"
    # & choco install $app /y | Write-Output
  }
}
else {
  Write-Host "Empty"
}
