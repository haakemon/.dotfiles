{ config, pkgs, ... }:

{
  users.users.${config.configOptions.username} = {
    isNormalUser = true;
    description = "${config.configOptions.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
    packages = [

    ];
  };
}
