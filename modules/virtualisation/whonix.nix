{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.whonix;

  version = "17.2.3.7";

  hash = "sha256-rTMax0Dc9fWNZUxu0gGFK/E5Rsg43eetB8mmsj+MxB0=";

  ova = pkgs.fetchurl {
    url = "https://download.whonix.org/ova/${version}/Whonix-Xfce-${version}.ova";
    hash = "${hash}";
  };

  installWhonix = pkgs.writeShellScriptBin "installWhonix" ''
    if ! VBoxManage list vms | grep -q "Whonix"; then
      echo "Whonix VMs don't exist, importing..."
      VBoxManage import ${ova} --vsys 0 --eula accept --vsys 1 --eula accept
    else
      echo "Whonix VMs already exist, skipping..."
      exit 1
    fi
  '';
in {
  options.megacorp.virtualisation.whonix = with lib; {
    enable = mkEnableOption "Enable Whonix Gateway and Workstation VMs";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    environment.systemPackages = [installWhonix];
  };
}
