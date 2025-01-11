{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs; {
  environment.systemPackages = lib.mkIf (config.megacorp.config.desktop.enable || config.megacorp.config.hyprland.enable) [
    chromium
    firefox
    keepassxc
    libreoffice
    networkmanager
    remmina
    shutter
    thunderbird
    vlc
  ];
}
