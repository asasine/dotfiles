# setup various env variables for placing key files on a dev drive (assumed D:)
$vars = [ordered]@{
    AZUREAUTH_INSTALL_DIRECTORY = "D:\usr\local\bin\AzureAuth"
    CARGO_HOME                  = "D:\usr\share\cargo"
    MSRUSTUP_HOME               = "D:\usr\share\msrustup"
    NUGET_HTTP_CACHE_PATH       = "D:\var\cache\nuget\http"
    NUGET_PACKAGES              = "D:\var\cache\nuget\packages"
    NUGET_PLUGINS_CACHE_PATH    = "D:\var\cache\nuget\plugins"
    NUGET_SCRATCH               = "D:\tmp\nuget"
    PIP_CACHE_DIR               = "D:\var\cache\pip"
    RUSTUP_HOME                 = "D:\usr\share\rustup"
    SCCACHE_CACHE_SIZE          = "50G"
    SCCACHE_DIR                 = "D:\var\cache\sccache"
}

Write-Host "Setting environment variables for user scope if any are missing or different."
foreach ($var in $vars.GetEnumerator()) {
    $current = [System.Environment]::GetEnvironmentVariable($var.Key, [System.EnvironmentVariableTarget]::User)
    if ($current -ne $var.Value) {
        if ($current) {
            Write-Warning "Overwriting existing value for $($var.Key): '$current' -> '$($var.Value)'"
        } else {
            Write-Host "Setting environment variable $($var.Key) to $($var.Value)"
        }

        [System.Environment]::SetEnvironmentVariable($var.Key, $var.Value, [System.EnvironmentVariableTarget]::User)
    }
}

Write-Host

$destination = Split-Path -Parent $PROFILE.CurrentUserAllHosts

# The destination is probably in OneDrive, so symlinks don't work as expected.
# Instead, we need to just recursively copy the profile directory to the destination.
Copy-Item -Path $PSScriptRoot\pwsh\profile -Destination $destination -Recurse -Force
Copy-Item -Path $PSScriptRoot\pwsh\profile.ps1 -Destination $destination -Force

# symlink ~/.config to the dotfiles config directory
$configLink = Get-Item -Path $HOME\.config -ErrorAction SilentlyContinue
if ($configLink -and ($configLink.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -and $configLink.Target -eq "$PSScriptRoot\config") {
    Write-Host "Symbolic link for ~/.config already points to $PSScriptRoot\config, skipping."
} else {
    Write-Host "Creating symbolic link for ~/.config to $PSScriptRoot\config."
    Write-Host "This requires administrator privileges, so you may be prompted to approve sudo."
    sudo pwsh -NoProfile -Command "New-Item -Path $HOME\.config -ItemType SymbolicLink -Value $PSScriptRoot\config" -Force
}

# install cargo packages if cargo is available
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    cargo install --locked ripgrep spongebob zoxide taplo-cli tokei rumdl
    cargo install --locked --path $PSScriptRoot\tools
} else {
    Write-Warning "cargo not found, skipping Rust package installs. Install Rust and cargo and rerun this script to install Rust packages."
}

sudo pwsh -NoProfile -Command 'PowerShellGet\Install-Module posh-git -Repository PSGallery -Force'
