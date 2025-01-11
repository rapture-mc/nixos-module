{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.megacorp.config.desktop;
in {
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

    hyprland.enable = mkEnableOption "Whether to enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = lib.mkIf (!cfg.hyprland.enable) {
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

    programs.hyprland = lib.mkIf cfg.hyprland.enable {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    networking.networkmanager.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["Terminus"];})
        noto-fonts-emoji
      ];
    };

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
