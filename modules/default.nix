{ inputs, pkgs, config, lib, ... }: {
  imports = [
    ./config/bootloader.nix
    (import ./config/desktop.nix {
      inherit inputs pkgs config lib;
    })
    ./config/networking/static.nix
    ./config/networking/wireless.nix
    ./config/ssh.nix
    ./config/system.nix
    ./config/users.nix
    ./services/controller.nix
    ./services/dnsmasq.nix
    ./services/gitea.nix
    ./services/gitea-runner.nix
    ./services/grafana.nix
    ./services/guacamole.nix
    ./services/jenkins.nix
    ./services/k3s.nix
    ./services/netbox.nix
    ./services/nextcloud.nix
    ./services/nginx/default.nix
    ./services/password-store.nix
    ./services/prometheus.nix
    ./services/rebuild-machine.nix
    ./services/restic.nix
    ./services/sshd.nix
    ./services/semaphore.nix
    ./services/zabbix.nix
    ./virtualisation/guest.nix
    ./virtualisation/hypervisor.nix
    ./virtualisation/whonix.nix
  ];
}
