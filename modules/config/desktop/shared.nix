{pkgs, config, lib, ...}: let
  cfg = config.megacorp.config;
  inherit (lib)
    mkIf
    bool
    ;

  desktop-enabled = bool.any [ cfg.desktop.enable cfg.hyprland.enable ];
in {
  config = mkIf desktop-enabled {
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
