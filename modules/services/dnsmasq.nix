{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.dnsmasq;
in {
  options.megacorp.services.dnsmasq = with lib; {
    enable = mkEnableOption "Enable dnsmasq";

    domain = mkOption {
      type = types.str;
      default = "localhost";
      description = "The domain name that dnsmasq will be deployed in";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        cache-size = 1000;
        server = [
          "8.8.8.8"
          "8.8.4.4"
        ];
        domain-needed = true;
        expand-hosts = true;
        domain = cfg.domain;
        bogus-priv = true;
      };
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
