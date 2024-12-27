{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.zabbix;
in {
  options.megacorp.services.zabbix = with lib; {
    server = {
      enable = mkEnableOption "Whether to enable Zabbix server (also enables web server)";
      reverse-proxied = mkEnableOption "Whether Zabbix is served behind a reverse proxy";

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
          The fqdn of your Zabbix instance.
          NOTE: Don't include "https://" (this is prepended to the value)
        '';
      };
    };

    agent = {
      enable = mkEnableOption "Whether to enable the Zabbix agent";
    };
  };

  config = {
    networking.firewall.allowedTCPPorts =
      (lib.mkIf cfg.server.enable
        [
          80
        ])
      ++ (
        if !cfg.server.reverse-proxied
        then [443]
        else []
      );

    security.acme = lib.mkIf (!cfg.server.reverse-proxied) {
      acceptTerms = true;
      defaults.email = "${cfg.server.tls-email}";
    };

    services = {
      zabbixServer = lib.mkIf cfg.server.enable {
        enable = true;
        openFirewall = true;
      };

      zabbixWeb = lib.mkIf (!cfg.server.reverse-proxied) {
        enable = cfg.server.enable;
        hostname = cfg.server.fqdn;
        frontend = "nginx";
        nginx.virtualHost = {
          forceSSL = true;
          enableACME = true;
        };
      };

      zabbixAgent = lib.mkIf cfg.agent.enable {
        enable = true;
        openFirewall = true;
        server =
          if cfg.server.enable
          then "127.0.0.1"
          else cfg.server.fqdn;
      };
    };
  };
}
