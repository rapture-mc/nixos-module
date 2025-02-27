{osConfig, ...}: {
  imports = [
    ./config/desktop/applications.nix
    ./programs/btop.nix
    ./programs/kitty.nix
    ./programs/ranger.nix
    ./programs/tmux.nix
    ./programs/nushell.nix
    ./programs/zsh.nix
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
