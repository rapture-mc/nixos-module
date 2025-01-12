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
    # services.xserver = {
    #   enable = true;
    #   displayManager.sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #   };
    # };

    security.pam.services.hyprlock = {};

    programs.hyprland.enable = true;
  };
}
