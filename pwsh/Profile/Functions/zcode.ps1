function global:zcode {
    <#
    .SYNOPSIS
        Opens a directory in VS Code using zoxide for path resolution.

    .DESCRIPTION
        This function takes a path argument, queries zoxide for the best
        matching directory, and opens it in Visual Studio Code.

    .PARAMETER path
        The path or query string to be resolved by zoxide.

    .EXAMPLE
        zcode projects

        Opens the best matching directory for "projects" in VS Code.

    .EXAMPLE
        zcode work docs

        Opens the best matching directory for "work docs" in VS Code.

    .EXAMPLE
        zcode some project -WhatIf

        Check what would be opened without actually opening it.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$path
    )

    $queried = zoxide query $path
    $code = $LASTEXITCODE
    # if no path or command failed, write error and return
    if ([string]::IsNullOrEmpty($queried) -or $code -ne 0) {
        Write-Error "No matching path found for '$path'"
        return
    }

    Write-Host "Opening $queried"

    if ($PSCmdlet.ShouldProcess($queried, "code")) {
        code $queried
    }
}
