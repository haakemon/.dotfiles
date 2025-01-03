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

      nixpkgsOverlays = import ./nixpkgs-overlays.nix;

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
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            homeManagerConf
            {
              nixpkgs.overlays = [ nixpkgsOverlays ];
            }
          ];
        };

        delling = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/delling/configuration.nix
            inputs.chaotic.nixosModules.default
            inputs.niri.nixosModules.niri
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            homeManagerConf
            {
              nixpkgs.overlays = [ nixpkgsOverlays ];
            }
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
            inputs.sops-nix.nixosModules.sops
            homeManagerConf
            {
              nixpkgs.overlays = [ nixpkgsOverlays ];
            }
          ];
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/585f76290ed66a3fdc5aae0933b73f9fd3dca7e3";
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

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      # inputs.nixpkgs.follows = "nixpkgs"; # this breaks for some reason
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
