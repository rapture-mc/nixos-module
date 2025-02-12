_: {
  imports = [
    ./packages/custom-commands.nix
    ./packages/default.nix
    ./packages/desktop.nix
    # ./nixvim/default.nix  # Not enabling until I figure out how to import github:rapture-mc/nixvim as a package into this module
  ];

  home-manager.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@wheel"];
  };
}
