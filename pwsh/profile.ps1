# order is important
# modules includes posh-git, which changes the prompt IFF it's the default
# completions includes zoxide, which changes the prompt to hook into changes in pwd, so it must not be before modules
. "$PSScriptRoot\Profile\modules.ps1"
. "$PSScriptRoot\Profile\completions.ps1"
. "$PSScriptRoot\Profile\functions.ps1"
