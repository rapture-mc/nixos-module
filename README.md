# Megacorp NixOS Module

## Getting started

To consume this module add this repository to your Nix flake inputs like so:
```
file: flake.nix

{
  inputs = {
    megacorp.url = "github:rapture-mc/nixos-module";             # <--- Import the megacorp module into your flake
  };

  outputs = {
    nixpkgs,
    megacorp,
    ...
  }: let
    system = "x86_64-linux";                                     # <--- Change to your host architecture
    pkgs = nixpkgs.legacyPackages.${system};                     # <--- Shorthand to access NixOS packages more easily
  in {
    nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [
        megacorp.nixosModules.default                            # <--- This is the important part where you actually import the megacorp nixos module
        ./hardware-configuration.nix                             # <--- Hardware config file (update to your hardware file located in /etc/nixos/hardware-configuration.nix)
        {
          megacorp.config.users.admin-user = "megaman";          # <--- Example option specifying default admin usernanme

          environment.systemPackages = with pkgs; [              # <--- You can continue to declare nixos options as you would in a standard configuration.nix file
            firefox
            vim
          ];
        }
      ];
    };
  };
}
```
