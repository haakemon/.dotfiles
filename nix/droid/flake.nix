{
  description = "Nix-on-Droid system config";

  outputs =
    { self
    , nixpkgs
    , nix-on-droid
    , home-manager
    ,
    }:
    {

      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
        };
        modules = [ ./nix-on-droid.nix ];

        home-manager-path = home-manager.outPath;
      };

    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
