{config, ...}: let
  cfg = config.megacorp.config;
in {
  imports = [
    ./desktop.nix
    ./hyprland.nix
    (if cfg.desktop.enable || cfg.hyprland.enable then ./shared.nix else ./none.nix)
  ];
}
