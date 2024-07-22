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
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "3140b7c83e0eade33abd94b1adac6a368db735f9";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-RW++Divwh3BjY5MAR0pS7LftVtyvPsUhSB/l3fS7pUY=";
  };

  cargoSha256 = "sha256-DAvuYC0I1sT7VoB/tZGrzGHDtQ3JoXY8mHHMWKpPNVw=";

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

  nativeBuildInputs = [
    pkg-config
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
