$destination = Split-Path -Parent $PROFILE.CurrentUserAllHosts

# The destination is probably in OneDrive, so symlinks don't work as expected.
# Instead, we need to just recursively copy the profile directory to the destination.
Copy-Item -Path $PSScriptRoot\pwsh\profile -Destination $destination -Recurse -Force
Copy-Item -Path $PSScriptRoot\pwsh\profile.ps1 -Destination $destination -Force

# symlink ~/.config to the dotfiles config directory
Write-Host "Creating symbolic link for ~/.config to $PSScriptRoot\config."
Write-Host "This requires administrator privileges, so you may be prompted to approve sudo."
sudo pwsh -NoProfile -Command "New-Item -Path $HOME\.config -ItemType SymbolicLink -Value $PSScriptRoot\config"
