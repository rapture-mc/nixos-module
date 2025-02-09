{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.virtualisation.guest;

  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.megacorp.virtualisation.guest = {
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

    systemd.services."serial-getty@ttyS0" = mkIf cfg.qemuConsole.enable {
      enable = true;
      wantedBy = ["multi-user.target"];
    };
  };
}
