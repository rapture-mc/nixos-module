{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.syncthing;
in {
  options.megacorp.services.syncthing = with lib; {
    enable = mkEnableOption "Enable syncthing";

    user = mkOption {
      type = types.str;
      description = "The user to run syncthing as";
      default = config.megacorp.config.users.admin-user;
    };

    synced-devices = mkOption {
      type = types.attrs;
      description = ''
        Devices that Syncthing should be able to communicate with.
        Should be an attribute set like the following:

        devices = {
          "device1" = { id = "<DEVICE-ID>"; }
          "device2" = { id = "<DEVICE-ID>"; }
        }
      '';
      default = {};
    };

    allowed-devices = mkOption {
      type = types.listOf types.str;
      description = "Devices that are allowed to sync with the default folder";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        group = cfg.user;
        user = cfg.user;
        dataDir = "/home/${cfg.user}/Syncthing";
        configDir = "/home/${cfg.user}/Syncthing/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = cfg.synced-devices;

          folders = {
            "Syncthing" = {  # Name of folder in Syncthing, also the folder ID
              path = "/home/${cfg.user}/Syncthing";  # Which folder to add to Syncthing
              devices = cfg.allowed-devices;  # Which devices to share the folder with
            };
          };
        };
      };
    };
  };
}
