{pkgs, lib, config, ...}: let
  cfg = config.megacorp.config.packages;

  inherit (lib)
    mkIf
    mkEnableOption
    ;
in {
  imports = [
    ./bash-scripts.nix
    ./desktop.nix
  ];

  options.megacorp.config.packages = {
    enable = mkEnableOption "Whether to enable core packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alejandra
      age
      asciiquarium
      bat
      dig
      file
      gcc
      git
      jq
      lazygit
      lshw
      gnumake
      ncdu
      nh
      ripgrep
      screen
      sops
      ssh-to-age
      sshpass
      speedtest-cli
      traceroute
      tree
      tldr
      unzip
      viddy
      vim
      wget
    ];
  };
}
