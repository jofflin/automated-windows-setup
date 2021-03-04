
$confirmation = Read-Host "This will change your Taskbar and Start-Menu Layout. For changes edit the layoutModification.xml in this directory $PSScriptRoot (Do you agree?) [y/N]"
if ($confirmation.Length -ne 0) {
  if ($confirmation.Substring(0, 1).ToLower() -eq 'y') {
    $destination = $home + "\AppData\Local\Microsoft\Windows\Shell"#
    $source = $PSScriptRoot + "\LayoutModification.xml"

    Copy-Item $source -Destination $destination

    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache"

    Remove-Item $path -Force -Recurse

    Stop-Process -ProcessName explorer
  }
}

