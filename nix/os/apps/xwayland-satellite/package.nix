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
  version = "5e7f2df05e0e0307e7b0fcebd24194a09f8d2567";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-L5jOU34bPf/BqsuDZK1JzVgBWwgzFm0auPYkZ6RjB0k=";
  };

  cargoSha256 = "sha256-631l9iV83sgnY+kkaXnTYOLeBShs4r73wEmPb73TCfM=";

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
