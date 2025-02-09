{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.services.comin;

  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
in {
  options.megacorp.services.comin = {
    enable = mkEnableOption "Whether to enable comin";

    repo = mkOption {
      type = types.str;
      default = "";
      description = ''
        The git repo where NixOS configuration is stored.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = cfg.repo;
          branches.main.name = "main";
        }
      ];
    };
  };
}
