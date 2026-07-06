# Taylor's NixOS Configuration

A modular NixOS and Home Manager configuration using Nix flakes with **nix-colors** theming.

## Structure

```
nix-config/
├── flake.nix              # Main entry point - defines inputs and outputs
├── flake.lock             # Locked dependency versions
├── myLib/
│   └── default.nix        # Helper functions (mkSystem, mkHome, extendModules)
├── hosts/
│   ├── laptop/            # Personal laptop (hp-nixos)
│   │   ├── configuration.nix    # NixOS system config
│   │   ├── hardware-configuration.nix
│   │   └── home.nix       # Home Manager config for taylor
│   └── work/
│       └── home.nix       # Home Manager only config for jzl3lr
├── modules/
│   ├── nixos/
│   │   ├── default.nix    # NixOS module aggregator with feature system
│   │   ├── features/      # Individual NixOS features (canon-printer, etc.)
│   │   └── bundles/       # NixOS package bundles (general fonts, etc.)
│   └── home-manager/
│       ├── default.nix    # Home Manager module with nix-colors
│       ├── features/      # Feature modules (kitty with theming, git, zsh)
│       └── nixvim/        # Neovim configuration via nixvim
└── update-flake.sh        # Helper script to rebuild system
```

## Quick Start

### Rebuild NixOS system
```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nix-config#hp-nixos
```

### Rebuild Home Manager
```bash
home-manager switch --flake ~/dotfiles/nix-config#taylor
# or for work:
home-manager switch --flake ~/dotfiles/nix-config#jzl3lr
```

### Using the update script
```bash
./update-flake.sh           # Normal rebuild
./update-flake.sh --trace   # With --show-trace for debugging
```

## NixOS Feature System

Enable NixOS features in `hosts/laptop/configuration.nix`:
```nix
myNixOS = {
  canon-printer.enable = true;
  # Add more features in modules/nixos/features/
};
```

Creating a new feature at `modules/nixos/features/my-feature.nix`:
```nix
{ config, pkgs, ... }: {
  services.myservice.enable = true;
}
```

## Theming with nix-colors

This config uses [nix-colors](https://github.com/misterio77/nix-colors) for consistent theming.

### Default Theme
**Gruvbox Dark Medium** is set as the default in `modules/home-manager/default.nix`.

### Change Theme
Override in your `home.nix`:
```nix
# Pick from: https://github.com/tinted-theming/base16-schemes
colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
# or: catppuccin-mocha, nord, dracula, tokyo-night-dark, etc.
```

### Themed Kitty Terminal
Import the kitty feature to get a themed terminal:
```nix
imports = [
  outputs.homeManagerModules.default
  ../../modules/home-manager/features/kitty.nix
];
```

The kitty config automatically uses your `colorScheme` palette.

### Use Theme Colors in Your Own Modules
```nix
{ config, ... }:
let
  colors = config.colorScheme.palette;
in {
  # Base16 color palette:
  # colors.base00 = background
  # colors.base05 = foreground
  # colors.base08 = red
  # colors.base0B = green
  # colors.base0D = blue
  # colors.base0A = yellow
  # colors.base0E = magenta
  # colors.base0C = cyan
}
```

## Inputs

| Input | Description |
|-------|-------------|
| `nixpkgs` | NixOS 25.05 (stable) |
| `nixpkgs-unstable` | NixOS unstable (for bleeding-edge packages) |
| `home-manager` | Home Manager 25.05 |
| `nixvim` | Declarative Neovim configuration |
| `nix-colors` | Base16 color scheme system |

## Available Configurations

| Name | Type | Description |
|------|------|-------------|
| `hp-nixos` | NixOS | Laptop system configuration |
| `taylor` | Home Manager | Personal home config |
| `jzl3lr` | Home Manager | Work home config (no NixOS) |

## Using Unstable Packages

Both `pkgs` (stable) and `pkgsUnstable` are available in home configs:
```nix
home.packages =
  (with pkgs; [ firefox vim ])
  ++ (with pkgsUnstable; [
    # Latest versions from nixos-unstable
    neovim
    claude-code
  ]);
```

## Tips

- **Check config before applying**: `nix flake check`
- **Update all inputs**: `nix flake update`
- **Update single input**: `nix flake update nixpkgs`
- **Search packages**: `nix search nixpkgs <package>`
- **Show flake info**: `nix flake show`

## Key Files

| File | Purpose |
|------|---------|
| `myLib/default.nix` | Helper functions with detailed comments |
| `modules/nixos/default.nix` | NixOS feature/bundle system |
| `modules/home-manager/default.nix` | nix-colors integration |
| `modules/home-manager/features/kitty.nix` | Themed terminal config |
| `modules/home-manager/data/hyprland-quickshell/README.md` | Hyprland + QuickShell desktop guide |
