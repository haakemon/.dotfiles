config: inputs: final: prev:
let
  zen-browser-pkg = inputs.zen-browser.packages.${prev.system}.default;
in
# avoid .zen folder in ~/
zen-browser-pkg.overrideAttrs (oldAttrs: {
  buildCommand =
    oldAttrs.buildCommand
    + ''
      wrapProgram "$executablePath" \
        --set 'HOME' '${config.user-config.home}/.config/zen'
    '';
})
