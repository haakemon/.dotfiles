{ config, pkgs, ... }:
let
  inherit (import ./options.nix)
    username;
in
{
  systemd.user.services.jotta = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.jotta-cli}/bin/jottad";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
  };
}
