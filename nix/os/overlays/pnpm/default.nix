config: inputs: final: prev:
let
  version = "10.22.0";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-BTqEk+jjKKPG1/9csHm+8ocZFSzPgx5GZrXAMyt3u4g=";
    # hash = "";
  };
})
