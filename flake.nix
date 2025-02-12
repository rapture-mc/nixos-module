{
  description = "Megacorp NixOS config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-24.11";
      rev = "0a2935209750c0d2f4ee9f7803fae476cc0d2854";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
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
    self,
    home-manager,
    nixvim,
    arion,
    comin,
    ...
  } @ inputs: {
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
