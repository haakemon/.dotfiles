{ ... }:
let
  inherit (import ./options.nix)
    timezone
    defaultLocale
    extraLocale;
in
{
  time.timeZone = "${timezone}";
  i18n = {
    defaultLocale = "${defaultLocale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${extraLocale}";
      LC_IDENTIFICATION = "${extraLocale}";
      LC_MEASUREMENT = "${extraLocale}";
      LC_MONETARY = "${extraLocale}";
      LC_NAME = "${extraLocale}";
      LC_NUMERIC = "${extraLocale}";
      LC_PAPER = "${extraLocale}";
      LC_TELEPHONE = "${extraLocale}";
      LC_TIME = "${extraLocale}";
    };
  };
}
