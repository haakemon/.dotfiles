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
  version = "95afa163a60167cd97bf6afa870bc117a1be3d03";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = version;
    sha256 = "sha256-cUlTHg/F0tUpjS/uAIYKwrIRaKwuzdyFo3IiST6E7Fc=";
  };

  cargoSha256 = "sha256-cGMVxSWXj6rhjLB/US4PEjuPBheypD3pgDCHaAgosyc=";

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
