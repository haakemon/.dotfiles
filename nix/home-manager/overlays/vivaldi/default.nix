config: inputs: final: prev:
let
  # https://github.com/NixOS/nixpkgs/pull/412571
  unstable-small = import inputs.nixpkgs-unstable-small {
    system = prev.system;
    config = prev.config;
  };
in
# https://github.com/NixOS/nixpkgs/issues/309056#issuecomment-2366801752
(unstable-small.vivaldi.override {
  proprietaryCodecs = true;
  enableWidevine = true;
}).overrideAttrs (oldAttrs: {
  dontWrapQtApps = false;
  dontPatchELF = true;
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.kdePackages.wrapQtAppsHook ];
})
