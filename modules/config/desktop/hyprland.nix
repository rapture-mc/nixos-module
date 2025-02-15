{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.config.hyprland;

  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.megacorp.config.hyprland = {
    enable = mkEnableOption "Whether to enable hyprland";
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      (callPackage ./sddm-theme.nix {}).sddm-sugar-candy-theme
      libsForQt5.qt5.qtgraphicaleffects
    ];

    services.displayManager.sddm = {
      enable = true;
      theme = "sugar-candy";
      wayland.enable = true;
    };
  };
}
