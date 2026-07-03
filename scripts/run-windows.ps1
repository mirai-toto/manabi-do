Set-Location -Path "$PSScriptRoot\manabi_do"
flutter build windows --release
& ".\build\windows\x64\runner\Release\manabi_do.exe"
