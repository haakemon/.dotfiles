{ pkgs, ... }:

{
  home = {
    packages = [
      pkgs.heroic
      pkgs.vesktop
      pkgs.discord

      # pkgs.mari0
      # pkgs.pingus
      # pkgs.openrw
      # pkgs.openra https://github.com/NixOS/nixpkgs/issues/360335#issuecomment-2513069288
      # pkgs.airshipper # https://www.veloren.net/
      # pkgs.superTuxKart
      # pkgs.openrct2
      # pkgs.simutrans
      # pkgs.widelands
    ];
  };
}
