# KDE Plasma 6 Desktop Environment
# Enable with: myNixOS.desktop.kde.enable = true;
{ config, pkgs, lib, ... }: {
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # SDDM Display Manager with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # KDE Connect
  programs.kdeconnect.enable = true;

  # KDE-specific packages
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.spectacle
  ];
}
