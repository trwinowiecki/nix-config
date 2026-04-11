# myLib - Custom Nix helper functions for this configuration
#
# This library provides utilities for building NixOS and Home Manager
# configurations, plus a module extension system for dynamic feature flags.
#
# Usage: Imported in flake.nix via `import ./myLib/default.nix { inherit inputs; }`
{inputs}: let
  myLib = (import ./default.nix) {inherit inputs;};
  outputs = inputs.self.outputs;
in rec {
  # ================================================================ #
  # =                            My Lib                            = #
  # ================================================================ #

  # ======================= Package Helpers ======================== #
  #
  # These functions provide access to packages from different nixpkgs channels.
  # Use pkgsFor for stable packages, pkgsUnstableFor for bleeding-edge.
  # Both have allowUnfree enabled.

  # Get stable nixpkgs for a given system (e.g., "x86_64-linux")
  pkgsFor = sys: import inputs.nixpkgs {
    system = sys;
    config.allowUnfree = true;
  };

  # Get unstable nixpkgs for a given system (with allowUnfree)
  pkgsUnstableFor = sys: import inputs.nixpkgs-unstable {
    system = sys;
    config.allowUnfree = true;
  };

  # ========================== Buildables ========================== #
  #
  # Factory functions for creating NixOS and Home Manager configurations.
  # These handle the boilerplate of setting up special args and common modules.

  # Create a NixOS system configuration
  # Usage in flake.nix: mkSystem ./hosts/laptop/configuration.nix
  #
  # This function:
  # - Passes inputs, outputs, and myLib as special args (available in all modules)
  # - Enables allowUnfree packages globally
  # - Imports the default NixOS modules (modules/nixos)
  mkSystem = config:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs myLib;
      };
      modules = [
        config
        { nixpkgs.config.allowUnfree = true; }
        outputs.nixosModules.default
      ];
    };

  # Create a Home Manager configuration (standalone, not as NixOS module)
  # Usage in flake.nix: mkHome "x86_64-linux" ./hosts/laptop/home.nix
  #
  # This function:
  # - Takes system architecture and config path
  # - Passes inputs, outputs, myLib, and pkgsUnstable as extra special args
  # - Enables allowUnfree packages globally
  # - Imports the default Home Manager modules (modules/home-manager)
  mkHome = sys: config:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor sys;
      extraSpecialArgs = {
        inherit inputs myLib outputs;
        pkgsUnstable = pkgsUnstableFor sys;
      };
      modules = [
        config
        { nixpkgs.config.allowUnfree = true; }
        outputs.homeManagerModules.default
      ];
    };

  # =========================== Helpers ============================ #
  #
  # File system utilities for the module extension system.

  # List all files in a directory, returning full paths
  # Example: filesIn ./features => [ ./features/git.nix, ./features/zsh.nix ]
  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  # List all directories in a path (returns attrset filtered to directories only)
  dirsIn = dir:
    inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory")
    (builtins.readDir dir);

  # Extract filename without extension from a path
  # Example: fileNameOf ./features/git.nix => "git"
  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # ========================== Extenders =========================== #
  #
  # The module extension system - this is the core of the feature flag system.
  # It allows you to wrap existing modules with additional options (like enable flags)
  # and conditional configuration.

  # Extend a single module with additional options and/or config transformations
  #
  # Arguments (as attrset):
  #   path          - Path to the module file to extend
  #   extraOptions  - Additional options to add to the module (optional)
  #   extraConfig   - Additional config to merge into the module (optional)
  #   optionsExtension - Function to transform the module's options (optional)
  #   configExtension  - Function to transform the module's config (optional)
  #
  # Example usage:
  #   extendModule {
  #     path = ./features/git.nix;
  #     extraOptions = { myHomeManager.git.enable = mkEnableOption "git"; };
  #     configExtension = cfg: mkIf config.myHomeManager.git.enable cfg;
  #   }
  extendModule = {path, ...} @ args: {pkgs, ...} @ margs: let
    eval =
      if (builtins.isString path) || (builtins.isPath path)
      then import path margs
      else path margs;
    evalNoImports = builtins.removeAttrs eval ["imports" "options"];

    extra =
      if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
      then [
        ({...}: {
          options = args.extraOptions or {};
          config = args.extraConfig or {};
        })
      ]
      else [];
  in {
    imports =
      (eval.imports or [])
      ++ extra;

    options =
      if builtins.hasAttr "optionsExtension" args
      then (args.optionsExtension (eval.options or {}))
      else (eval.options or {});

    config =
      if builtins.hasAttr "configExtension" args
      then (args.configExtension (eval.config or evalNoImports))
      else (eval.config or evalNoImports);
  };

  # Apply extendModule to a list of module paths with a common extension pattern
  #
  # The extension function receives the module name (filename without .nix)
  # and should return the extension arguments for extendModule.
  #
  # Example usage (from modules/nixos/default.nix):
  #   extendModules
  #     (name: {
  #       extraOptions.myNixOS.${name}.enable = mkEnableOption "...";
  #       configExtension = config: mkIf cfg.${name}.enable config;
  #     })
  #     (filesIn ./features)
  #
  # This automatically creates enable flags for each feature file!
  extendModules = extension: modules:
    map
    (f: let
      name = fileNameOf f;
    in (extendModule ((extension name) // {path = f;})))
    modules;

  # ============================ Shell ============================= #
  #
  # Multi-system helpers for dev shells and packages.

  # Generate an attribute set for all supported systems
  # Useful for devShells, packages, etc.
  #
  # Example usage:
  #   devShells = forAllSystems (pkgs: { default = pkgs.mkShell { ... }; });
  forAllSystems = pkgs:
    inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ]
    (system: pkgs inputs.nixpkgs.legacyPackages.${system});
}
