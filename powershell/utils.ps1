# Setup alias for which, grep and npm
function Add-Alias {
  if (!(Test-Path alias:which)) {
    New-Alias which Get-Command
  }

  if (!(Test-Path alias:grep)) {
    New-Alias grep Select-String
  }

  New-Alias npm Write-Use-Yarn-Instead -Force
}

# Most projects I work on these days use yarn instead of npm, but its difficult to remember to use the yarn command
function Write-Use-Yarn-Instead {
  Write-Host -ForegroundColor Red "Use 'yarn' instead! (or '_npm' if you really need to use npm)"
}

# Starts a new pwsh instance in the current directory with administrator privileges
function Start-Elevated-Pwsh {
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

# Quick way to launch Notepad++
function Start-Notepad-Plus-Plus {
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
