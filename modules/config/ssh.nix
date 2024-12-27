{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.ssh;
in {
  options.megacorp.config.ssh = with lib; {
    accept-host-key = mkEnableOption ''
      Whether to automatically accept remote machines SSH key

      use this option if it isn't plausible to add each known host key to the known_hosts file
    '';
  };

  config = {
    programs.ssh.extraConfig = lib.mkIf cfg.accept-host-key "StrictHostKeyChecking=accept-new";
  };
}
