config: inputs: final: prev:
prev
  // {
  vivaldi = import ./vivaldi config inputs final prev;
  firefox = import ./firefox config inputs final prev;
  zen-browser = import ./zen-browser config inputs final prev;
  pnpm = import ./pnpm config inputs final prev;
}
