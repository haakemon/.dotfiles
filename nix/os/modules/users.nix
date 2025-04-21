{ config, lib, pkgs, ... }:

{
  users.users.${config.user-config.name} = {
    isNormalUser = true;
    linger = true;
    description = config.user-config.name;
    home = config.user-config.home;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
      "dialout"
      "tty"
      "input"
      "plugdev"
      "podman"
    ];
    shell = pkgs.zsh;
    packages = [ ];
  };
}
