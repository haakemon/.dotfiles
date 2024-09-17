{
  description = "A very basic flake";

  outputs =
    { self
    , nixpkgs
    , chaotic
    , home-manager
    , niri
    , nixos-cosmic
    , ...
    } @ inputs:
    let
      odin = import ./hosts/odin/variables-local.nix {
        lib = nixpkgs.lib;
      };
      delling = import ./hosts/delling/variables-local.nix {
        lib = nixpkgs.lib;
      };
      heimdall = import ./hosts/heimdall/variables-local.nix {
        lib = nixpkgs.lib;
      };
    in
    {
      nixosConfigurations = {
        odin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/odin/configuration.nix
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }
            nixos-cosmic.nixosModules.default
            chaotic.nixosModules.default
            niri.nixosModules.niri
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        };

        delling = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/delling/configuration.nix
            chaotic.nixosModules.default
            niri.nixosModules.niri
            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        };

        heimdall = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/heimdall/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    niri.url = "github:sodiboo/niri-flake";
    stylix.url = "github:danth/stylix";

    ags.url = "github:Aylur/ags";
    wezterm.url = "github:wez/wezterm?dir=nix";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
