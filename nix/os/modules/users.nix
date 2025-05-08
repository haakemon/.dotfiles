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

    # openssh.authorizedKeys.keys = [
    #   ${config.user-config.home}/.dotfiles/keys/id_ed25519.pub
    #   ${config.user-config.home}/.dotfiles/keys/id_ed25519_odin.pub
    # ];
  };
}
