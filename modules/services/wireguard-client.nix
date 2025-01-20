{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.wireguard;
in {
  options.megacorp.services.wireguard = with lib; {
    server = {
      enable = mkEnableOption "Whether to wireguard server";

      subnet = mkOption {
        type = types.str;
        default = "10.100.0.0/24";
        description = "The subnet for the wireguard hosts";
      };
    };

    client = {
      enable = mkEnableOption "Whether to enable the Zabbix agent";

      server-ip = mkOption {
        type = types.str;
        default = "1.2.3.4";
        description = "The IP of the wireguard server";
      };

      server-port = mkOption {
        type = types.str;
        default = "51820";
        description = "The port of the wireguard server";
      };
    };
  };

  config = {
  };
}
