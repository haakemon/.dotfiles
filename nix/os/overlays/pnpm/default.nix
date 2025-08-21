config: inputs: final: prev:
prev.pnpm.overrideAttrs (oldAttrs: {
  version = "10.15.0";
  src = prev.fetchurl {
    url = "https://registry.npmjs.org/pnpm/-/pnpm-10.15.0.tgz";
    hash = "sha256-hMGeeI19fuJI5Ka3FS+Ou6D0/nOApfRDyhfXbAMAUtI=";
  };
})
