{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.file-browser;
in {
  options.megacorp.services.file-browser = with lib; {
    enable = mkEnableOption "Enable File Browser";

    reverse-proxied = mkEnableOption "Whether File Browser is served behind a reverse proxy";

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
        The fqdn of your File Browser instance.
        NOTE: Don't include "https://" (this is prepended to the value)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.megacorp.config.users.admin-user}.extraGroups = ["docker"];

    environment.systemPackages = [pkgs.lazydocker];

    networking.firewall.allowedTCPPorts =
      [
        8080
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

    # Reads as if not reversed proxied, enable nginx (default), otherwise dont enable nginx
    services.nginx = lib.mkIf (!cfg.reverse-proxied) {
      enable = true;
      virtualHosts."${cfg.fqdn}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
          };
        };
      };
    };

    virtualisation = {
      docker.enable = true;

      arion = {
        backend = "docker";
        projects.file-browser = {
          serviceName = "file-browser";
          settings = {
            config = {
              project.name = "file-browser";
              docker-compose.volumes = {
                file-browser-data = {};
                file-browser-config = {};
              };

              services = {
                filebrowser = {
                  service = {
                    image = "hurlenko/filebrowser";
                    user = "1000:1000";
                    restart = "always";
                    ports = ["8080:8080"];
                    volumes = [
                      "./data:/data"
                      "./config:/config"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
