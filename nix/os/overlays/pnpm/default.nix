config: inputs: final: prev:
let
  version = "10.23.0";
in
prev.pnpm.overrideAttrs (oldAttrs: {
  inherit version;
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-${version}.tgz";
    hash = "sha256-oc3XtGg4ap14oIHaBdYEnX5ZjbYqKZ25LfIacGKksYM=";
    # hash = "";
  };
})
