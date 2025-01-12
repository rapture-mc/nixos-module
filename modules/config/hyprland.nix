{
  lib,
  config,
  pkgs,
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
    programs = {
      hyprland.enable = true;
    };

    services.displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
      wayland.enable = true;
    };

    environment.systemPackages = [pkgs.where-is-my-sddm-theme];
  };
}
