{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.system;
in {
  options.megacorp.config.system = with lib; {
    hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "System hostname";
    };

    timezone = mkOption {
      type = types.str;
      default = "Australia/Darwin";
      description = "Timezone to set";
    };

    state-version = mkOption {
      type = types.str;
      default = "24.05";
      description = "The nixos version the system was initially installed with";
    };

    locale = mkOption {
      type = types.str;
      default = "en_AU.UTF-8";
      description = "The default system locale";
    };
  };

  config = {
    networking.hostName = cfg.hostname;

    time.timeZone = cfg.timezone;

    system.stateVersion = "${cfg.state-version}";

    i18n.defaultLocale = "${cfg.locale}";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${cfg.locale}";
      LC_IDENTIFICATION = "${cfg.locale}";
      LC_MEASUREMENT = "${cfg.locale}";
      LC_MONETARY = "${cfg.locale}";
      LC_NAME = "${cfg.locale}";
      LC_NUMERIC = "${cfg.locale}";
      LC_PAPER = "${cfg.locale}";
      LC_TELEPHONE = "${cfg.locale}";
      LC_TIME = "${cfg.locale}";
    };
  };
}
