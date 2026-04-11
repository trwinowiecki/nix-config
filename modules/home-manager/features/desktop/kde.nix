# KDE Plasma Home Manager Configuration
# Enable with: myHomeManager.desktop.kde.enable = true;
#
# Provides KDE/Plasma keybindings and basic configuration.
{ config, pkgs, lib, ... }:
let
  colors = config.colorScheme.palette;
in {
  # KDE Plasma packages for user
  home.packages = with pkgs; [
    kdePackages.kdeplasma-addons
  ];

  # Basic plasma configuration can be added here
  # For more advanced config, consider using plasma-manager
  # https://github.com/pjones/plasma-manager
}
