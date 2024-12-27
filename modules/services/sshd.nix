{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.sshd;
in {
  options.megacorp.services.sshd = with lib; {
    bastion = {
      enable = mkEnableOption "Whether to configure as a bastion server";
      logo = mkEnableOption "Whether to show bastion logo on shell startup";
    };

    authorized-ssh-keys = mkOption {
      type = types.listOf types.singleLineStr;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzlYmoWjZYFeCNdMBCHBXmqpzK1IBmRiB3hNlsgEtre benny@MC-BH-01"
      ];
      description = "List of authorized ssh keys for the admin user";
    };
  };

  config = {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication =
          if cfg.bastion.enable
          then true
          else false;
        PermitRootLogin = "no";
      };
    };

    # Authorized SSH keys
    users.users.${config.megacorp.config.users.admin-user}.openssh.authorizedKeys.keys = cfg.authorized-ssh-keys;

    # Required for oh-my-tmux ssh sessions to work correctly
    programs.ssh.extraConfig = "SetEnv TERM=screen-256color";
  };
}
