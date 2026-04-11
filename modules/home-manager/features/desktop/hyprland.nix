# Hyprland Home Manager Configuration with QuickShell
# Enable with: myHomeManager.desktop.hyprland.enable = true;
#
# Features:
# - QuickShell-based widgets (TopBar, popups, lock screen)
# - Matugen dynamic theming integration
{ config, pkgs, lib, inputs, ... }:
let
  quickshellDir = ../../data/hyprland-quickshell/quickshell;
  quickshellPkg = inputs.quickshell.packages.${pkgs.system}.default;
in {
  # Hyprland core configuration
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$mainMod" = "SUPER";

      monitor = ",preferred,auto,1";

      env = [
        "QT_QPA_PLATFORM,wayland"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
        accel_profile = "flat";
      };

      general = {
        gaps_in = 4;
        gaps_out = 4;
        border_size = 0;
        layout = "dwindle";
      };

      decoration = {
        rounding = 4;
        blur.enabled = false;
        shadow.enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Animations
      animations = {
        enabled = "yes";
        bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];
        animation = [
          "windows, 1, 5, myBezier, popin 80%"
          "windowsOut, 1, 5, myBezier, popin 80%"
          "layers, 1, 5, myBezier, fade"
          "layersIn, 1, 5, myBezier, fade"
          "layersOut, 1, 5, myBezier, fade"
          "fade, 1, 5, myBezier"
          "workspaces, 1, 5, myBezier, slide"
          "specialWorkspaceIn, 1, 5, myBezier, fade"
          "specialWorkspaceOut, 1, 5, myBezier, fade"
        ];
      };

      # Layer rules
      layerrule = [
        "noanim, ^(volume_osd)$"
        "noanim, ^(brightness_osd)$"
        "noanim, hyprpicker"
        "noanim, qsdock"
        "blur, ext-session-lock"
        "ignorealpha 0.2, ext-session-lock"
      ];

      # Window rules
      windowrulev2 = [
        "float, title:^(app-launcher)$"
        "center, title:^(app-launcher)$"
        "size 1200 600, title:^(app-launcher)$"
        "animation slide, title:^(app-launcher)$"
        "float, title:^(qs-master)$"
        "pin, title:^(qs-master)$"
        "noshadow, title:^(qs-master)$"
        "noborder, title:^(qs-master)$"
        "noinitialfocus, title:^(qs-master)$"
        "move -5000 -5000, title:^(qs-master)$"
        "float, class:^(pavucontrol)$"
        "size 800 600, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
        "float, title:^(Open File)$"
        "float, title:^(Save File)$"
        "float, title:^(Open Folder)$"
        "center, title:^(Open File)$"
        "center, title:^(Save File)$"
        "center, title:^(Open Folder)$"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Resize with keyboard
      binde = [
        "$mainMod SHIFT, left, resizeactive, -50 0"
        "$mainMod SHIFT, right, resizeactive, 50 0"
        "$mainMod SHIFT, up, resizeactive, 0 -50"
        "$mainMod SHIFT, down, resizeactive, 0 50"
      ];

      # Locked bindings
      bindl = [
        ", Caps_Lock, exec, sleep 0.1 && swayosd-client --caps-lock"
        "$mainMod, SPACE, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast copy screen"
        ", XF86PowerOff, exec, bash ~/.config/hypr/scripts/lock.sh"
      ];

      # Volume with repeat
      bindel = [
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        "$mainMod, L, exec, bash ~/.config/hypr/scripts/lock.sh"
      ];

      # Main bindings
      bind = [
        "$mainMod, D, exec, bash ~/.config/hypr/scripts/rofi_show.sh drun"
        "ALT, TAB, exec, bash ~/.config/hypr/scripts/rofi_show.sh window"
        "$mainMod, C, exec, bash ~/.config/hypr/scripts/rofi_clipboard.sh"
        "$mainMod SHIFT, S, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle stewart"
        "$mainMod, Q, killactive,"
        "$mainMod, B, exec, vivaldi"
        "$mainMod, P, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle music"
        "$mainMod SHIFT, B, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle battery"
        "$mainMod, W, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle wallpaper"
        "$mainMod, S, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle calendar"
        "$mainMod, N, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle network"
        "$mainMod SHIFT, T, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle focustime"
        "$mainMod, V, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle volume"
        "$mainMod, H, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle guide"
        "$mainMod, M, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle monitors"
        "$mainMod, A, exec, swaync-client -t -sw"
        "$mainMod SHIFT, F, togglefloating,"
        "$mainMod, Return, exec, $terminal"
        "$mainMod, E, exec, nautilus"
        "ALT, F4, exec, bash -c 'if hyprctl activewindow | grep -q \"title: qs-master\"; then ~/.config/hypr/scripts/qs_manager.sh close; else hyprctl dispatch killactive; fi'"
        "$mainMod CTRL, left, movewindow, l"
        "$mainMod CTRL, right, movewindow, r"
        "$mainMod CTRL, up, movewindow, u"
        "$mainMod CTRL, down, movewindow, d"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, 1, exec, ~/.config/hypr/scripts/qs_manager.sh 1"
        "$mainMod, 2, exec, ~/.config/hypr/scripts/qs_manager.sh 2"
        "$mainMod, 3, exec, ~/.config/hypr/scripts/qs_manager.sh 3"
        "$mainMod, 4, exec, ~/.config/hypr/scripts/qs_manager.sh 4"
        "$mainMod, 5, exec, ~/.config/hypr/scripts/qs_manager.sh 5"
        "$mainMod, 6, exec, ~/.config/hypr/scripts/qs_manager.sh 6"
        "$mainMod, 7, exec, ~/.config/hypr/scripts/qs_manager.sh 7"
        "$mainMod, 8, exec, ~/.config/hypr/scripts/qs_manager.sh 8"
        "$mainMod, 9, exec, ~/.config/hypr/scripts/qs_manager.sh 9"
        "$mainMod, 0, exec, ~/.config/hypr/scripts/qs_manager.sh 10"
        "$mainMod SHIFT, 1, exec, ~/.config/hypr/scripts/qs_manager.sh 1 move"
        "$mainMod SHIFT, 2, exec, ~/.config/hypr/scripts/qs_manager.sh 2 move"
        "$mainMod SHIFT, 3, exec, ~/.config/hypr/scripts/qs_manager.sh 3 move"
        "$mainMod SHIFT, 4, exec, ~/.config/hypr/scripts/qs_manager.sh 4 move"
        "$mainMod SHIFT, 5, exec, ~/.config/hypr/scripts/qs_manager.sh 5 move"
        "$mainMod SHIFT, 6, exec, ~/.config/hypr/scripts/qs_manager.sh 6 move"
        "$mainMod SHIFT, 7, exec, ~/.config/hypr/scripts/qs_manager.sh 7 move"
        "$mainMod SHIFT, 8, exec, ~/.config/hypr/scripts/qs_manager.sh 8 move"
        "$mainMod SHIFT, 9, exec, ~/.config/hypr/scripts/qs_manager.sh 9 move"
        "$mainMod SHIFT, 0, exec, ~/.config/hypr/scripts/qs_manager.sh 10 move"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Autostart
      exec-once = [
        "swww-daemon"
        "hypridle"
        "playerctld"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swayosd-server"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
        "quickshell -p ~/.config/hypr/scripts/quickshell/Main.qml"
        "quickshell -p ~/.config/hypr/scripts/quickshell/TopBar.qml"
        "python3 ~/.config/hypr/scripts/focustime/focus_daemon.py &"
      ];
    };
  };

  # Hypridle for lock screen
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "quickshell -p ~/.config/hypr/scripts/quickshell/Lock.qml";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        { timeout = 300; on-timeout = "loginctl lock-session"; }
        { timeout = 900; on-timeout = "systemctl suspend"; }
      ];
    };
  };

  # Deploy QuickShell configuration files
  xdg.configFile."hypr/scripts/quickshell" = {
    source = quickshellDir;
    recursive = true;
  };

  # Rofi launcher configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,window,run";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      display-drun = "Apps";
      display-window = "Windows";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = { font = "JetBrainsMono Nerd Font 12"; };
      "window" = {
        width = mkLiteral "600px";
        border-radius = mkLiteral "8px";
      };
    };
  };

  # Required packages
  home.packages = [
    quickshellPkg  # From quickshell flake input
  ] ++ (with pkgs; [
    swww playerctl pamixer pavucontrol
    brightnessctl cliphist wl-clipboard grimblast slurp
    libnotify swaynotificationcenter swayosd jq curl nautilus
    nerd-fonts.jetbrains-mono nerd-fonts.iosevka python3 socat
    imagemagick bluez-tools inotify-tools bc
  ]);

  # Cursor theme
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # GTK settings for Wayland
  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.adwaita-icon-theme; };
    iconTheme = { name = "Adwaita"; package = pkgs.adwaita-icon-theme; };
  };

  # Qt settings
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
