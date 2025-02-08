{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.hardening.bootloader;
in {
  options.megacorp.hardening.bootloader = with lib; {
    enable = mkEnableOption ''
      Whether to enable bootloader hardening.

      This will lock down grub so that any operation except for selecting the default grub entry will require a password.
    '';

    password-file = mkOption {
      type = types.str;
      default = "/run/secrets/grub-admin-password";
      description = ''
        The path to the hashed password file for the grub admin user.
        Password is hashed because /boot/grub/grub.cfg is readable by anyone.

        Use "grub-mkpasswd-pbkdf2" (available in the grub2 package) to generate the password.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub.users.${config.megacorp.config.users.admin-user}.hashedPasswordFile = cfg.password-file;
  };
}
