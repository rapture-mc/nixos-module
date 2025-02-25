{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.keycloak;

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.services.keycloak = {
    enable = mkEnableOption "Enable keycloak";

    domain = mkOption {
      type = types.str;
      default = "localhost";
      description = "The domain name that keycloak will be deployed in";
    };
  };

  config = mkIf cfg.enable {
    services = {
      keycloak = {
        enable = true;
        initialAdminPassword = "changeme";
        settings = {
          hostname = cfg.fqdn;
          http-port = 8300;
        };
        database.passwordFile = "/run/secrets/keycloak-db-password";
      };
    };

    networking.firewall.allowedTCPPorts = [8300];
  };
}
