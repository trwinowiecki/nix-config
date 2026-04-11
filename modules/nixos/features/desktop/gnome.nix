# GNOME Desktop Environment
# Enable with: myNixOS.desktop.gnome.enable = true;
{ config, pkgs, lib, ... }: {
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # GNOME-specific packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.solaar-extension
  ];

  # KDE Connect via GSConnect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
}
