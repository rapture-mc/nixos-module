{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.nginx.guacamole;
in {
  options.megacorp.services.nginx.guacamole = with lib; {
    enable = mkEnableOption "Enable Guacamole reverse proxy";

    ipv4 = mkOption {
      type = types.str;
      default = "192.168.1.6";
      description = "The IP of the guacamole instance";
    };

    fqdn = mkOption {
      type = types.str;
      default = "example.com";
      description = ''
        The fqdn of your guacamole instance.
        NOTE: Don't include "https://" (this is prepended to the value)
      '';
    };
  };

  config = {
    services = lib.mkIf cfg.enable {
      nginx.virtualHosts."${cfg.fqdn}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            return = "301 https://${cfg.fqdn}/guacamole";
          };
          "/guacamole/" = {
            proxyPass = "http://${cfg.ipv4}:8080";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_buffering off;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $http_connection;
              access_log off;
            '';
          };
        };
      };
    };
  };
}
