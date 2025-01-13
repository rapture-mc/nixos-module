{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.whonix;

  pname = "UnstoppableSwap";
  version = "1.0.0-rc.11";

  src = pkgs.fetchurl {
    url = "https://github.com/UnstoppableSwap/core/releases/download/${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-ot9yHm2mUaFJL9G80T6VhzYrpRmoSR9wUL79tnZiuyA=";
  };
in {
  options.megacorp.virtualisation.whonix = with lib; {
    enable = mkEnableOption "Enable Whonix Gateway and Workstation VMs";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    environment.systemPackages = lib.mkIf config.megacorp.virtualisation.whonix.enable [
      (pkgs.appimageTools.wrapType2 {
        inherit pname version src;
      })
      pkgs.electrum
      pkgs.monero-gui
    ];
  };
}
