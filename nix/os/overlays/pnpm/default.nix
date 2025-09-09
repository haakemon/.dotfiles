config: inputs: final: prev:
prev.pnpm.overrideAttrs (oldAttrs: {
  version = "10.15.1";
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-10.15.1.tgz";
    hash = "sha256-jFOvAq4+wfsK51N3+NTWIXwtfL5vA8FjUMq/dJPebv8=";
  };
})
