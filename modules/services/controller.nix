{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.controller;
in {
  options.megacorp.services.controller = with lib; {
    agent.enable = mkEnableOption "Enable controller agent component";

    server = {
      enable = mkEnableOption "Enable controller server component";

      logo = mkEnableOption "Whether to show controller logo on shell startup";

      public-key = mkOption {
        type = types.listOf types.str;
        default = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBbY2IFwCtrP1KZjL7D+fNA4kBKnkydS17oIJL9VxAl benny@MGC-DRS-02"];
        description = "The public SSH key for the controller server user";
      };
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.server.enable [pkgs.deploy-rs];

    users.users.controller = lib.mkIf cfg.agent.enable {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = cfg.server.public-key;
    };

    security.sudo.extraRules = lib.mkIf cfg.agent.enable [
      {
        users = ["controller"];
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
