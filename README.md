# Megacorp NixOS Module

## Getting started

To consume this module add this repository to your Nix flake inputs like so:
```
file: flake.nix
{
  inputs = {
    megacorp.url = "github:rapture-mc/nixos-module";
  };

  outputs = {
    self,
    nixpkgs,
    megacorp,
    ...
  }@inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
      system = ${system};
      modules = [
        megacorp.nixosModules.default
        {
          megacorp.config.users.admin-user = "megaman";

          environment.systemPackages = with pkgs; [
            firefox
            vim
          ];
        }
      ];
    };
  };
}
```
