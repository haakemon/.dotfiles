{
  description = "A very basic flake";

  outputs = { self, nixpkgs, home-manager, xremap-flake }:
    let
      system = "x86_64-linux";
      hostname = "nixos";
      timezone = "Europe/Oslo";
      defaultLocale = "en_US.UTF-8";
      extraLocale = "nb_NO.UTF-8";

      username = "haakemon";

      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        "${hostname}" = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname username timezone defaultLocale extraLocale; };
          modules = [
            ./configuration.nix
            xremap-flake.nixosModules.default
            {
              services.xremap = {
                # withWlroots = true;
                ## withHypr = true;
                withX11 = true;
                # withKDE = true; # KDE Wayland
                # watch = true;
                # userName = "${username}";  # run as a systemd service in user
                serviceMode = "system"; # replace with "user" on wayland
                # deviceName = "Lenovo Lenovo USB-A Unified Pairing Receiver";
                config = {
                  keymap = [
                    {
                      name = "Global";
                      exact_match = true;
                      remap = {
                        # sudo showkey
                        # keylist: https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L26-L572
                        "KEY_BACKSLASH" = "KEY_RIGHTALT-KEY_2"; # *' -> "@"
                        "KEY_RIGHTALT-KEY_2" = "KEY_BACKSLASH"; # ALT_GR+2 -> "'"
                        "KEY_RIGHTSHIFT-KEY_4" = "KEY_RIGHTALT-KEY_4"; # Shift+4 -> $

                        "C-M-a" = "KEY_PREVIOUSSONG";
                        "C-M-s" = "KEY_PLAYPAUSE";
                        "C-M-d" = "KEY_NEXTSONG";
                        "C-M-z" = "KEY_VOLUMEDOWN";
                        "C-M-x" = "KEY_VOLUMEUP";
                        "C-M-KEY_102ND" = "KEY_MUTE"; # <>

                        "M-KEY_7" = "KEY_EQUAL"; # \
                        "M-KEY_RIGHTSHIFT-KEY_7" = "KEY_GRAVE"; # |

                        "M-KEY_RIGHTSHIFT-KEY_8" = "KEY_RIGHTALT-KEY_7"; # {
                        "M-KEY_RIGHTSHIFT-KEY_9" = "KEY_RIGHTALT-KEY_0"; # }

                        "KEY_COMPOSE" = "KEY_RESERVED"; # Disable context menu keyboard button
                      };
                    }
                  ];
                  # other xremap settings go here
                };
              };
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit hostname username; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = {
                imports = [
                  ./home.nix
                ];
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
    xremap-flake.url = "github:xremap/nix-flake";
  };
}
