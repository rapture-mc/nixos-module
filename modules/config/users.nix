{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.config.users;
in {
  options.megacorp.config.users = with lib; {
    admin-user = mkOption {
      type = types.str;
      default = "megaroot";
      description = "Default admin user";
    };

    regular-user = {
      enable = mkEnableOption "Whether to enable the user account";

      name = mkOption {
        type = types.str;
        default = "user";
        description = "Default admin user";
      };
    };
  };

  config = {
    programs.zsh.enable = true;

    home-manager.users = lib.mkMerge [
      {
        ${cfg.admin-user} = {
          imports = [../../home-manager/default.nix];
        };
      }

      (lib.mkIf cfg.regular-user.enable {
        ${cfg.regular-user.name} = {
          imports = [../../home-manager/default.nix];
        };
      })
    ];


    users.users = lib.mkMerge [
      {
        ${cfg.admin-user} = {
          isNormalUser = true;
          initialPassword = "changeme";
          shell = pkgs.zsh;
          extraGroups = ["wheel"];
        };
      }

      (lib.mkIf cfg.regular-user.enable {
        ${cfg.regular-user.name} = {
          isNormalUser = true;
          initialPassword = "changeme";
          shell = pkgs.zsh;
        };
      })
    ];
  };
}
