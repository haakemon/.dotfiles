# PowerShell

This is mainly taken from [Scott Hanselman's blog post about oh-my-posh](https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal), but to summarize;

- Install PowerShell (pwsh):
  - `winget install Microsoft.PowerShell`
- Install Windows Terminal:
  - https://github.com/microsoft/terminal/releases
- Install a nerd font:
  - https://github.com/ryanoasis/nerd-fonts/releases
  - I like Fira Code for VS Code, and MesloLGM for terminal
- Install Terminal-Icons:
  - `Install-Module -Name Terminal-Icons`
- Install posh-git:
  - `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm`
  - `PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force`
- Install oh-my-posh:
  - `winget install JanDeDobbeleer.OhMyPosh`
- Install PSReadLine if its not already installed:
  - `Install-Module PSReadLine -AllowPrerelease -Force`
- Install Bat and add it to PATH

### Naming conventions

I've tried following the naming conventions for functions, except for "helper functions" that are not meant to be discovered/used directly by users. These are breaking the naming convention, and are not using any `-` in the name.

### Include in powershell profile

The easiest way to add these profile settings is to include them in the powershell profile. This is usually located in `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`, but you can also check for its existence by executing `Test-Path $profile`, and execute `$profile` will give you the location. If this file does not exist, you can create it by executing `New-Item -path $profile -type file –force`.

After the file has been created, add `. "$env:USERPROFILE\.dotfiles\powershell\profile.ps1` to it. When opening a new PowerShell terminal, you should now see `Dotfiles profile loaded` printed in the terminal. If you make changes to the profile, you can reload the profile by executing `. $profile` to avoid having to restart the terminal session to get the updated commands.

## Windows

To easily get to the startup folder, you can go to `$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

To easily get to the apps folder, you can go to `shell:AppsFolder`
