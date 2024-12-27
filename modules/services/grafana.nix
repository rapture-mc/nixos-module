{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.grafana;
in {
  options.megacorp.services.grafana = with lib; {
    enable = mkEnableOption "Enable Grafana";

    logo = mkEnableOption "Whether to show Grafana logo on shell startup";

    reverse-proxied = mkEnableOption "Whether Grafana is served behind a reverse proxy";

    tls-email = mkOption {
      type = types.str;
      default = "someone@somedomain.com";
      description = ''
        The email to use for automatic SSL certificates
        This email will also get SSL certificate renewal email notifications
      '';
    };

    fqdn = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        The fqdn of your Grafana instance.
        NOTE: Don't include "https://" (this is prepended to the value)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts =
      [
        2342
      ]
      ++ (
        if !cfg.reverse-proxied
        then [80 443]
        else []
      );

    security.acme = lib.mkIf (!cfg.reverse-proxied) {
      acceptTerms = true;
      defaults.email = "${cfg.tls-email}";
    };

    services = {
      # Reads as if not reversed proxied, enable nginx (default), otherwise dont enable nginx
      nginx = lib.mkIf (!cfg.reverse-proxied) {
        enable = true;
        virtualHosts."${cfg.fqdn}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://${config.megacorp.config.networking.static-ip.ipv4}:2342/";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      grafana = {
        enable = true;
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Localhost";
              type = "prometheus";
              url = "http://localhost:9001";
            }
          ];
        };
        settings.server = {
          domain = "${cfg.fqdn}";
          http_port = 2342;
          http_addr = "${config.megacorp.config.networking.static-ip.ipv4}";
        };
      };
    };
  };
}
