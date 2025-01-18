{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.desktop;
in {
  imports = [
    ./desktop-shared.nix
  ];

  options.megacorp.config.desktop = with lib; {
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

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        displayManager.${cfg.display-manager}.enable = true;
        desktopManager.${cfg.desktop-manager}.enable = true;
        xkb.layout = "au";
      };

      xrdp = lib.mkIf cfg.xrdp {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "${cfg.desktop-manager}-session";
      };
    };
  };
}
