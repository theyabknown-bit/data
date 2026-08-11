# AutoCleanup.ps1
Clear-History; Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\*" -Recurse -Force; Remove-Item "$env:TEMP\*" -Recurse -Force; Remove-Item "$env:WINDIR\Temp\*" -Recurse -Force; Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force; ipconfig /flushdns
