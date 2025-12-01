{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixpkgs-unstable-small = {
      url = "github:NixOS/nixpkgs/nixos-unstable-small";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-secrets = {
      url = "git+ssh://git@github.com/haakemon/sops.git?ref=main&shallow=1";
      flake = false;
    };

    dotfiles-private = {
      url = "git+ssh://git@github.com/haakemon/.dotfiles-private.git?ref=main&shallow=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , sops-nix
    , sops-secrets
    , dotfiles-private
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkOverlays = config: import ./overlays/nixpkgs-overlays.nix config inputs;
    in
    {
      homeConfigurations = {
        delling = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          modules = [
            sops-nix.homeManagerModules.sops
            dotfiles-private.homeManagerModules.hosts.delling
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
            ./hosts/delling/home.nix
          ];
        };

        odin = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs;
          };

          modules = [
            sops-nix.homeManagerModules.sops
            dotfiles-private.homeManagerModules.hosts.odin
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
            ./hosts/odin/home.nix
          ];
        };
      };
    };
}
