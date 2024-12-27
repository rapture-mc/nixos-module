{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.deploy-rs;
in {
  options.megacorp.services.deploy-rs = with lib; {
    agent.enable = mkEnableOption "Enable deploy-rs agent";

    server = {
      enable = mkEnableOption "Enable deploy-rs server";

      logo = mkEnableOption "Whether to show deploy-rs logo on shell startup";

      public-key = mkOption {
        type = types.listOf types.str;
        default = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBbY2IFwCtrP1KZjL7D+fNA4kBKnkydS17oIJL9VxAl benny@MGC-DRS-02"];
        description = "The public SSH key for the deploy server user";
      };
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.server.enable [pkgs.deploy-rs];

    users.users.deploy = lib.mkIf cfg.agent.enable {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = cfg.server.public-key;
    };

    security.sudo.extraRules = lib.mkIf cfg.agent.enable [
      {
        users = ["deploy"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
