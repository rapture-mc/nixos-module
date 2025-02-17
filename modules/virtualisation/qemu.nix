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
  options.megacorp.virtualisation.qemu-guest = {
    enable = mkEnableOption "Enable qemu-guest components";
  };

  config = mkIf cfg.enable {
    imports = [
      "${toString modulesPath}/profiles/qemu-guest.nix"
    ];

    boot.kernelParams = ["console=ttyS0"];
  };
}
