# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modular NixOS and Home Manager configuration using Nix flakes with nix-colors theming and a custom feature flag system.

### Core Pattern: Dynamic Feature System

The configuration uses `extendModules` from `myLib` to automatically wrap modules with enable options. This happens in two places:

1. **modules/nixos/default.nix** - Wraps NixOS features with `myNixOS.<name>.enable` options
2. **modules/home-manager/default.nix** - Wraps Home Manager features with `myHomeManager.<name>.enable` options

Desktop environments get special treatment with `myNixOS.desktop.<name>.enable` and `myHomeManager.desktop.<name>.enable`, with mutual exclusion assertions to prevent multiple DEs from being enabled simultaneously.

### myLib Helper Functions

The `myLib/default.nix` library provides:

- **mkSystem** - Creates NixOS configurations, injects `inputs`, `outputs`, `myLib` as specialArgs
- **mkHome** - Creates Home Manager configurations, injects `pkgsUnstable` as extraSpecialArgs
- **extendModule** / **extendModules** - Wraps modules with additional options (enable flags) and conditional config
- **pkgsFor** / **pkgsUnstableFor** - Provide stable and unstable nixpkgs with allowUnfree enabled

### Special Args Available in Modules

- **NixOS modules**: `inputs`, `outputs`, `myLib`, `pkgs` (stable)
- **Home Manager modules**: `inputs`, `outputs`, `myLib`, `pkgs` (stable), `pkgsUnstable`

### Theming System

Home Manager integrates **nix-colors** for Base16 theming. The default is gruvbox-dark-medium (set in modules/home-manager/default.nix). Access colors in any Home Manager module via:

```nix
let colors = config.colorScheme.palette;
in {
  # colors.base00 = background, base05 = foreground, base08 = red, etc.
}
```

The **matugen** module provides dynamic color generation from wallpapers for desktop environments (Hyprland, etc.). Use `matugen-update [wallpaper_path]` to regenerate colors.

## Common Commands

### Building and Switching

```bash
# Rebuild both NixOS system and Home Manager (for laptop/taylor)
./update-flake.sh

# Debug build errors with full trace
./update-flake.sh --trace

# NixOS system only
sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos

# Home Manager only
home-manager switch --flake ~/dotfiles/nix-config#taylor
home-manager switch --flake ~/dotfiles/nix-config#jzl3lr  # work config
```

### Flake Operations

```bash
# Validate configuration
nix flake check

# Update all inputs
nix flake update

# Update single input
nix flake update nixpkgs

# Show flake outputs
nix flake show
```

### Package Management

```bash
# Search for packages in stable
nix search nixpkgs <package>

# Search in unstable
nix search nixpkgs#nixpkgs-unstable <package>
```

## Adding New Features

### NixOS Feature

1. Create `modules/nixos/features/<name>.nix` with your configuration
2. Enable in `hosts/laptop/configuration.nix`:
   ```nix
   myNixOS.<name>.enable = true;
   ```
3. The feature gets automatic enable flag via `extendModules` in modules/nixos/default.nix

### Home Manager Feature

1. Create `modules/home-manager/features/<name>.nix` with your configuration
2. Enable in host-specific `home.nix`:
   ```nix
   myHomeManager.<name>.enable = true;
   ```
3. Access theme colors via `config.colorScheme.palette` if needed

### Desktop Environment

For desktop features, place in `modules/nixos/features/desktop/` or `modules/home-manager/features/desktop/`:

```nix
# NixOS
myNixOS.desktop.<name>.enable = true;

# Home Manager
myHomeManager.desktop.<name>.enable = true;
```

Only one desktop environment can be enabled at a time (enforced by assertions).

## Available Configurations

- **hp-nixos** - NixOS system configuration for laptop
- **taylor** - Home Manager for personal laptop (user: taylor)
- **jzl3lr** - Home Manager for work (standalone, no NixOS)

## Important Implementation Details

### Using Unstable Packages

Both stable and unstable nixpkgs are available in Home Manager modules:

```nix
home.packages =
  (with pkgs; [ firefox vim ])
  ++ (with pkgsUnstable; [ neovim claude-code ]);
```

In NixOS modules, you need to import nixpkgs-unstable manually or use `pkgsUnstableFor` from myLib.

### AllowUnfree

Already enabled globally via `mkSystem` and `mkHome` in myLib, so you don't need to set it in individual modules.

### Experimental Features

Nix flakes and nix-command are enabled globally in modules/nixos/default.nix.
