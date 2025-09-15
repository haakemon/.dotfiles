config: inputs: final: prev:
prev.pnpm.overrideAttrs (oldAttrs: {
  version = "10.16.1";
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-10.16.1.tgz";
    hash = "sha256-t36Sug1ZpjcrbFBBu7P4ZvuF6SffMzgn8Mf1d8XhpxM=";
  };
})
