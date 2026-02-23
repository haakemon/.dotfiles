{ config
, pkgs
, lib
, inputs
, ...
}:
let
  secretspath = builtins.toString inputs.dotfiles-private-nonflake;
in
{
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
      historyFile = "${config.home.sessionVariables.XDG_STATE_HOME}/bash/history";
    };
  };

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

  services.lorri.enable = true;

  home = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    username = config.user-config.name;
    homeDirectory = config.user-config.home;

    sessionVariables = {
      # https://wiki.archlinux.org/title/XDG_Base_Directory
      XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
      XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
      XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
      XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
      XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";

      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

      DOTNET_CLI_HOME = "${config.home.sessionVariables.XDG_CONFIG_HOME}/.dotnet";
      NPM_CONFIG_USERCONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/npm/config";
      AZURE_CONFIG_DIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/azure";
      FLY_CONFIG_DIR = "${config.home.sessionVariables.XDG_CONFIG_HOME}/fly";
      KUBECONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/kube/config";

      NUGET_PACKAGES = "${config.home.sessionVariables.XDG_CACHE_HOME}/NuGetPackages";
      CARGO_HOME = "${config.home.sessionVariables.XDG_CACHE_HOME}/cargo";
      DVDCSS_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/dvdcss";
      NPM_CONFIG_CACHE = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_cache";
      NPM_CONFIG_TMP = "${config.home.sessionVariables.XDG_CACHE_HOME}/npm_tmp";
      AZURE_LOGGING_LOG_DIR = "${config.home.sessionVariables.XDG_CACHE_HOME}/azure/logs";
      __GL_SHADER_DISK_CACHE_PATH = "${config.home.sessionVariables.XDG_CACHE_HOME}/nv"; # nvidia cache https://us.download.nvidia.com/XFree86/FreeBSD-x86/319.32/README/openglenvvariables.html
      KUBECACHEDIR = "${config.home.sessionVariables.XDG_CACHE_HOME}/kube";

      ADB_VENDOR_KEYS = "${config.home.sessionVariables.XDG_DATA_HOME}/android";
      RUSTUP_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/rustup";
      GNUPGHOME = "${config.home.sessionVariables.XDG_DATA_HOME}/gnupg";

      BAT_CONFIG_PATH = "${config.home.homeDirectory}/.dotfiles/bat/bat.conf";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";

      DOTNET_CLI_TELEMETRY_OPTOUT = 1;
      NODE_REPL_HISTORY = ""; # Disable node repl persistent history
      PODMAN_COMPOSE_WARNING_LOGS = "false";

      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];

    file = {
      ".config/nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        }
      '';

      ".config/systemd/user/proton-pass-agent.service".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/systemd/proton-pass-agent.service";
      ".config/git/config".source =
        config.lib.file.mkOutOfStoreSymlink "${config.user-config.home}/.dotfiles/git/.gitconfig";
    };

    packages = [
      pkgs.systemctl-tui
      pkgs.lazyjournal # journalctl tool
      pkgs.ugm # user group browser
      pkgs.brightnessctl
      pkgs.direnv

      pkgs.filen-cli
      pkgs.proton-pass-cli

      pkgs.bandwhich # network utilization monitor
      pkgs.superfile
      pkgs.television # multi-purpose fuzzy finder
      pkgs.lm_sensors

      pkgs.unzip
      pkgs.gnumake
      pkgs.croc # Easily and securely send things from one computer to another
      pkgs.magic-wormhole # Securely transfer data between computers
      pkgs.git
      pkgs.curl
      pkgs.nano
      pkgs.simple-http-server
      pkgs.nmap
      pkgs.fnm
      pkgs.pnpm
      pkgs.ffmpeg-full
      pkgs.v4l-utils
      pkgs.nixd # nix language server
      pkgs.mqttui
      pkgs.prek # pre-commit alternative
      pkgs.neovim
      pkgs.gh # github cli
      pkgs.nixpkgs-fmt # formatting .nix files
      pkgs.nixfmt-rfc-style # formatting .nix files
      pkgs.statix
      pkgs.gcc # requirement for nixpkgs-fmt in prek
      pkgs.rustup # requirement for nixpkgs-fmt in prek
      # pkgs.keychain
      pkgs.delta
      pkgs.age
      pkgs.sops
      pkgs.pik # Process Interactive Kill
      pkgs.sshs # Terminal user interface for SSH config
      pkgs.sttr # Cross-platform cli tool to perform various operations on string
      pkgs.pwdsafety # Password utility
      pkgs.havn # Fast configurable port scanner with reasonable defaults
      pkgs.gtrash # Trash CLI tool

      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
            profile = "export FHS=1";
            runScript = "zsh";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
  };

}
