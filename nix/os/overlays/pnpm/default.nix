config: inputs: final: prev:
let
  version = "10.17.0";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-vZ7FQXZBOR4KyzkSspEr1bA4VAeoLalHRKdAe1Z/208=";
    # hash = "";
  };
})
