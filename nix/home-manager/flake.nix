{
  description = "Home Manager configuration";

  outputs =
    { self
    , nixpkgs
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
      };
      mkOverlays = config: import ./overlays/nixpkgs-overlays.nix config inputs;
    in
    {
      homeConfigurations = {
        delling = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
            hostName = "delling";
          };

          modules = [
            inputs.sops-nix.homeManagerModules.sops
            inputs.dotfiles-private.homeManagerModules.hosts.delling
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
            ./hosts/delling/home.nix
          ];
        };

        odin = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
            hostName = "odin";
          };

          modules = [
            inputs.sops-nix.homeManagerModules.sops
            inputs.dotfiles-private.homeManagerModules.hosts.odin
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
            ./hosts/odin/home.nix
          ];
        };

        heimdall = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
            hostName = "heimdall";
          };

          modules = [
            inputs.sops-nix.homeManagerModules.sops
            inputs.dotfiles-private.homeManagerModules.hosts.heimdall
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
            ./hosts/heimdall/home.nix
          ];
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-unstable-small = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles-private = {
      url = "git+ssh://git@github.com/haakemon/.dotfiles-private.git?ref=main&shallow=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles-private-nonflake = {
      url = "git+ssh://git@github.com/haakemon/.dotfiles-private.git?ref=main&shallow=1";
      flake = false;
    };

  };

}
