$destination = $home + "\AppData\Local\Microsoft\Windows\Shell\a"#
$source = $PSScriptRoot + "\LayoutModification2.xml"

# Copy-Item $source -Destination $destination

$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache"

Remove-Item $path -Force -Recurse

Stop-Process -ProcessName explorer