{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.system;

  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;
in {
  options.megacorp.config.system = {
    enable = mkEnableOption "Whether to allow Megacorp to control system configuration";

    timezone = mkOption {
      type = types.str;
      default = "Australia/Darwin";
      description = "Timezone to set";
    };

    state-version = mkOption {
      type = types.str;
      default = "";
      description = ''
        The Nixpkgs version that the NixOS system was initially installed with.

        This should be set on a per-system basis and never be changed once set. NixOS uses this value to assist with Nixpkgs migration and detect potentially breaking changes when moving between Nixpkgs versions (particularly from auto-generated stateful data).
      '';
    };

    locale = mkOption {
      type = types.str;
      default = "en_AU.UTF-8";
      description = "The default system locale";
    };
  };

  config = mkIf cfg.enable {
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

    home-manager.backupFileExtension = "backup";

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };
  };
}
