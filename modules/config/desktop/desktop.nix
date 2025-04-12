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
    mkOption
    mkIf
    types
    ;
in {
  imports = [
    ./shared.nix
  ];

  options.megacorp.config.desktop = {
    enable = mkEnableOption "Whether to enable desktop environment";

    xrdp = mkEnableOption "Whether to enable RDP server";

    desktop-manager = mkOption {
      type = types.str;
      default = "cinnamon";
      description = "Desktop environment to set";
    };

    display-manager = mkOption {
      type = types.str;
      default = "lightdm";
      description = "Lock screen to set";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./sddm-astronaut-theme.nix {
        theme = "cyberpunk";
      })
    ];

    services = {
      xserver = {
        enable = true;
        displayManager.${cfg.display-manager} = {
          enable = true;
          theme = mkIf (cfg.display-manager == "sddm") "sddm-astronaut-theme";
          extraPackages = mkIf (cfg.display-manager == "sddm") [
            pkgs.qtmultimedia
            pkgs.qtsvg
            pkgs.qtvirtualkeyboard
          ];
        };
        desktopManager.${cfg.desktop-manager}.enable = true;
        xkb.layout = "au";
      };

      xrdp = mkIf cfg.xrdp {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "${cfg.desktop-manager}-session";
      };
    };
  };
}
