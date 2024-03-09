{ config, ... }:

{
  time.timeZone = "${config.configOptions.timezone}";
  i18n = {
    defaultLocale = "${config.configOptions.defaultLocale}";
    extraLocaleSettings = {
      LC_CTYPE = "${config.configOptions.defaultLocale}";
      LC_COLLATE = "${config.configOptions.defaultLocale}";
      LC_MESSAGES = "${config.configOptions.defaultLocale}";

      LC_ADDRESS = "${config.configOptions.extraLocale}";
      LC_IDENTIFICATION = "${config.configOptions.extraLocale}";
      LC_MEASUREMENT = "${config.configOptions.extraLocale}";
      LC_MONETARY = "${config.configOptions.extraLocale}";
      LC_NAME = "${config.configOptions.extraLocale}";
      LC_NUMERIC = "${config.configOptions.extraLocale}";
      LC_PAPER = "${config.configOptions.extraLocale}";
      LC_TELEPHONE = "${config.configOptions.extraLocale}";
      LC_TIME = "${config.configOptions.extraLocale}";
    };
  };
}
