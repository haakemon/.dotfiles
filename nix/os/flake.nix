{
  description = "A very basic flake";

  outputs =
    { self
    , ...
    }@inputs:
    let
      odin = import ./hosts/odin/variables-local.nix {
        lib = inputs.nixpkgs.lib;
      };
      delling = import ./hosts/delling/variables-local.nix {
        lib = inputs.nixpkgs.lib;
      };
      heimdall = import ./hosts/heimdall/variables-local.nix {
        lib = inputs.nixpkgs.lib;
      };

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

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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

    sops-secrets = {
      url = "git+ssh://git@github.com/haakemon/sops.git?ref=main&shallow=1";
      flake = false;
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
  };
}
