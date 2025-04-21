{ config, lib, ... }:

{
  options = {
    user-config = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The username for the user";
        example = "alice";
      };
      home = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.user-config.name}";
        description = "The home path for the user";
        example = "/home/alice";
      };
    };
  };
}
