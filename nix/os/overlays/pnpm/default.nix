config: inputs: final: prev:
let
  version = "10.18.3";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-eX0AWbxfwzVtecaBYVoTfHs15O/AOkRJqKGr/LzEvcc=";
    # hash = "";
  };
})
