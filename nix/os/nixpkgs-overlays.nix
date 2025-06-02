config: inputs: final: prev:
let
  # https://github.com/NixOS/nixpkgs/pull/412571
  unstable-small = import inputs.nixpkgs-unstable-small {
    system = prev.system;
    config = prev.config;
  };

  zen-browser-pkg = inputs.zen-browser.packages.${prev.system}.default;
in
prev
  // {
  # https://nixpk.gs/pr-tracker.html?pr=

  # https://github.com/NixOS/nixpkgs/issues/309056#issuecomment-2366801752
  vivaldi = unstable-small.vivaldi.overrideAttrs (oldAttrs: {
    dontWrapQtApps = false;
    dontPatchELF = true;
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.kdePackages.wrapQtAppsHook ];
  });

  python312Packages = prev.python312Packages // {
    mitmproxy = prev.python312Packages.mitmproxy.overrideAttrs (oldAttrs: rec {
      pythonRelaxDeps = oldAttrs.pythonRelaxDeps or [ ] ++ [
        "pyparsing"
        "ruamel.yaml"
      ];
    });
  };

  # thanks https://r.je/evict-your-darlings
  # avoid .mozilla folder in ~/
  firefox = prev.firefox.overrideAttrs (oldAttrs: {
    buildCommand =
      oldAttrs.buildCommand
      + ''
        wrapProgram "$executablePath" \
          --set 'HOME' '${config.user-config.home}/.config/mozilla'
      '';
  });

  # avoid .zen folder in ~/
  zen-browser = zen-browser-pkg.overrideAttrs (oldAttrs: {
    buildCommand =
      oldAttrs.buildCommand
      + ''
        wrapProgram "$executablePath" \
          --set 'HOME' '${config.user-config.home}/.config/zen'
      '';
  });
}
