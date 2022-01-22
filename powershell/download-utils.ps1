
# Replacement for cat, on steroids, aliased to cat
function Update-Bat {
  $binFolder = "bat"
  $binPath = "$env:USERPROFILE\.dotfiles\bin\$binFolder"

  New-Bin-Directory-If-Not-Exists "$binFolder"

  $ZipfileName = Get-File-From-Github https://api.github.com/repos/sharkdp/bat/releases/latest "$binPath" @("browser_download_url", "x86_64-pc-windows-msvc.zip")

  Expand-To-Bin-Path-And-Cleanup $binPath $ZipfileName
}

# Download the latest release of Delta, which is used for prettier git diffs
function Update-Delta {
  $binFolder = "delta"
  $binPath = "$env:USERPROFILE\.dotfiles\bin\$binFolder"

  New-Bin-Directory-If-Not-Exists "$binFolder"

  $Zipfile = Get-File-From-Github https://api.github.com/repos/dandavison/delta/releases/latest "$binPath" @("browser_download_url", "pc-windows.*zip")

  Expand-To-Bin-Path-And-Cleanup $binPath $Zipfile
}

function Expand-To-Bin-Path-And-Cleanup {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$destination,

    [Parameter(Mandatory = $true)]
    [string]$ZipfileName
  )

  $AbsoluteZipPath = "$binPath\temp\$ZipfileName"

  Expand-Archive -LiteralPath $AbsoluteZipPath -DestinationPath "$binPath\temp"

  $ExtractedFolderName = $AbsoluteZipPath.substring(0, $AbsoluteZipPath.length - 4)
  Move-Item -Path "$ExtractedFolderName\*" -Destination $destination -Force

  Remove-Item "$binPath\temp" -Recurse
}

function Get-File-From-Github {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$releasesUrl,

    [Parameter(Mandatory = $true)]
    [string]$destinationPath,

    [Parameter(Mandatory = $true)]
    [array]$grepValues
  )
  New-Temp-Folder-If-Not-Exists $destinationPath

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

function New-Bin-Directory-If-Not-Exists {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$dirName
  )

  $binPath = "$env:USERPROFILE\.dotfiles\bin\$dirName"
  if (-Not (Test-Path $binPath)) {
    New-Item -Path "$env:USERPROFILE\.dotfiles\bin" -Name "$dirName" -ItemType "directory" > $null
  }
}

function New-Temp-Folder-If-Not-Exists {
  Param(
    [Parameter(Mandatory = $true)]
    [string]$location
  )

  if (-Not (Test-Path "$location\temp")) {
    New-Item -Path $location -Name "temp" -ItemType "directory" > $null
  }
}
