. "$env:USERPROFILE\.dotfiles\powershell\goto.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\fnm.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\utils.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\git-utils.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\download-utils.ps1"

function Initialize-Profile {
  Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash-like completion
  Set-PSReadlineOption -BellStyle None # Disable beep on backspace when line is empty
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # scroll through history for text that starts with current input
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # scroll through history for text that starts with current input
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd

  # Get a nice inline prediction on what to type based on history
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle InlineView

  Import-Module -Name Terminal-Icons
  Import-Module posh-git
  oh-my-posh --init --shell pwsh --config "$env:USERPROFILE\.dotfiles\oh-my-posh\.mytheme.omp.json" | Invoke-Expression

  . Add-Alias
  . Initialize-Goto

  TestUtilsDownloaded

  Write-Host "Dotfiles profile loaded"
}

. Initialize-Profile

fnm env --use-on-cd | Out-String | Invoke-Expression
