{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.nginx.nextcloud;
in {
  options.megacorp.services.nginx.nextcloud = with lib; {
    enable = mkEnableOption "Enable Nextcloud reverse proxy";

    ipv4 = mkOption {
      type = types.str;
      default = "192.168.1.4";
      description = "The IP of the nextcloud instance";
    };

    fqdn = mkOption {
      type = types.str;
      default = "example.com";
      description = ''
        The fqdn of your nextcloud instance.
        NOTE: Don't include "https://" (this is prepended to the value)
      '';
    };
  };

  config = {
    services = lib.mkIf cfg.enable {
      nginx.virtualHosts."${cfg.fqdn}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${cfg.ipv4}";
        };
      };
    };
  };
}
