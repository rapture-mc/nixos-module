{osConfig, ...}: let
  cfg = osConfig.megacorp.config;
in {
  imports = [
    ./config/desktop/applications.nix
    ./programs/btop.nix
    ./programs/kitty.nix
    ./programs/ranger.nix
    ./programs/tmux.nix
    (
      if cfg.users.shell == "nushell"
      then ./programs/nushell.nix
      else ./programs/zsh.nix
    )
    (
      if
        osConfig.megacorp.config.desktop.desktop-manager
        == "cinnamon"
        && osConfig.megacorp.config.desktop.enable
        && !osConfig.megacorp.config.hyprland.enable
      then ./config/desktop/cinnamon.nix
      else ./config/desktop/none.nix
    )
    (
      if osConfig.megacorp.config.hyprland.enable
      then ./config/desktop/hyprland.nix
      else ./config/desktop/none.nix
    )
  ];

  home.stateVersion = osConfig.system.stateVersion;

  programs.home-manager.enable = true;
}
