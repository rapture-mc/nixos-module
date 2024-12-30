{pkgs, config, lib, ...}:
let
  pname = "UnstoppableSwap";
  version = "1.0.0-rc.11";

  src = pkgs.fetchurl {
    url = "https://github.com/UnstoppableSwap/core/releases/download/${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-ot9yHm2mUaFJL9G80T6VhzYrpRmoSR9wUL79tnZiuyA=";
  };

  StartWhonix = pkgs.writeShellScriptBin "StartWhonix" ''
    VBoxManage startvm Whonix-Gateway-Xfce --type headless

    sleep 1

    VBoxManage startvm Whonix-Workstation-Xfce
  '';

  StopWhonix = pkgs.writeShellScriptBin "StopWhonix" ''
    VBoxManage controlvm Whonix-Workstation-Xfce poweroff

    VBoxManage controlvm Whonix-Gateway-Xfce poweroff
  '';
in
{
  environment.systemPackages = lib.mkIf config.megacorp.virtualisation.whonix.enable [
    (pkgs.appimageTools.wrapType2 {
      inherit pname version src;
    })
    pkgs.electrum
    pkgs.monero-gui
    StartWhonix
    StopWhonix
  ];
}
