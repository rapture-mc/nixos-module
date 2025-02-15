{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.virtualisation.hypervisor;

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    mkForce
    types
    ;
in {
  options.megacorp.virtualisation.hypervisor = {
    enable = mkEnableOption ''
      Enable Libvirt hypervisor.

      Also setup a static IP and bridge interface with megacorp.config.networking.static-ip option.
    '';

    logo = mkEnableOption "Whether to show hypervisor logo on shell startup";

    libvirt-users = mkOption {
      type = types.listOf types.str;
      default = ["${config.megacorp.config.users.admin-user}"];
      description = "A list of users who will have access to the libvirt API";
    };
  };

  config = mkIf cfg.enable {
    # We want to use systemd-networkd instead of NetworkManager for a hypervisor setup
    networking.networkmanager.enable = mkForce false;
    systemd.network.enable = true;

    users.groups.libvirtd.members = cfg.libvirt-users;

    services.earlyoom.enable = true;

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
