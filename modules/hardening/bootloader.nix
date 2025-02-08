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

    hashedPasswordFile = mkOption {
      type = types.str;
      default = "/run/secrets/grub-admin-password";
      description = ''
        The path to the file containing the hashed password for the grub admin password.

        Generate using "grub-mkpasswd-pbkdf2".
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub.users.${config.megacorp.config.users.admin-user}.hashedPasswordFile = cfg.hashedPasswordFile;
  };
}
