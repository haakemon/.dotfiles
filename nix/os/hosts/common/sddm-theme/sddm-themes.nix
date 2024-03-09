{ stdenv, fetchFromGitHub }:
{
  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };

  sddm-vivid-dark = stdenv.mkDerivation rec {
    pname = "sddm-vivid-dark-theme";
    version = "f00d8c5beb830dba187a976630abae7600431931";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR "$src/Vivid SDDM Themes/Vivid-SDDM" $out/share/sddm/themes/vivid-dark
    '';
    src = fetchFromGitHub {
      owner = "L4ki";
      repo = "Vivid-Plasma-Themes";
      rev = "${version}";
      sha256 = "sha256-BvgwZHmZYsKkqwrwTUuOwWRX7Poe6XtfwigBxlCtAGk=";
      deepClone = true;
    };
  };
}
