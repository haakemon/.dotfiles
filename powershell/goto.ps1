# Easy way to cd into commonly used directories
function Initialize-Goto {
  $gitrootDescription = "Root of git repository"
  $appsFolderDescription = "shell:AppsFolder"

  $globalLocations = @{
    'appsfolder' = $appsFolderDescription;
    'gitroot'    = $gitrootDescription;
    'dotfiles'   = "$env:USERPROFILE\.dotfiles";
    'startup'    = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup";
  }

  if (Test-Path 'env:Dotfiles_Goto_Locations') {
    $hash = Invoke-Expression $env:Dotfiles_Goto_Locations
    Merge-Hashtables $globalLocations $hash
  }

  function WriteInvalidGotoLocation {
    Param(
      [string]$Location,
      [System.Collections.Hashtable]$Locations
    )

    Write-Host -ForegroundColor Red "Invalid location parameter '$Location'"
    Write-Host "Valid locations:"
    Write-Host ($Locations | Out-String)
  }

  function Set-CurrentDirectory {
    [Alias("goto")]
    Param(
      [Parameter(Mandatory = $false)]
      [string]$location
    )

    if ($globalLocations.ContainsKey($location)) {

      # special handling for gitroot location
      if ($globalLocations[$location] -eq $gitrootDescription) {
        $root = git rev-parse --show-toplevel
        return Set-Location $root
      }

      # special handling for AppsFolder
      if ($globalLocations[$location] -eq $appsFolderDescription) {
        return Start-Process $globalLocations[$location]
      }

      return Set-Location $globalLocations[$location]
    }
    else {
      WriteInvalidGotoLocation $location $globalLocations
    }
  }
}
