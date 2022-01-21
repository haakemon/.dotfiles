

# I often use @{u} (https://git-scm.com/docs/gitrevisions) to reference the upstream branch, or @{n} (where n is a number) to reference git stash indexes. This does not work great in PowerShell since it will be
# interpreted as a hash table. There are some workarounds, f.ex use backticks to escape: "`@`{u`}" or wrap it in parentheses "(@{u})". Both alternatives are a lot of special characters to type which is not ideal.
# This helper function can be called like this: git diff (rev) which will execute git diff @{u}, or git diff (rev 1) which will execute git diff @{1}. This approach does not work for all ref usecases, f.ex
# working with stash (f.ex git stash apply stash@{0}).
function Get-Revision {
  [Alias("rev")]
  Param(
    [string]$r = "u"
  )

  return "`@`{$r`}"
}

# Quickly add gitignore file, windows, linux and osx are added by default
function Write-Gitignore {
  [Alias("gig")]
  Param(
    [Parameter(Mandatory = $true)]
    [string[]]$list
  )

  $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
  Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/windows,linux,osx,$params" | Select-Object -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}

# Download the latest release of Delta, which is used for prettier git diffs
# This will run automatically when profile is loaded, if Delta does not exist in the target directory
function Update-Delta {
  $rawUrl = curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep "browser_download_url" | grep "pc-windows.*zip"
  $trimmedUrl = $rawUrl.tostring().trim()
  $downloadUrl = $trimmedUrl.substring(25, $trimmedUrl.length - 26)

  $binPath = "$env:USERPROFILE\.dotfiles\bin\delta"
  if (-Not (Test-Path $binPath)) {
    New-Item -Path "$env:USERPROFILE\.dotfiles\bin" -Name "delta" -ItemType "directory" > $null
  }

  if (-Not (Test-Path "$binPath\temp")) {
    New-Item -Path $binPath -Name "temp" -ItemType "directory" > $null
  }

  $ZipFile = "$binPath\temp\" + $(Split-Path -Path $downloadUrl -Leaf)
  $FolderName = $ZipFile.substring(0, $ZipFile.length - 4)

  Invoke-WebRequest -Uri $downloadUrl -OutFile $ZipFile

  Expand-Archive -LiteralPath $ZipFile -DestinationPath "$binPath\temp"

  Move-Item -Path "$FolderName\*" -Destination $binPath -Force

  Remove-Item "$binPath\temp" -Recurse
}

function Edit-Gitconfig {
  code "$env:USERPROFILE\.gitconfig"
}

function Add-Gitconfig-Settings {
  git config --global --replace-all include.path "$env:USERPROFILE\.dotfiles\git\.gitconfig-settings" "$env:USERPROFILE\.dotfiles\git\.gitconfig-settings"
}
