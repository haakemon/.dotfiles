# Dotfiles

This repo started out as somewhere to store my dotfiles, and have an easy way to replicate it across multiple machines, and also to keep a backup. As time went, I also added various application configs that I have accidentally deleted when I have wiped any of my machines.

Some parts of these files and scripts expect the repo to be cloned to `$env:USERPROFILE\.dotfiles`, which usually translates to something like `C:\Users\[USER_NAME]\.dotfiles\`.

## Affinity Designer

I have setup some export templates that I have lost too many times after wiping my computer, and forgot to back this up. Now I will never have to recreate those templates. This file should be placed (or symlinked) in `AppData\Roaming\Affinity\Designer\1.0\user`.

## Autohotkey

Some useful autohotkey snippets

- window-on-top.ahk - Toggles always on top for the current window
- hotkeys.ahk - Maps some media controls and brackets, enable google highlighted text

Shortcuts to these can be placed in Windows startup folder (use Startup Folder.lnk for quick access to this folder) so they start automatically on boot.

## [Bat](https://github.com/sharkdp/bat)

Like `cat`, but on steroids.

To use the config file, a environment variable needs to be set ([official docs](https://github.com/sharkdp/bat#configuration-file)).

Add `BAT_CONFIG_PATH` with the value `C:\Users\[USER_NAME]\.dotfiles\bat\bat.conf`.

When the PowerShell profile is set up (below), `bat` is aliased to `cat`. The original `cat` is available as `_cat`.

## Git

Some aliases, and settings for git. Some of the aliases might not work in anything else than git bash (or linux) since that is what I used when I first wrote them, and some of them I rarely use anymore.

These aliases can be set up by executing the `Add-GitconfigSettings` PowerShell script (This can be done after setting up the PowerShell profile - see Powershell further down).

## PowerShell

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

### Naming conventions

I've tried following the naming conventions for functions, except for "helper functions" that are not meant to be discovered/used directly by users. These are breaking the naming convention, and are not using any `-` in the name.

### Include in powershell profile

The easiest way to add these profile settings is to include them in the powershell profile. This is usually located in `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`, but you can also check for its existence by executing `Test-Path $profile`, and execute `$profile` will give you the location. If this file does not exist, you can create it by executing `New-Item -path $profile -type file –force`.

After the file has been created, add `. "$env:USERPROFILE\.dotfiles\powershell\profile.ps1` to it. When opening a new PowerShell terminal, you should now see `Dotfiles profile loaded` printed in the terminal. If you make changes to the profile, you can reload the profile by executing `. $profile` to avoid having to restart the terminal session to get the updated commands.

### A note about Set-CurrentDirectory (goto) function

I have some directories I often work with via command line. These are reachable through the goto function, and since my work and home computers are set up with different directory locations, I decided to utilise environment variables for this.

There are some locations that are available by default:

- `appsfolder` opens Explorer to Applications directory.
- `dotfiles` cds to `$env:USERPROFILE\.dotfiles`.
- `gitroot` cds to the root of the git repository.
- `startup` cds to the startup folder.

To add additional locations, create a environment variable called `Dotfiles_Goto_Locations` with a hashtable value, f.ex `@{'code' = "C:\Code\";'tmp' = "C:\temp\";'downloads' = "C:\Downloads\";}`.

## Registry

I really hate the [Aero Shake](https://www.howtogeek.com/howto/windows-7/disable-aero-shake-in-windows-7/) feature, and with these registry edits its quick to disable it (and re-enable if you change your mind).

## [Sublime Merge](https://www.sublimemerge.com/)

My preferred GUI Git tool. Contains settings and a nice theme to match my VS Code theme.

### Setup instructions

The easiest way to set this up is to add a symlink to the Sublime Merge Packages directory. This is usually located at `C:\Users\[USER]\AppData\Roaming\Sublime Merge\Packages`

If this folder (Packages) already exists, you need to delete it. This is because you cannot create a symlink for a directory that already exists.

Open a CMD prompt and execute `mklink /D "[SUBLIME_DIRECTORY]\Packages" "[DOTFILES_REPOSITORY]\sublime merge\Packages"`

Replace `[SUBLIME_DIRECTORY]` with the correct location (usually `C:\Users\[USER]\AppData\Roaming\Sublime Merge\Packages`) and replace `[DOTFILES_REPOSITORY]` with the location of where this repo is cloned.

## [Terminal](https://github.com/microsoft/terminal/)

### Setup instructions

This needs to be done when all instances of the application are closed, because the settings.json that you need to delete will be automatically created when the application is running.

The easiest way to set this up is to add a symlink to the settings.json file. This is usually locaed at `C:\Users\[USER_NAME]\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`

If this file (settings.json) already exists, you need to delete it. This is because you cannot create a symlink for a file that already exists.

Open a CMD prompt and execute `mklink "C:\Users\[USER_NAME]\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "[DOTFILES_REPOSITORY]\terminal\settings.json"`

Replace `[USER_NAME]` with the correct location and replace `[DOTFILES_REPOSITORY]` with the location of where this repo is cloned.

### Themes

More themes can be found at https://windowsterminalthemes.dev/
