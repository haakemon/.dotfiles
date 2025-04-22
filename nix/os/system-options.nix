{ config, lib, ... }:

{
  options = {
    system-config = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The hostname for the system";
      };
      headless = lib.mkOption {
        type = lib.types.bool;
        description = "Some configuration will not be applied on a headless system";
        default = false;
      };
    };
  };
}
