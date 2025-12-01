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
    cockpit.enable = true;
    scrutiny = {
      enable = true;
      collector.enable = true;
      settings.web.listen.port = 8999;
    };
  };

  console.keyMap = "no";
  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

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

  # environment.enableAllTerminfo = true;

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

  environment.systemPackages = [
    pkgs.home-manager
  ];
}
