{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.wireguard-client;
in {
  options.megacorp.services.wireguard-client = with lib; {
    enable = mkEnableOption "Whether to wireguard client";

    private-key-file = mkOption {
      type = types.str;
      default = "/var/wireguard/private";
      description = "The path to the wireguard private key file";
    };

    ipv4 = mkOption {
      type = types.str;
      default = "10.100.0.1";
      description = "The wireguard IPv4 address of the client";
    };

    subnet = mkOption {
      type = types.str;
      default = "10.100.0.0";
      description = "The subnet for the wireguard hosts";
    };

    prefix = mkOption {
      type = types.int;
      default = 24;
      description = "The prefix for the wireguard hosts";
    };

    server = {
      ipv4 = mkOption {
        type = types.str;
        default = "";
        description = "The public IP address of the wireguard server";
      };

      port = mkOption {
        type = types.int;
        default = 51820;
        description = "The port of the wireguard server";
      };

      public-key = mkOption {
        type = types.str;
        default = "";
        description = "The public key of the wireguard server";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.wireguard-tools];

    networking = {
      firewall.allowedUDPPorts = [51820];
      wireguard = {
        enable = true;
        interfaces.wg0 = {
          ips = ["${cfg.ipv4}/${builtins.toString cfg.prefix}"];
          listenPort = cfg.port;
          privateKeyFile = cfg.private-key-file;
          peers = [
            {
              publicKey = "${cfg.server.public-key}";
              allowedIPs = ["${cfg.subnet}/${builtins.toString cfg.prefix}"];
              endpoint = "${cfg.server.ipv4}:${cfg.server.port}";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}
