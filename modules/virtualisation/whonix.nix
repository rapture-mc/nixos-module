{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.whonix;

  ova = pkgs.fetchurl {
    url = "https://download.whonix.org/ova/${cfg.version}/Whonix-Xfce-${cfg.version}.ova";
    hash = "${cfg.hash}";
  };
in {
  options.megacorp.virtualisation.whonix = with lib; {
    enable = mkEnableOption "Enable Whonix Gateway and Workstation VMs";

    version = mkOption {
      type = types.str;
      default = "17.2.3.7";
      description = "Whonix Version to download";
    };

    hash = mkOption {
      type = types.str;
      default = "sha256-rTMax0Dc9fWNZUxu0gGFK/E5Rsg43eetB8mmsj+MxB0=";
      description = "Whonix Version hash";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    systemd.services."deploy-whonix-virtualbox" = {
      enable = true;
      serviceConfig = {
        User = "${config.megacorp.config.users.admin-user}";
      };
      script = ''
        if ! ${pkgs.virtualbox}/bin/VBoxManage list vms | grep -q "Whonix"; then
          echo "Whonix VMs don't exist, importing..."
          ${pkgs.virtualbox}/bin/VBoxManage import ${ova} --vsys 0 --eula accept --vsys 1 --eula accept
        else
          echo "Whonix VMs already exist, skipping..."
        fi
      '';
    };
  };
}
