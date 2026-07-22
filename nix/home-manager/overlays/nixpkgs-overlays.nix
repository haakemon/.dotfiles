config: inputs: final: prev:
prev
// {
  worktrunk = inputs.worktrunk.packages.${prev.stdenv.hostPlatform.system}.default;

  vivaldi = import ./vivaldi config inputs final prev;
  firefox = import ./firefox config inputs final prev;
  zen-browser = import ./zen-browser config inputs final prev;
  pnpm = import ./pnpm config inputs final prev;
  orca-slicer = import ./orca-slicer config inputs final prev;
}
