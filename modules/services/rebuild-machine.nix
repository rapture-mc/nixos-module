{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.rebuild-machine;
in {
  options.megacorp.services.rebuild-machine = with lib; {
    enable = mkEnableOption ''
      Whether to enable the custom systemd rebuild-machine service/timer.
      If enabled, this unit is activated and will automatically fetch the latest git config repo and rebuild its own system.
      By default it will rebuild every Saturday at 12:00AM.
    '';

    org = mkOption {
      type = types.str;
      default = "mgc";
      description = "Organizational code this machine belongs to";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      timers."rebuild-machine" = {
        wantedBy = ["timers.target"];
        requires = ["network-online.target"];
        timerConfig = {
          OnCalendar = "Sat *-*-* 00:15:00";
          Persistent = true;
          Unit = "rebuild-machine.service";
        };
      };

      services."rebuild-machine" = {
        script = ''
          export PATH=${pkgs.git}/bin:${pkgs.nixos-rebuild}/bin:$PATH
          working_dir=/megacorp/nixos/$(date +%Y-%m-%d)

          if [ ! -e "/megacorp" ]; then
            echo "/megacorp directory doesn't exist, creating..."

            mkdir -p -m 750 /megacorp
            chown ${config.megacorp.config.users.admin-user}:root /megacorp
          else
            echo "/megacorp directory already exists, skipping..."
          fi

          if [ ! -e $working_dir ]; then
            echo "$working_dir directory doesn't exist, creating..."
            mkdir -p -m 750 $working_dir

            git clone https://gitea.megacorp.industries/${cfg.org}/nixos $working_dir

            echo "Running nixos-rebuild switch..."
            cd $working_dir && nixos-rebuild switch --flake .#${config.megacorp.config.system.hostname} || rm -r $working_dir
            echo "Succesfully switched to new system configuration"

            chown -R ${config.megacorp.config.users.admin-user}:root /megacorp/nixos
          else
            echo "$working_dir directory already exists, skipping git clone + nixos-rebuild switch..."
          fi

        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
