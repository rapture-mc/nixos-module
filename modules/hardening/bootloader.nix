{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.hardening.bootloader;
in {
  options.megacorp.config.bootloader = with lib; {
    enable = mkEnableOption ''
      Whether to enable bootloader hardening.

      This will lock down grub so that any operation except for selecting the default grub entry will require a password.
    '';

    password-file = mkOption {
      type = types.str;
      default = "/run/secrets/grub-admin-password";
      description = "The path to the file containing the grub admin password";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub.users.${config.megacorp.config.users.admin-user}.passwordFile = cfg.password-file;
  };
}
