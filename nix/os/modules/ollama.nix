{ config, pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      # acceleration = "cuda";
    };
  };
}
