{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.megacorp.config.desktop;

  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  imports = [
    ./shared.nix
  ];

  options.megacorp.config.desktop = {
    enable = mkEnableOption "Whether to enable desktop environment";

    xrdp = mkEnableOption "Whether to enable RDP server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./sddm-astronaut-theme.nix {
        theme = "cyberpunk";
        themeConfig.General = {
          Background = "${../../../home-manager/config/desktop/desktop-wallpaper.jpg}";
          HeaderText = "System Locked...";
          DateFormat = "dd/M";
        };
      })
    ];

    services = {
      displayManager.sddm = {
        enable = true;
        theme = "sddm-astronaut-theme";
        extraPackages = [
          pkgs.kdePackages.qtmultimedia
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtvirtualkeyboard
        ];
      };
      desktopManager.plasma6.enable = true;
      xserver.xkb.layout = "au";
    };

    xrdp = mkIf cfg.xrdp {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "startplasma-x11";
    };
  };
}
