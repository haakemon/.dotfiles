config: inputs: final: prev:
prev
  // {
  vivaldi = import ./overlays/vivaldi config inputs final prev;
  firefox = import ./overlays/firefox config inputs final prev;
  zen-browser = import ./overlays/zen-browser config inputs final prev;
  spotify-player = import ./overlays/spotify-player config inputs final prev;
}
