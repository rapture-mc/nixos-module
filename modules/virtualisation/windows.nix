{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.windows;
in {
  options.megacorp.virtualisation.windows = with lib; {
    enable = mkEnableOption "Enable ability to create Windows VM using Vagrant and Virtualbox";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    environment.systemPackages = with pkgs; [
      vagrant
    ];
  };
}
