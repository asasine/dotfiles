function global:zcode {
    param (
        [string]$path
    )

    $queried = zoxide query $path
    $code = $LASTEXITCODE
    # if no path or command failed, write error and return
    if ([string]::IsNullOrEmpty($queried) -or $code -ne 0) {
        Write-Error "No matching path found for '$path'"
        return
    }

    Write-Host "Opening $queried"
    code $queried
}
