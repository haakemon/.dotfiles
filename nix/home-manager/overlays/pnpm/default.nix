config: inputs: final: prev:
let
  version = "11.3.0";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-Wt4e9RzzZEH0oAkx6vkANlRonro2hJOfcNdXay37hHQ=";
    # hash = "";
  };
})
