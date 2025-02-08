{
  osConfig,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    ;
in {
  dconf.settings = {
    "org/cinnamon/desktop/background" = {
      "picture-uri" = "file://${./desktop-wallpaper.jpg}";
    };
  };

  home.file.logout = mkIf osConfig.megacorp.config.desktop.xrdp {
    enable = true;
    executable = true;
    target = "Desktop/Logout.desktop";
    text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Exec=/run/current-system/sw/bin/cinnamon-session-quit --logout --force
      Name=Logout
      Comment=To log out of the desktop
      Icon=${./logout.png}
    '';
  };
}
