# Home Manager Modules
#
# This module imports nix-colors for theming and provides a feature system
# with automatic enable options for features and desktop environments.
#
# To enable features, set their options in your home.nix:
#   myHomeManager.kitty.enable = true;
#   myHomeManager.desktop.gnome.enable = true;
{
  pkgs,
  inputs,
  config,
  lib,
  myLib,
  ...
}: let
  cfg = config.myHomeManager;

  # Desktop environment names for mutual exclusion
  desktopEnvs = ["gnome" "kde" "hyprland" "niri"];
  enabledDEs = lib.filter (de: cfg.desktop.${de}.enable or false) desktopEnvs;

  # Taking all modules in ./features (excluding desktop, conf, and matugen which we handle manually)
  featureFiles = lib.filter
    (f: !(lib.hasSuffix "/desktop" (toString f))
        && !(lib.hasSuffix "/conf" (toString f))
        && !(lib.hasSuffix "matugen.nix" (toString f)))
    (myLib.filesIn ./features);

  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    featureFiles;

  # Matugen module handled separately (workaround for extendModules issue)
  matugenModule = { config, pkgs, lib, ... }: let
    matugenConfigDir = ./data/matugen-config;
  in {
    options.myHomeManager.matugen.enable = lib.mkEnableOption "enable matugen dynamic theming";

    config = lib.mkIf cfg.matugen.enable {
      xdg.configFile."matugen/config.toml".source = "${matugenConfigDir}/config.toml";
      xdg.configFile."matugen/templates" = {
        source = "${matugenConfigDir}/templates";
        recursive = true;
      };

      home.packages = with pkgs; [ matugen ];

      home.file.".local/bin/matugen-update" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          # Usage: matugen-update [wallpaper_path]
          # If no path provided, uses the current swww wallpaper

          WALLPAPER="$1"

          if [ -z "$WALLPAPER" ]; then
            # Try to get current wallpaper from swww
            WALLPAPER=$(swww query 2>/dev/null | head -n1 | sed 's/.*image: //')
          fi

          if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
            echo "Generating colors from: $WALLPAPER"
            matugen image "$WALLPAPER"

            # Signal QuickShell to reload colors (it polls /tmp/qs_colors.json)
            echo "Colors updated at /tmp/qs_colors.json"
          else
            echo "Error: No valid wallpaper found"
            exit 1
          fi
        '';
      };
    };
  };

  # Desktop environment features with myHomeManager.desktop.<name>.enable
  desktopFeatures =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.desktop.${name}.enable = lib.mkEnableOption "enable ${name} desktop configuration";
      };

      configExtension = config: (lib.mkIf cfg.desktop.${name}.enable config);
    })
    (myLib.filesIn ./features/desktop);

in {
  imports = [
    # Import nix-colors for theming support
    inputs.nix-colors.homeManagerModules.default
    # Matugen handled separately (workaround for extendModules issue)
    matugenModule
  ] ++ features ++ desktopFeatures;

  config = {
    # Mutual exclusion assertion for desktop environments
    assertions = [
      {
        assertion = builtins.length enabledDEs <= 1;
        message = ''
          Only one desktop environment can be enabled at a time.
          Currently enabled: ${lib.concatStringsSep ", " enabledDEs}
        '';
      }
    ];

    # Default colorScheme - can be overridden in individual home.nix files
    # Available schemes: https://github.com/tinted-theming/base16-schemes
    # Common ones: gruvbox-dark-medium, gruvbox-dark-hard, catppuccin-mocha, nord, dracula
    colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  };
}
