{
  description = "Taylor's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { ... } @ inputs:
    let
      # Supported systems for your flake packages, shell, etc.
      system = "x86_64-linux";
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      myLib = import ./myLib/default.nix { inherit inputs; };
    in
    with myLib; {
      nixosModules.default = import ./modules/nixos;
      homeManagerModules.default = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        hp-nixos = mkSystem ./hosts/laptop/configuration.nix;
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        taylor = mkHome system ./hosts/laptop/home.nix;
      };
    };
}
