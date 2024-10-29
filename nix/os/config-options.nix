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
      sshKeys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        example = {
          id_ed25519 = "field name for passphrase in Bitwarden";
          id_rsa = "field name for passphrase in Bitwarden";
        };
        description = "An attribute set of SSH keys. The key value should be the ssh key filename, and the value should be the field name to lookup the passphrase in Bitwarden";
      };

      acme = {
        domain = lib.mkOption {
          type = lib.types.str;
          description = "domain name";
        };
        email = lib.mkOption {
          type = lib.types.str;
          description = "acme email";
        };
        provider = lib.mkOption {
          type = lib.types.str;
          description = "acme provider";
        };
        credentialsFile = lib.mkOption {
          type = lib.types.str;
          description = "path to credentials file";
        };
      };
      wireguardPort = lib.mkOption {
        type = lib.types.number;
        description = "port number for wireguard";
      };
    };
  };
}
