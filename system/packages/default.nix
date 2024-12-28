{pkgs, ...}: {
  import = ./xmr-swap.nix;

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
}
