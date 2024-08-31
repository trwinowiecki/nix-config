{
  description = "My new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager={
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
      myLib = import ./myLib/default.nix {inherit inputs;};
    in
      with myLib; {
        # Formatter for your nix files, available through 'nix fmt'
        # Other options beside 'alejandra' include 'nixpkgs-fmt'
        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home-manager;

        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = {
          laptop = mkSystem ./hosts/laptop/configuration.nix;
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#your-username@your-hostname'
        homeConfigurations = {
          "taylor@hp-nixos" = mkHome "x86_64-linux" ./hosts/laptop/home.nix;
        };
      };
}
