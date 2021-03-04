$destination = $home + "\AppData\Local\Microsoft\Windows\Shell"#
$source = $PSScriptRoot + "\LayoutModification.xml"

Copy-Item $source -Destination $destination

$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache"

Remove-Item $path -Force -Recurse

Stop-Process -ProcessName explorer