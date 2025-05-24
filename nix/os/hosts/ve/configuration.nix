{ config
, lib
, pkgs
, ...
}:

{
  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  imports = [
    ./user-config.nix
    ../../modules/sops.nix
  ];

  environment.packages = [
    pkgs.nano
    pkgs.croc
    pkgs.which
    pkgs.git
    pkgs.zsh
    pkgs.openssh
    pkgs.fastfetch
    pkgs.eza
    pkgs.bat
    pkgs.zsh-powerlevel10k
    pkgs.onefetch
    pkgs.pre-commit
    pkgs.nixpkgs-fmt # formatting .nix files
    pkgs.nixfmt-rfc-style # formatting .nix files
    pkgs.gcc # requirement for pre-commit nixpkgs-fmt
    pkgs.rustup # requirement for pre-commit nixpkgs-fmt
    pkgs.zoxide
  ];

  environment.etcBackupExtension = ".bak";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  user.shell = "${pkgs.zsh}/bin/zsh";

  time.timeZone = "Europe/Oslo";

  terminal.font = "${
    pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; }
  }/share/fonts/truetype/NerdFonts/VictorMonoNerdFont-Regular.ttf";

  # Configure home-manager
  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };
}
