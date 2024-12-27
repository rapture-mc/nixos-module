{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.hypervisor;
in {
  options.megacorp.virtualisation.hypervisor = with lib; {
    enable = mkEnableOption "Enable Libvirt hypervisor";

    logo = mkEnableOption "Whether to show hypervisor logo on shell startup";

    libvirt-users = mkOption {
      type = types.listOf types.str;
      default = ["${config.megacorp.config.users.admin-user}"];
      description = "A list of users who will have access to the libvirt API";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.libvirtd.members = cfg.libvirt-users;

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
      qemu.ovmf.enable = true;
    };

    environment.sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    environment.systemPackages = with pkgs; [
      libxslt
      opentofu
      packer
      virt-manager
    ];
  };
}
