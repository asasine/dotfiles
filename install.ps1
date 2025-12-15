$destination = Split-Path -Parent $PROFILE.CurrentUserAllHosts
New-Item -Path $destination\Profile -ItemType SymbolicLink -Value $PSScriptRoot\pwsh\Profile -Force
New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType SymbolicLink -Value $PSScriptRoot\pwsh\profile.ps1 -Force
