{config, ... }: {
  imports = [
    ./desktop.nix
    ./hyprland.nix
    (
      if config.megacorp.config.desktop.display-manager
      == "sddm"
      && config.megacorp.config.desktop.enable
        && !config.megacorp.config.hyprland.enable
      then ./sddm.nix
      else ./none.nix
    )
  ];
}
