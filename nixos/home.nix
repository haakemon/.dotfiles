{ config, pkgs, username, hostname, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  # home.enableDebugInfo = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    firefox
    vivaldi

    keychain
    bitwarden

    fastfetch
    eza
    zsh-powerlevel10k

    vscode
    notepadqq
    fnm
    # distrobox

    steam
    heroic

    obs-studio
    prusa-slicer
    spotify
    freetube
    softmaker-office

    telegram-desktop
    discord
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/fastfetch/config.jsonc".source = ../fastfetch/config.jsonc;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/haakemon/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  # home.sessionVariables = {
  #   FOO = "Hello";
  #   BAR = "${config.home.sessionVariables.FOO} World!";
  # };

  home.shellAliases = {
    g = "git";
    lla = "eza --all --long --header --git --icons --group-directories-first";
    nixrebuild = "sudo nixos-rebuild --upgrade switch --flake .";
    nixrebuild-nocache = "sudo nixos-rebuild --upgrade --option eval-cache false switch --flake .";
    ".." = "cd ..";
    "..." = "cd ../..";
  };

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };


  nixpkgs.config = {
    allowUnfree = true;
  };

  # fonts.fontconfig.enable = true; # TODO: investigate

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        indent_size = 2;
        max_line_width = 85;
        indent_style = "space";
      };

      "*.md" = {
        trim_trailing_whitespace = false;
      };
    };
  };

  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
    git = {
      enable = true;
      delta.enable = true;
      includes = [
        { path = "~/.dotfiles/git/.gitconfig-alias"; }
        { path = "~/.dotfiles/git/.gitconfig-color"; }
        { path = "~/.dotfiles/git/.gitconfig-settings"; }
        { path = "~/.dotfiles/git/.gitconfig-signing"; }
      ];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      history = {
        ignoreAllDups = true;
      };
      initExtraFirst = ''
# initExtraFirst

source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

source "''${HOME}/.dotfiles/zsh/p10k.zsh"
source "''${HOME}/.dotfiles/zsh/p10k-extensions.zsh"
source "''${HOME}/.dotfiles/zsh/env.zsh"
source "''${HOME}/.dotfiles/zsh/ssh.zsh"

fastfetch

      '';
    };
  };
}
