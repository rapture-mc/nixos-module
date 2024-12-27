{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.virtualisation.guest;
in {
  options.megacorp.virtualisation.guest = with lib; {
    virtualbox.enable = mkEnableOption "Enable Virtualbox guest additionns";

    vmware.enable = mkEnableOption "Enable VMWare guest additionns";

    qemuConsole.enable = mkEnableOption "Enable qemu console access";
  };

  config = {
    virtualisation = {
      virtualbox.guest.enable =
        if cfg.virtualbox.enable
        then true
        else false;

      vmware.guest.enable =
        if cfg.vmware.enable
        then true
        else false;
    };

    systemd.services."serial-getty@ttyS0" = lib.mkIf cfg.qemuConsole.enable {
      enable = true;
      wantedBy = ["multi-user.target"];
    };
  };
}
