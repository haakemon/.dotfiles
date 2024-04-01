{ lib, ... }:

{
  options = {
    configOptions = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "The username for the user";
      };
      userHome = lib.mkOption {
        type = lib.types.str;
        description = "The home path for the user";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The hostname for the system";
      };
      headless = lib.mkOption {
        type = lib.types.bool;
        description = "Some configuration will not be applied on a headless system";
        default = false;
      };
      timezone = lib.mkOption {
        type = lib.types.str;
        description = "Timezone";
        default = "Europe/Oslo";
      };
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        description = "Language to be used for LANG, LC_CTYPE, LC_COLLATE and LC_MESSAGES";
        default = "en_US.UTF-8";
      };
      extraLocale = lib.mkOption {
        type = lib.types.str;
        description = "Language to be used for LC_ADDRESS, LC_IDENTIFICATION, LC_MEASUREMENT, LC_MONETARY, LC_NAME, LC_NUMERIC, LC_PAPER, LC_TELEPHONE and LC_TIME";
        default = "nb_NO.UTF-8";
      };
      consoleKeymap = lib.mkOption {
        type = lib.types.str;
        description = "Language to be used for console.keyMap";
        default = "no";
      };
      git = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Git username";
        };
        email = lib.mkOption {
          type = lib.types.str;
          description = "Git email";
        };
      };
      flake = {
        dir = lib.mkOption {
          type = lib.types.str;
          description = "Absolute path to flake location";
        };
        hash = lib.mkOption {
          type = lib.types.str;
          description = "Flake name";
        };
      };
      sshKeys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        example = {
          id_ed25519 = "field name for passphrase in Bitwarden";
          id_rsa = "field name for passphrase in Bitwarden";
        };
        description = "An attribute set of SSH keys. The key value should be the ssh key filename, and the value should be the field name to lookup the passphrase in Bitwarden";
      };
    };
  };
}
