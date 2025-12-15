$destination = Split-Path -Parent $PROFILE.CurrentUserAllHosts
New-Item -Path $destination\Profile -ItemType SymbolicLink -Value $PSScriptRoot\pwsh\Profile -Force
New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType SymbolicLink -Value $PSScriptRoot\pwsh\profile.ps1 -Force

# make .config dir and symlink config directories
New-Item -Path $HOME\.config -ItemType Directory -Force
$config_dirs = Get-ChildItem -Path $PSScriptRoot\config -Directory
foreach ($dir in $config_dirs) {
    $source = Join-Path -Path $PSScriptRoot\config -ChildPath $dir.Name
    $target = Join-Path -Path $HOME\.config -ChildPath $dir.Name
    New-Item -Path $target -ItemType SymbolicLink -Value $source -Force
}
