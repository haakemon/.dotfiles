{ config, pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
      webInterface = false;
      cups-pdf.enable = true;
      drivers = [ pkgs.gutenprint ];
      cups-pdf.instances = {
        pdf = {
          settings = {
            Out = "\${HOME}/Documents";
          };
        };
      };
    };
  };
}
