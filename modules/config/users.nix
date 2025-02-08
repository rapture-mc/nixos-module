{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.config.users;

  inherit
    (lib)
    mkEnableOption
    mkOption
    mkMerge
    mkIf
    types
    ;
in {
  options.megacorp.config.users = {
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

    home-manager.users = mkMerge [
      {
        ${cfg.admin-user} = {
          imports = [../../home-manager/default.nix];
        };
      }

      (mkIf cfg.regular-user.enable {
        ${cfg.regular-user.name} = {
          imports = [../../home-manager/default.nix];
        };
      })
    ];

    users.users = mkMerge [
      {
        ${cfg.admin-user} = {
          isNormalUser = true;
          initialPassword = "changeme";
          shell = pkgs.zsh;
          extraGroups = ["wheel"];
        };
      }

      (mkIf cfg.regular-user.enable {
        ${cfg.regular-user.name} = {
          isNormalUser = true;
          initialPassword = "changeme";
          shell = pkgs.zsh;
        };
      })
    ];
  };
}
