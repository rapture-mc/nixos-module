{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.prometheus;
in {
  options.megacorp.services.prometheus = with lib; {
    enable = mkEnableOption "Enable Prometheus";

    node-exporter.enable = mkEnableOption "Enable Prometheus node exporter";

    scraper = {
      enable = mkEnableOption "Enable Prometheus scraping";

      targets = mkOption {
        type = types.listOf types.str;
        default = ["127.0.0.1:9002"];
        description = "List of targets to scrape";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts =
      [
        9001
      ]
      ++ (
        if cfg.node-exporter.enable
        then [9002]
        else []
      );

    services.prometheus = {
      enable = true;
      port = 9001;
      scrapeConfigs = lib.mkIf cfg.scraper.enable [
        {
          job_name = "export-linux-system-metrics";
          static_configs = [
            {
              targets = cfg.scraper.targets;
            }
          ];
        }
      ];
      exporters = lib.mkIf cfg.node-exporter.enable {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };
    };
  };
}
