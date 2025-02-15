{
  description = "Megacorp NixOS config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixvim,
    arion,
    comin,
    ...
  }: {
    nixosModules.default = {
      imports = [
        nixvim.nixosModules.nixvim
        home-manager.nixosModules.home-manager
        arion.nixosModules.arion
        comin.nixosModules.comin
        ./modules
      ];
    };
  };
}
