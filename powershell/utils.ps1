# Setup aliases
function Add-Alias {
  if (!(Test-Path alias:which)) {
    New-Alias which Get-Command
  }

  if (!(Test-Path alias:grep)) {
    New-Alias grep Select-String
  }

  New-Alias cat "bat.exe" -Force
  New-Alias k kubectl.exe -Force

  New-Alias npm WriteDontUseNpm -Force

  New-Alias lla ls

  New-Alias g git
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

# Ive experienced too many issues with npm to rely on it, but my hands keep forgetting to not type it
function WriteDontUseNpm {
  Write-Host -ForegroundColor Red "Use 'pnpm' or 'yarn' instead! (or '_npm' if you really need to use npm)"
}
