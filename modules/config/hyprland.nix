{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.hyprland;
in {

  imports = [
    ./desktop-shared.nix
  ];

  options.megacorp.config.hyprland = with lib; {
    enable = mkEnableOption "Whether to enable hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = lib.mkIf cfg.hyprland.enable {
      enable = true;
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    programs.hyprland.enable = true;
  };
}
