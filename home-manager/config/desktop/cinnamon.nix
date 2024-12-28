{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/cinnamon/desktop/background" = {
      "picture-uri" = "file://${./desktop-wallpaper.jpg}";
    };
  };

  home.file.logout = lib.mkIf osConfig.megacorp.config.desktop.xrdp {
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

  xdg.desktopEntries = {
    UnstoppableSwap = lib.mkIf osConfig.megacorp.virtualisation.whonix.enable {
      name = "UnstoppableSwap";
      genericName = "XMR Swap";
      exec = "UnstoppableSwap";
      terminal = false;
      icon = ./unstoppable-swap.svg;
    };

    StartWhonix = lib.mkIf osConfig.megacorp.virtualisation.whonix.enable {
      name = "Start Whonix";
      exec = ''
        sh -c "${pkgs.virtualbox}/bin/VBoxManage startvm Whonix-Gateway-Xfce --type headless && sleep 1 && ${pkgs.virtualbox}/bin/VBoxManage startvm Whonix-Workstation-Xfce"
        '';
      terminal = true;
      icon = ./whonix.svg;
    };
  };
}
