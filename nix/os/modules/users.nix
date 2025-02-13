{ config, pkgs, ... }:

{
  users.users.${config.configOptions.username} = {
    isNormalUser = true;
    linger = true;
    description = "${config.configOptions.username}";
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
    packages = [

    ];
  };
}
