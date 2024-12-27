{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.megacorp.services.k3s;
in {
  options.megacorp.services.k3s = with lib; {
    enable = mkEnableOption "Enable k3s";

    clusterInit = mkEnableOption "Whether to initialize the cluster";

    logo = mkEnableOption "Whether to enable the k3s logo";

    role = mkOption {
      type = types.str;
      default = "server";
      description = "The k3s role (either 'server' or 'agent')";
    };

    tokenFile = mkOption {
      type = types.path;
      default = /run/secrets/kube-token;
      description = "The path to the file containing the k3s token";
    };

    serverIP = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The k3s master server IP";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        6443
        2379
        2380
        7946
      ];

      allowedUDPPorts = [
        8472
        7946
      ];
    };

    environment = lib.mkIf (cfg.role == "server") {
      sessionVariables = {KUBECONFIG = "$HOME/.kube/config";};
      systemPackages = [pkgs.k9s];
    };

    services = {
      k3s = {
        enable = true;
        clusterInit = cfg.clusterInit;
        role = cfg.role;
        tokenFile = cfg.tokenFile;
        serverAddr = "https://${cfg.serverIP}:6443";
      };
      rpcbind.enable = true;
    };

    boot.supportedFilesystems = ["nfs"];
  };
}
