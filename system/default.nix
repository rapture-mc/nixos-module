_: {
  imports = [
    ./packages/custom-commands.nix
    ./packages/default.nix
    ./packages/desktop.nix
    ./packages/tor-tools.nix
    ./nixvim/default.nix
  ];

  home-manager.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@wheel"];
  };
}
