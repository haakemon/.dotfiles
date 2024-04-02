{ lib
, rustPlatform
, fetchFromGitHub
, makeDesktopItem
, gitbutler-ui
, copyDesktopItems
, wrapGAppsHook
, pkg-config
, perl
, jq
, moreutils
, libsoup
, webkitgtk
, glib-networking
, libayatana-appindicator
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "gitbutler";
  inherit (gitbutler-ui) version src;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-context-menu-0.5.0" = "sha256-ftvGrJoQ4YHVYyrCBiiAQCQngM5Em15VRllqSgHHjxQ=";
      "tauri-plugin-single-instance-0.0.0" = "sha256-xJd1kMCnSlTy/XwPWAtYPBsUFIW9AiBFgnmWQ3BpFeo=";
    };
  };

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook pkg-config perl jq moreutils ];

  buildInputs = [ libsoup webkitgtk glib-networking ];

  nativeCheckInputs = [ git ];

  buildAndTestSubdir = "gitbutler-app";

  RUSTC_BOOTSTRAP = 1; # GitButler depends on unstable Rust features.

  RUSTFLAGS = "--cfg tokio_unstable";

  postPatch = ''
    # Use the correct path to the prebuilt UI assets.
    substituteInPlace gitbutler-app/tauri.conf.json \
      --replace-fail '../gitbutler-ui/build' '${gitbutler-ui}'

    # Since `cargo build` is used instead of `tauri build`, configs are merged manually.
    # Disable the updater, as it is not needed for Nixpkgs.
    jq --slurp '.[0] * .[1] | .tauri.updater.active = false' gitbutler-app/tauri.conf.json gitbutler-app/tauri.conf.release.json | sponge gitbutler-app/tauri.conf.json

    # Patch library paths in dependencies.
    substituteInPlace "$cargoDepsCopy"/libappindicator-sys-*/src/lib.rs \
      --replace-fail 'libayatana-appindicator3.so.1' '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  '';

  postInstall = ''
    mv "$out"/bin/{gitbutler-app,'git-butler'}

    for size in 128x128@2x 128x128 32x32; do
      install -DT "gitbutler-app/icons/$size.png" "$out/share/icons/hicolor/$size/apps/gitbutler.png"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gitbutler";
      desktopName = "GitButler";
      genericName = "Git client";
      categories = [ "Development" ];
      comment = "Git client for simultaneous branches";
      exec = "git-butler";
      icon = "gitbutler";
      terminal = false;
      type = "Application";
    })
  ];

  meta = gitbutler-ui.meta // {
    description = "Git client for simultaneous branches on top of your existing workflow";
    mainProgram = "git-butler";
  };
}
