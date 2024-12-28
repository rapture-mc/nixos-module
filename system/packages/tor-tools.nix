{pkgs, config, lib, ...}:
let
  pname = "UnstoppableSwap";
  version = "1.0.0-rc.11";

  src = pkgs.fetchurl {
    url = "https://github.com/UnstoppableSwap/core/releases/download/${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-ot9yHm2mUaFJL9G80T6VhzYrpRmoSR9wUL79tnZiuyA=";
  };

  StartWhonix = pkgs.writeShellScriptBin "StartWhonix" ''
    whoami
    ${pkgs.virtualbox}/bin/VBoxManage list vms

    ${pkgs.virtualbox}/bin/VBoxManage startvm Whonix-Gateway-Xfce --type headless

    sleep 1

    ${pkgs.virtualbox}/bin/VBoxManage startvm Whonix-Workstation-Xfce
  '';
in
{
  environment.systemPackages = lib.mkIf config.megacorp.virtualisation.whonix.enable [
    (pkgs.appimageTools.wrapType2 {
      inherit pname version src;
    })
    pkgs.monero-gui 
    pkgs.electrum
    StartWhonix
  ];
}
