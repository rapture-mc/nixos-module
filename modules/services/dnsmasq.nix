{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.dnsmasq;

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.services.dnsmasq = {
    enable = mkEnableOption "Enable dnsmasq";

    domain = mkOption {
      type = types.str;
      default = "localhost";
      description = "The domain name that dnsmasq will be deployed in";
    };

    nameservers = mkOption {
      type = types.listOf types.str;
      default = [
        "8.8.8.8"
        "8.8.4.4"
      ];
      description = "The nameservers dnsmasq should use for all other DNS queries";
    };
  };

  config = mkIf cfg.enable {
    services = {
      dnsmasq = {
        enable = true;
        settings = {
          cache-size = 1000;
          server = cfg.nameservers;
          domain-needed = true;
          expand-hosts = true;
          domain = cfg.domain;
          bogus-priv = true;
        };
      };

      resolved.extraConfig = ''
        DNSStubListener=no
      '';
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
