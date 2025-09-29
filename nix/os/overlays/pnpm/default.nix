config: inputs: final: prev:
let
  version = "10.17.1";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-oeATP2gBwTA5rkEwnl5afRBYo6Hh7dAgpJRKg8U2jQQ=";
    # hash = "";
  };
})
