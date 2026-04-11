# Hyprland Wayland Compositor with QuickShell Support
# Enable with: myNixOS.desktop.hyprland.enable = true;
{ config, pkgs, lib, ... }: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal for screen sharing, file dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Polkit for authentication dialogs
  security.polkit.enable = true;

  # PAM configuration for QuickShell lock screen
  security.pam.services.quickshell-lock = {};

  # Required services
  services.dbus.enable = true;

  # GDM (GNOME Display Manager)
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome  # Polkit authentication agent
    xdg-utils

    # Qt6 for QuickShell
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtmultimedia

    # Network management
    networkmanagerapplet
  ];

  # Start polkit agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
