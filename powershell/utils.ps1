# Setup aliases
function Add-Alias {
  if (!(Test-Path alias:which)) {
    New-Alias which Get-Command
  }

  if (!(Test-Path alias:grep)) {
    New-Alias grep Select-String
  }

  New-Alias cat "$env:USERPROFILE\.dotfiles\bin\bat\bat.exe" -Force
  New-Alias k kubectl.exe -Force

  New-Alias npm WriteUseYarnInstead -Force
}

# Starts a new pwsh instance in the current directory with administrator privileges
function Start-Elevated {
  [Alias("elevate")]
  Param()

  Start-Process pwsh -WorkingDirectory $pwd -Verb runAs
}

# Creates a file if it does not exist, or updates last modified on files that exist
function Update-Location {
  [Alias("touch")]
  Param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  if (Test-Path -LiteralPath $Path) {
    (Get-Item -Path $Path).LastWriteTime = Get-Date
  }
  else {
    New-Item -Type File -Path $Path
  }
}

# For when you actually need to use npm instead of yarn
function Use-Npm {
  [Alias("_npm")]
  Param()

  pwsh.exe -nop -c npm $args
}

# Just in case bat causes issues, cat is available with _ prefix
function Use-RealCat {
  [Alias("_cat")]
  Param()

  pwsh.exe -nop -c cat $args
}

# Quick way to launch Notepad++
function Start-NotepadPlusPlus {
  [Alias("npp")]
  Param()

  notepad++.exe $args
}

# Merge hashtable 2 into the first
function Merge-Hashtables {
  Param(
    [Parameter(Mandatory = $true)]
    [System.Collections.Hashtable]$htold,

    [Parameter(Mandatory = $true)]
    [System.Collections.Hashtable]$htnew
  )

  $htnew.keys | Where-Object { $_ -notin $htold.keys } | ForEach-Object { $htold[$_] = $htnew[$_] }
}

# Helper functions, should not be called directly by user

# Most projects I work on these days use yarn instead of npm, but its difficult to remember to use the yarn command
function WriteUseYarnInstead {
  Write-Host -ForegroundColor Red "Use 'yarn' instead! (or '_npm' if you really need to use npm)"
}

# Warn user if binaries are not found
function TestUtilsDownloaded {

  if (-Not (Test-Path "$env:USERPROFILE\.dotfiles\bin\delta\delta.exe")) {
    Write-Host "Delta not found, download by executing 'Update-Delta'"
  }

  if (-Not (Test-Path "$env:USERPROFILE\.dotfiles\bin\bat\bat.exe")) {
    Write-Host "Bat not found, download by executing 'Update-Bat'"
  }
}
