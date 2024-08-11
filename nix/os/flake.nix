{
  description = "A very basic flake";

  outputs =
    { self
    , nixpkgs
    , chaotic
    , home-manager
    , niri
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
                users."${odin.config.configOptions.username}" = {
                  imports = [
                    ./hosts/odin/variables-local.nix
                    ./hosts/odin/home/default.nix
                  ];
                };
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
                users."${delling.config.configOptions.username}" = {
                  imports = [
                    ./hosts/delling/variables-local.nix
                    ./hosts/delling/home/default.nix
                  ];
                };
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
                users."${heimdall.config.configOptions.username}" = {
                  imports = [
                    ./hosts/heimdall/variables-local.nix
                    ./hosts/heimdall/home/default.nix
                  ];
                };
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
  };
}
