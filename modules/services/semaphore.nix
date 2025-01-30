{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.semaphore;
in {
  options.megacorp.services.semaphore = with lib; {
    enable = mkEnableOption "Enable Semaphore";

    reverse-proxied = mkEnableOption "Whether Semaphore is served behind a reverse proxy";

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
        The fqdn of your Semaphore instance.
        NOTE: Don't include "https://" (this is prepended to the value)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.megacorp.config.users.admin-user}.extraGroups = ["docker"];

    environment.systemPackages = [pkgs.lazydocker];

    networking.firewall.allowedTCPPorts =
      [
        3000
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
            proxyPass = "http://127.0.0.1:3000";
          };
          "/api/ws" = {
            proxyPass = "http://127.0.0.1:3000/api/ws";
            proxyWebsockets = true;
          };
        };
      };
    };

    virtualisation = {
      docker.enable = true;

      arion = {
        backend = "docker";
        projects.semaphore = {
          serviceName = "semaphore";
          settings = {
            config = {
              project.name = "semaphore";
              docker-compose.volumes = {
                semaphore-postgres = {};
              };

              services = {
                postgres = {
                  service = {
                    image = "postgres";
                    restart = "always";
                    volumes = ["semaphore-postgres:/var/lib/postgresql/data"];
                    environment = {
                      POSTGRES_DB = "semaphore";
                      POSTGRES_USER = "semaphore";
                    };
                    env_file = [
                      "/run/secrets/postgres-password"
                    ];
                  };
                };

                semaphore = {
                  service = {
                    build = ./Dockerfile;
                    restart = "always";
                    ports = ["3000:3000"];
                    environment = {
                      WEB_HOST = "https://${cfg.fqdn}";
                      SEMAPHORE_DB_USER = "semaphore";
                      SEMAPHORE_DB_HOST = "postgres";
                      SEMAPHORE_DB_PORT = "5432";
                      SEMAPHORE_DB_DIALECT = "postgres";
                      SEMAPHORE_DB = "semaphore";
                      SEMAPHORE_PLAYBOOK_PATH = "/tmp/semaphore/";
                      SEMAPHORE_ADMIN_NAME = "admin";
                      SEMAPHORE_ADMIN_PASSWORD = "changeme";
                      SEMAPHORE_ADMIN_EMAIL = "${cfg.tls-email}";
                      SEMAPHORE_ADMIN = "admin";
                      USE_REMOTE_RUNNER = "true";
                    };
                    env_file = [
                      "/run/secrets/semaphore-db-pass"
                      "/run/secrets/semaphore-access-key-encryption"
                    ];
                    depends_on = ["postgres"];
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
