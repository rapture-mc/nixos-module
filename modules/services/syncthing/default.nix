{
  lib,
  config,
  pkgs,
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

    devices = mkOption {
      type = types.attrs;
      description = ''
        Devices that Syncthing should be able to communicate with.

        See services.syncthing.settings.devices (in nixpkgs) for more info

        E.g:
        devices = {
          device1 = {
            id = "<DEVICE-ID>";
            autoAcceptFolders = true;
          };
        };
      '';
      default = {};
    };

    folders = mkOption {
      type = types.attrs;
      description = ''
        Folders to be shared by Syncthing.

        See services.syncthing.settings.folders (in nixpkgs) for more info

        E.g:
        folders = {
          "Documents" = {
            devices = "device1";
            path = /home/<USER>/Documents;
          };
        };
      '';
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.syncthing];

    networking.firewall = {
      allowedTCPPorts = [
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };

    services = {
      syncthing = {
        enable = true;
        group = "users";
        user = cfg.user;
        dataDir = "/home/${cfg.user}/Documents";
        configDir = "/home/${cfg.user}/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          options.urAccepted = -1;
          devices = cfg.devices;
          folders = cfg.folders;
        };
      };
    };
  };
}
