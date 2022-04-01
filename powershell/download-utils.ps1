# Replacement for cat, on steroids, aliased to cat
function Update-Bat {
  $binFolder = "bat"
  $binPath = CleanAndCreateBinDir "$binFolder"

  $ZipfileName = GetFileFromGithub https://api.github.com/repos/sharkdp/bat/releases/latest "$binPath" @("browser_download_url", "x86_64-pc-windows-msvc.zip")

  ExpandToPathAndCleanup $binPath $ZipfileName
}

# Download the latest release of Delta, which is used for prettier git diffs
function Update-Delta {
  $binFolder = "delta"
  $binPath = CleanAndCreateBinDir "$binFolder"

  $Zipfile = GetFileFromGithub https://api.github.com/repos/dandavison/delta/releases/latest "$binPath" @("browser_download_url", "pc-windows.*zip")

  ExpandToPathAndCleanup $binPath $Zipfile
}

# Helper functions, should not be called directly by user

function ExpandToPathAndCleanup {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$destination,

    [Parameter(Mandatory = $true)]
    [string]$ZipfileName
  )

  $AbsoluteZipPath = "$destination\temp\$ZipfileName"

  Expand-Archive -LiteralPath $AbsoluteZipPath -DestinationPath "$destination\temp"

  $ExtractedFolderName = $AbsoluteZipPath.substring(0, $AbsoluteZipPath.length - 4)
  Move-Item -Path "$ExtractedFolderName\*" -Destination $destination -Force

  Remove-Item "$destination\temp" -Recurse
}

function GetFileFromGithub {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$releasesUrl,

    [Parameter(Mandatory = $true)]
    [string]$destinationPath,

    [Parameter(Mandatory = $true)]
    [array]$grepValues
  )
  NewTempDirectoryIfNotExists $destinationPath

  $rawUrl = curl -s $releasesUrl

  foreach ($val in $grepValues ) {
    $rawUrl = $rawUrl | grep $val
  }

  $trimmedUrl = $rawUrl.tostring().trim()
  $downloadUrl = $trimmedUrl.substring(25, $trimmedUrl.length - 26)

  $ZipfileName = Split-Path -Path $downloadUrl -Leaf

  $dest = "$destinationPath\temp\$ZipfileName"

  Invoke-WebRequest -Uri $downloadUrl -OutFile $dest

  return $ZipfileName
}

function CleanAndCreateBinDir {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$dirName
  )

  $binPath = "$env:USERPROFILE\.dotfiles\bin\$dirName"
  if ((Test-Path $binPath)) {
    Remove-Item $binPath -Recurse -Force
  }

  New-Item -Path "$env:USERPROFILE\.dotfiles\bin" -Name "$dirName" -ItemType "directory" > $null

  return $binPath
}

function NewTempDirectoryIfNotExists {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$location
  )

  if (-Not (Test-Path "$location\temp")) {
    New-Item -Path $location -Name "temp" -ItemType "directory" > $null
  }
}
