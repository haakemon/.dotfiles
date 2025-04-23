{ config, pkgs, lib, ... }:

{
  options.browsers = {
    vivaldi = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Vivaldi browser";
      default = true;
    };
    zen = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Zen browser";
      default = true;
    };
    firefox = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Firefox browser";
      default = true;
    };
    chromium = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Chromium browser";
      default = true;
    };
    browsers = lib.mkOption {
      type = lib.types.bool;
      description = "Enable browsers browser";
      default = false;
    };
  };

  config = {
    home-manager.users.${config.user-config.name} = {
      home.packages = lib.flatten [
        (lib.optional config.browsers.browsers pkgs.browsers)
        (lib.optional config.browsers.vivaldi pkgs.vivaldi)
        (lib.optional config.browsers.zen pkgs.zen-browser)
        (lib.optional config.browsers.firefox pkgs.firefox)
        (lib.optional config.browsers.chromium pkgs.ungoogled-chromium)
      ];
    };
  };
}
