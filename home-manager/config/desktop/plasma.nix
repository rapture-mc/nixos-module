{
  pkgs,
  ...
}: let
cyberpunk-theme = pkgs.stdenv.mkDerivation {
  name = "theme";

  src = pkgs.fetchFromGitHub {
    owner = "Roboron3042";
    repo = "Cyberpunk-Neon";
    rev = "eb7595459c0d4164262e0ccaf8d6e5c1936a6f67";
    sha256 = "sha256-whHBIxEGGvTPVUaE/HQDb/Qyl5sPMGlOmofgNCBaNng=";
  };

  installPhase = ''
    mkdir $out

    cp -rv $src/kde/cyberpunk-neon.colors $out
  '';
};
in {
  home.file."cyberpunk-theme" = {
    enable = true;
    source = "${cyberpunk-theme}/cyberpunk-neon.colors";
    target = ".local/share/color-schemes/cyberpunk-neon.colors";
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ./desktop-wallpaper.jpg;
      colorScheme = "cyberpunk-neon";
    };
    input.touchpads = [
      {
        naturalScroll = true;
        vendorId = "04f3";
        productId = "0080";
        name = "Elan Touchpad";
      }
    ];
    panels = [
      {
        location = "left";
        opacity = "opaque";
        screen = "all";
      }
    ];
  };
}
