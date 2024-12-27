{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.networking.static-ip;
in {
  options.megacorp.config.networking.static-ip = with lib; {
    enable = mkEnableOption "Enable a static IP";

    interface = mkOption {
      type = types.str;
      default = "ens3";
      description = "The primary network interface of the host machine";
    };

    ipv4 = mkOption {
      type = types.str;
      default = "192.168.1.2";
      description = "The IPv4 address of the host machine";
    };

    prefix = mkOption {
      type = types.int;
      default = 24;
      description = "The subnet CIDR for the host machine";
    };

    gateway = mkOption {
      type = types.str;
      default = "192.168.1.1";
      description = "The IP of the host machines gateway";
    };

    nameservers = mkOption {
      type = types.listOf types.str;
      default = ["192.168.1.1"];
      description = "List of IP addresses of the nameservers for the host";
    };

    lan-domain = mkOption {
      type = types.str;
      default = "localhost";
      description = "The host machines domain it belongs to";
    };

    bridge = {
      enable = mkEnableOption "Enable bridge interface";

      name = mkOption {
        type = types.str;
        default = "br0";
        description = "The name of the bridge interface";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nameservers = cfg.nameservers;
      domain = "${cfg.lan-domain}";

      bridges = lib.mkIf cfg.bridge.enable {
        "${cfg.bridge.name}" = {
          interfaces = ["${cfg.interface}"];
        };
      };

      interfaces = {
        ${cfg.interface} = {
          useDHCP = lib.mkIf cfg.bridge.enable false;

          ipv4 = lib.mkIf (!cfg.bridge.enable) {
            addresses = [
              {
                address = "${cfg.ipv4}";
                prefixLength = cfg.prefix;
              }
            ];

            routes = lib.mkIf (!cfg.bridge.enable) [
              {
                address = "0.0.0.0";
                prefixLength = 0;
                via = "${cfg.gateway}";
              }
            ];
          };
        };

        ${cfg.bridge.name} = lib.mkIf cfg.bridge.enable {
          ipv4 = {
            addresses = [
              {
                address = "${cfg.ipv4}";
                prefixLength = cfg.prefix;
              }
            ];

            routes = [
              {
                address = "0.0.0.0";
                prefixLength = 0;
                via = "${cfg.gateway}";
              }
            ];
          };
        };
      };
    };
  };
}
