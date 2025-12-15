function global:src {
    $p = $PROFILE.CurrentUserAllHosts
    Write-Host "Sourcing '$p'"
    . $p
}
