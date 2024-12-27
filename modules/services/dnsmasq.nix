{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.dnsmasq;
in {
  options.megacorp.services.dnsmasq = with lib; {
    enable = mkEnableOption "Enable dnsmasq";
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
        bogus-priv = true;
      };
    };

    networking.firewall.allowedUDPPorts = [53];
  };
}
