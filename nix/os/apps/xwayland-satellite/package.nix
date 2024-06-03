{ lib
, rustPlatform
, fetchFromGitHub
, clang
, llvmPackages
, xcb-util-cursor
, xorg
, glibc
, libclang
, musl
, xwayland
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "02bee5aea7d4e95abad5c6792f6caab1190a1e68";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-zdQwzUzaTx/+OIo6hHbi2GwhGFAbsogqWVKfy2H3Mro=";
  };

  cargoSha256 = "sha256-o4BkKIRRTz6SQqb2QNW6dZh0Gg/WbTesa1bdP0D6XDs=";

  doCheck = false;

  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages.libclang.lib ];
  BINDGEN_EXTRA_CLANG_ARGS =
    (builtins.map (a: ''-I"${a}/include"'') [
      xcb-util-cursor.dev
      xorg.libxcb.dev
      musl.dev
    ])
    ++ [
      ''-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include''
    ];

  buildInputs = [
    xcb-util-cursor
    clang
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/xwayland-satellite \
      --prefix PATH : "${lib.makeBinPath [ xwayland ]}"
  '';

  meta = with lib; {
    description = "Xwayland outside your Wayland";
    license = licenses.mpl20;
    homepage = src.meta.homepage;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gabby ];
  };
}
