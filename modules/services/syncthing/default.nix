{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.syncthing;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.services.syncthing = {
    enable = mkEnableOption "Enable syncthing";

    user = mkOption {
      type = types.str;
      description = ''
        The user to run syncthing as

        Default is Megacorp admin user
      '';
      default = config.megacorp.config.users.admin-user;
    };

    gui = mkEnableOption ''
      Whether to enable the GUI. Will be available at the hosts IP on port 8384.

      NOTE: GUI will be unprotected until you set a password.
    '';

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

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.syncthing];

    networking.firewall = {
      allowedTCPPorts = [
        22000
      ]
      ++ (
        if cfg.gui
        then [8384]
        else []
      );

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
        guiAddress = if cfg.gui then "0.0.0.0:8384" else "127.0.0.1:8384";
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
