{ config, pkgs, username, hostname, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  # home.enableDebugInfo = true;

  home.sessionVariables = {
    XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
    XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

    NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
    DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";

    NIX_CONFIG_HOME="${config.home.homeDirectory}/.dotfiles/nix/os";
    NIX_CONFIG_FLAKE_PART="#nixos";
  };

  home.packages = with pkgs; [
    # Browsers
    firefox
    vivaldi
    ungoogled-chromium

    # Password management
    keychain
    bitwarden
    rbw # https://crates.io/crates/rbw unofficial bitwarden CLI
    pinentry # dependency for rbw

    # Utils
    killall
    mqttmultimeter
    wget
    gparted
    jotta-cli
    fastfetch
    eza
    zsh-powerlevel10k
    (nerdfonts.override { fonts = [ "VictorMono" ]; })
    victor-mono
    bat
    fzf # fuzzy find
    grc # generic text colorizer
    steam-run
    unzip
    libsForQt5.kruler
    headsetcontrol # Set options for headsets

    # Tools
    blender
    vscode
    notepadqq
    wezterm
    bruno
    obs-studio
    prusa-slicer
    freeoffice
    kooha # screen recorder
    jq

    # Virtualization
    podman-compose
    distrobox

    # Gaming
    heroic

    # Music / video
    spotify
    freetube
    vlc

    # Chat
    telegram-desktop
    discord

    (
      let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
        name = "fhs";
        targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
        profile = "export FHS=1";
        runScript = "zsh";
        extraOutputsToInstall = [ "dev" ];
      })
    )
  ];

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

    ".config/fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink /home/${username}/.dotfiles/fastfetch/config.jsonc;
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink /home/${username}/.dotfiles/wezterm/.wezterm.lua;
    ".face.icon".source = config.lib.file.mkOutOfStoreSymlink /home/${username}/.dotfiles/sddm/.face.icon;
  };

  # Settings for virt-manager https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

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
    home-manager.enable = true;
    direnv.enable = true;
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      extraConfig = {
        user = {
          name = "Håkon Bogsrud";
          email = "2082481+haakemon@users.noreply.github.com";
        };
      };
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
      enableAutosuggestions = true;
      history = {
        ignoreAllDups = true;
        # path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
      # dirHashes = {
      #   code = "$HOME/code";
      #   dl = "$HOME/dl";
      #   dotfiles = "$HOME/.dotfiles";
      #   flake = "$HOME/flake";
      # };
      # dotDir = "$XDG_CONFIG_HOME/zsh";

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            hash = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.7.1";
            hash = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
          };
        }
        {
          name = "zsh-fzf-history-search";
          file = "zsh-fzf-history-search.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "joshskidmore";
            repo = "zsh-fzf-history-search";
            rev = "d1aae98ccd6ce153c97a5401d79fd36418cd2958";
            hash = "sha256-4Dp2ehZLO83NhdBOKV0BhYFIvieaZPqiZZZtxsXWRaQ=";
          };
        }
      ];

      initExtraFirst = ''
        #region initExtraFirst

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source "''${HOME}/.dotfiles/zsh/p10k.zsh"
        source "''${HOME}/.dotfiles/zsh/p10k-extensions.zsh"

        fastfetch

        #endregion initExtraFirst
      '';

      initExtra = ''
        #region initExtra

        source "''${HOME}/.dotfiles/zsh/env.zsh"
        source "''${HOME}/.dotfiles/zsh/alias.zsh"
        source "''${HOME}/.dotfiles/zsh/ssh.zsh"
        source "''${HOME}/.dotfiles/zsh/zsh-hooks.zsh"

        #endregion initExtra
      '';
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
