. "$env:USERPROFILE\.dotfiles\powershell\goto.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\utils.ps1"
. "$env:USERPROFILE\.dotfiles\powershell\git-utils.ps1"

function Initialize-Profile {
  Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash-like completion
  Set-PSReadlineOption -BellStyle None # Disable beep on backspace when line is empty
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # scroll through history for text that starts with current input
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # scroll through history for text that starts with current input

  Import-Module -Name Terminal-Icons
  Import-Module posh-git
  oh-my-posh --init --shell pwsh --config "$env:USERPROFILE\.dotfiles\powershell\.mytheme.omp.json" | Invoke-Expression

  . Add-Alias
  . Initialize-Goto

  if (-Not (Test-Path "$env:USERPROFILE\.dotfiles\bin\delta.exe")) {
    Write-Host "Delta not found, starting download..."
    . Update-Delta
  }

  Write-Host "Dotfiles profile loaded"
}

. Initialize-Profile
