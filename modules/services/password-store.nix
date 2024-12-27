{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.password-store;
in {
  options.megacorp.services.password-store = with lib; {
    enable = mkEnableOption "Enable Password Store";

    logo = mkEnableOption "Whether to show password vault logo on shell startup";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.pass];

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh.settings.X11Forwarding = true;
  };
}
