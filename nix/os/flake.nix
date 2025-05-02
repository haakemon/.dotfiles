{
  description = "My NixOS config";

  outputs =
    { self
    , ...
    }@inputs:
    let
      mkOverlays = config: import ./nixpkgs-overlays.nix config inputs;

      homeManagerConf = {
        home-manager = {
          extraSpecialArgs = {
            inherit inputs;
          };
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };

      cosmicModuleSettings = [
        {
          nix.settings = {
            substituters = [ "https://cosmic.cachix.org/" ];
            trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          };
        }
        inputs.nixos-cosmic.nixosModules.default
      ];

    in
    {
      nixosConfigurations = {
        odin = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/odin/configuration.nix
            inputs.chaotic.nixosModules.default
            inputs.niri.nixosModules.niri
            # inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };

        delling = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = cosmicModuleSettings ++ [
            ./hosts/delling/configuration.nix
            inputs.chaotic.nixosModules.default
            inputs.niri.nixosModules.niri
            # inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            inputs.dotfiles-private.nixosModules.hosts.delling
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };

        heimdall = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/heimdall/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            homeManagerConf
            (
              { config, ... }:
              {
                nixpkgs.overlays = [ (mkOverlays config) ];
              }
            )
          ];
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
      follows = "nixos-cosmic/nixpkgs";
    };

    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zeditor = {
      url = "github:zed-industries/zed";
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

    sops-secrets = {
      url = "git+ssh://git@github.com/haakemon/sops.git?ref=main&shallow=1";
      flake = false;
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    nrk-hylla = {
      url = "git+ssh://git@github.com/nrkno/linux-hylla.git?ref=feature/nix-f5vpn&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
