{ config
, pkgs
, lib
, ...
}:

{
  services = {
    # execute to update:
    # fwupdmgr refresh && fwupdmgr update
    fwupd.enable = true;
    dbus.implementation = "broker";
  };

  console.keyMap = "no";
  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "${config.user-config.name}"
      ];
    };
    optimise.automatic = true;
    extraOptions = ''
      !include ${config.sops.secrets."nix/accessTokens".path}
    '';
  };

  environment.enableAllTerminfo = true;

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
  };

  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";

      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };
  };

  home-manager.users.${config.user-config.name} =
    { config
    , pkgs
    , lib
    , ...
    }:
    {
      programs.home-manager.enable = true;

      programs.bash = {
        enable = true;
        enableCompletion = true;
        historyFile = "${config.home.sessionVariables.XDG_STATE_HOME}/bash/history";
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

        username = "${config.user-config.name}";
        homeDirectory = "${config.user-config.home}";

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
          KUBECONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/kube";

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

          DOTNET_CLI_TELEMETRY_OPTOUT = 1;
          NODE_REPL_HISTORY = ""; # Disable node repl persistent history
        };

        sessionPath = [
          "${config.home.homeDirectory}/.local/bin"
        ];

        file = {
          ".config/nixpkgs/config.nix".text = ''
            { allowUnfree = true; }
          '';
        };

        packages = [
          pkgs.systemctl-tui
          pkgs.lazyjournal # journalctl tool
          pkgs.podman-tui
          pkgs.ugm # user group browser

          pkgs.bandwhich # network utilization monitor
          pkgs.superfile
          pkgs.television # multi-purpose fuzzy finder

          pkgs.rclone
          pkgs.unzip
          pkgs.croc
          pkgs.git
          pkgs.curl
          pkgs.nano
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
    };
}
