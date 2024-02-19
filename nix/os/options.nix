let
  inherit (import ./options-local.nix)
    username
    hostname
    system
    timezone
    defaultLocale
    extraLocale
    userHome
    gitUsername
    gitEmail
    cpuType
    gpuType
    flakeDir
    flakeHash;
in
{
  username = "${username}";
  hostname = "${hostname}";
  system = "${system}";
  timezone = "${timezone}";
  defaultLocale = "${defaultLocale}";
  extraLocale = "${extraLocale}";
  userHome = "${userHome}";
  gitUsername = "${gitUsername}";
  gitEmail = "${gitEmail}";
  cpuType = "${cpuType}";
  gpuType = "${gpuType}";
  flakeDir = "${flakeDir}";
  flakeHash = "${flakeHash}";
}
