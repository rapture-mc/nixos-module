_: {
  imports = [
    ./config/bootloader
    ./config/desktop
    ./config/packages
    ./config/networking
    ./config/nixvim
    ./config/openssh
    ./config/system
    ./config/users
    ./hardening/bootloader.nix
    ./services/comin
    ./services/controller.nix
    ./services/dnsmasq.nix
    ./services/file-browser.nix
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
    ./services/restic.nix
    ./services/semaphore
    ./services/syncthing
    ./services/wireguard-server.nix
    ./services/wireguard-client.nix
    ./services/zabbix.nix
    ./virtualisation/hypervisor.nix
    ./virtualisation/qemu-guest.nix
    ./virtualisation/whonix.nix
  ];
}
