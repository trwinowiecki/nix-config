# Niri Scrolling Tiling Wayland Compositor
# Enable with: myNixOS.desktop.niri.enable = true;
{ config, pkgs, lib, ... }: {
  # Enable Niri
  programs.niri.enable = true;

  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Polkit for authentication dialogs
  security.polkit.enable = true;

  # Required services
  services.dbus.enable = true;

  # Greetd as display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite  # X11 compatibility layer
    polkit_gnome        # Polkit authentication agent
    xdg-utils
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
