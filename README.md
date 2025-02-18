# Megacorp NixOS Module

## Directory structure
```
.
├── flake.nix
├── home-manager        # <--- Home-manager related configuration
│   ├── config
│   └── programs
├── modules             # <--- Actual modules that can be consumed/customized
│   ├── config
│   ├── services
│   └── virtualisation
├── README.md
```

## Getting started

To consume this module add this repository to your Nix flake inputs.

Minimal viable example:
```
file: flake.nix

{
  inputs = {
    megacorp.url = "github:rapture-mc/nixos-module";             # <--- Import the megacorp module into your flake
    nixpkgs.follows = "megacorp/nixpkgs";                        # <--- Lock nixpkgs to follow the same nixpkgs as the megacorp module
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
        megacorp.nixosModules.default                            # <--- This is the important part where you actually install/import the megacorp nixos module into your nixos machine configuration
        ./hardware-configuration.nix                             # <--- Hardware config file (update to your hardware file located in /etc/nixos/hardware-configuration.nix)
        {
          megacorp = {
            config = {
              system.enable = true;                              # <--- System-related config defined by Megacorp module

              bootloader = {
                enable = true;                                   # <--- Using Megacorp defined bootloader (grub)
                efi.enable = true;
              };

              users = {
                enable = true;
                admin-user = "administrator";                    # <--- Example option specifying default admin usernanme

              };

              nixvim.enable = true;                              # <--- Setting up custom neovim configuration
              packages.enable = true;
            };
          };

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

### More info
My other [repository](https://github.com/rapture-mc/mgc-machines) provides a more complete example of utilizing this repository if you're interested.
