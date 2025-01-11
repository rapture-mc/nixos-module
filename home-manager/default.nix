{osConfig, ...}: {
  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/kitty.nix
    ./programs/btop.nix
    ./config/desktop/applications.nix

    (
      if
        osConfig.megacorp.config.desktop.desktop-manager
        == "cinnamon"
        && osConfig.megacorp.config.desktop.enable
        && !osConfig.megacorp.config.desktop.hyprland.enable
      then ./config/desktop/cinnamon.nix
      else ./config/desktop/none.nix
    )
  ];

  home.stateVersion = "${osConfig.megacorp.config.system.state-version}";

  programs.home-manager.enable = true;
}
