{
  config,
  lib,
  modulesPath,
  ...
}: let
  cfg = config.megacorp.virtualisation.qemu-guest;
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  options.megacorp.virtualisation.qemu-guest = {
    enable = mkEnableOption "Enable qemu-guest components";
  };

  config = mkIf cfg.enable {
    virtualisation.qemu.guestAgent.enable = true;

    boot.kernelParams = ["console=ttyS0"];
  };
}
