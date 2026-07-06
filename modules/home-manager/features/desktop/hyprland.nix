# Hyprland Home Manager Configuration with QuickShell
# Enable with: myHomeManager.desktop.hyprland.enable = true;
#
# Features:
# - QuickShell-based widgets (TopBar, popups, lock screen)
# - Matugen dynamic theming integration
{ config, pkgs, lib, inputs, ... }:
let
  colorsConf = ../../data/hyprland-quickshell/colors.conf;
  quickshellPkg = inputs.quickshell.packages.${pkgs.system}.default;
  scriptsPath = "${config.home.homeDirectory}/dotfiles/nix-config/modules/home-manager/data/hyprland-quickshell/scripts";
  screenshotDir = "${config.home.homeDirectory}/Pictures/Screenshots";
  qsShim = pkgs.writeShellScriptBin "qs" ''
    exec ${lib.getExe quickshellPkg} "$@"
  '';
  rishotPkg = pkgs.writeShellApplication {
    name = "rishot";
    runtimeInputs = with pkgs; [
      qsShim
      quickshellPkg
      util-linux
      wl-clipboard
      imagemagick
      cliphist
      curl
      libnotify
    ];
    text = ''
      export RISHOT_CONFIG_DIR="${inputs.rishot}/src"
      export RISHOT_SAVEDIR="''${RISHOT_SAVEDIR:-${screenshotDir}}"
      exec ${inputs.rishot}/bin/rishot "$@"
    '';
  };
in
{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WALLPAPER_DIR = "${config.home.homeDirectory}/Pictures/Wallpapers";
    GTK_THEME = "Adwaita-dark";
    GDK_THEME = "Adwaita-dark";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
      # colors.conf must be sourced before border colors are applied (HM settings render first)
      source = ~/.config/hypr/colors.conf

      general {
        col.active_border = $active_border
        col.inactive_border = $inactive_border
      }

      gestures {
        workspace_swipe = on
        workspace_swipe_fingers = 3
      }

      submap = passthru
      bind = SUPER SHIFT CTRL ALT, F35, exec, true
      submap = reset

      # Aerospace-style resize submap (ALT+R to enter)
      submap = resize
      bind = , h, resizeactive, -50 0
      bind = , j, resizeactive, 0 50
      bind = , k, resizeactive, 0 -50
      bind = , l, resizeactive, 50 0
      bind = , minus, splitratio, -0.05
      bind = , equal, splitratio, +0.05
      bind = , KP_Subtract, splitratio, -0.05
      bind = , KP_Add, splitratio, +0.05
      bind = , f, fullscreen, 1
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset
    '';

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";

      monitor = ",preferred,auto,1";

      env = [
        "NIXOS_OZONE_WL,1"
        "QT_QPA_PLATFORM,wayland"
      ];

      general = {
        border_size = 3;
        gaps_in = 6;
        gaps_out = 9;
        resize_on_border = true;
        extend_border_grab_area = 30;
        layout = "dwindle";
      };

      decoration = {
        rounding = 6;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          new_optimizations = true;
        };
        shadow.enabled = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad.natural_scroll = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        focus_on_activate = true;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      animations = {
        enabled = "yes";
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
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

      layerrule = [
        "noanim, ^(volume_osd)$"
        "noanim, ^(brightness_osd)$"
        "noanim, hyprpicker"
        "noanim, qsdock"
        "blur, ext-session-lock"
        "ignorealpha 0.2, ext-session-lock"
      ];

      windowrulev2 = [
        "float, title:^(app-launcher)$"
        "center, title:^(app-launcher)$"
        "size 1200 600, title:^(app-launcher)$"
        "animation slide, title:^(app-launcher)$"
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

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        "$mainMod SHIFT, left, resizeactive, -50 0"
        "$mainMod SHIFT, right, resizeactive, 50 0"
        "$mainMod SHIFT, up, resizeactive, 0 -50"
        "$mainMod SHIFT, down, resizeactive, 0 50"
      ];

      bindl = [
        ", Caps_Lock, exec, sleep 0.1 && swayosd-client --caps-lock"
        "$mainMod, SPACE, exec, ~/.config/hypr/scripts/qs_manager.sh toggle applauncher"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", Print, exec, rishot"
        "SHIFT, Print, exec, rishot"
        "SUPER, Print, exec, rishot monitor"
        "SUPER SHIFT, Print, exec, rishot monitor"
        ", XF86PowerOff, exec, bash ~/.config/hypr/scripts/lock.sh"
        ", switch:on:Lid Switch, exec, bash ~/.config/hypr/scripts/lid_monitor.sh"
        ", switch:off:Lid Switch, exec, bash ~/.config/hypr/scripts/lid_monitor.sh"
      ];

      bindel = [
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        "$mainMod, L, exec, bash ~/.config/hypr/scripts/lock.sh"
      ];

      bind = [
        # --- ALT: window manager (aerospace-style) ---
        # ALT+SHIFT binds must come before ALT-only binds (Hyprland matches less-specific mods too)
        "ALT SHIFT, F, togglefloating,"
        "ALT SHIFT, W, exec, bash ~/.config/hypr/scripts/close_others.sh"
        "ALT SHIFT, h, movewindow, l"
        "ALT SHIFT, j, movewindow, d"
        "ALT SHIFT, k, movewindow, u"
        "ALT SHIFT, l, movewindow, r"
        "ALT SHIFT, Tab, movecurrentworkspacetomonitor, +1"
        "ALT SHIFT CTRL, Tab, movecurrentworkspacetomonitor, -1"
        "ALT, Tab, workspace, previous"
        "ALT, F, fullscreen, 1"
        "ALT, W, killactive,"
        "ALT, R, submap, resize"
        "ALT, slash, togglesplit,"
        "ALT, comma, togglegroup,"
        "ALT SHIFT, minus, splitratio, -0.05"
        "ALT SHIFT, equal, splitratio, +0.05"
        "ALT, minus, splitratio, -0.25"
        "ALT, equal, splitratio, +0.25"
        "ALT SHIFT, KP_Subtract, splitratio, -0.05"
        "ALT SHIFT, KP_Add, splitratio, +0.05"
        "ALT, KP_Subtract, splitratio, -0.25"
        "ALT, KP_Add, splitratio, +0.25"
        # Focus (hjkl + arrows)
        "ALT, h, movefocus, l"
        "ALT, j, movefocus, d"
        "ALT, k, movefocus, u"
        "ALT, l, movefocus, r"
        "ALT, left, movefocus, l"
        "ALT, right, movefocus, r"
        "ALT, up, movefocus, u"
        "ALT, down, movefocus, d"
        # Letter workspaces (shift = move window)
        "ALT SHIFT, B, exec, ~/.config/hypr/scripts/qs_manager.sh 1 move"
        "ALT SHIFT, C, exec, ~/.config/hypr/scripts/qs_manager.sh 2 move"
        "ALT SHIFT, T, exec, ~/.config/hypr/scripts/qs_manager.sh 3 move"
        "ALT SHIFT, D, exec, ~/.config/hypr/scripts/qs_manager.sh 4 move"
        "ALT SHIFT, G, exec, ~/.config/hypr/scripts/qs_manager.sh 5 move"
        "ALT, B, exec, ~/.config/hypr/scripts/qs_manager.sh 1"
        "ALT, C, exec, ~/.config/hypr/scripts/qs_manager.sh 2"
        "ALT, T, exec, ~/.config/hypr/scripts/qs_manager.sh 3"
        "ALT, D, exec, ~/.config/hypr/scripts/qs_manager.sh 4"
        "ALT, G, exec, ~/.config/hypr/scripts/qs_manager.sh 5"
        # Numeric workspace aliases
        "ALT SHIFT, 1, exec, ~/.config/hypr/scripts/qs_manager.sh 1 move"
        "ALT SHIFT, 2, exec, ~/.config/hypr/scripts/qs_manager.sh 2 move"
        "ALT SHIFT, 3, exec, ~/.config/hypr/scripts/qs_manager.sh 3 move"
        "ALT SHIFT, 4, exec, ~/.config/hypr/scripts/qs_manager.sh 4 move"
        "ALT SHIFT, 5, exec, ~/.config/hypr/scripts/qs_manager.sh 5 move"
        "ALT SHIFT, 6, exec, ~/.config/hypr/scripts/qs_manager.sh 6 move"
        "ALT SHIFT, 7, exec, ~/.config/hypr/scripts/qs_manager.sh 7 move"
        "ALT SHIFT, 8, exec, ~/.config/hypr/scripts/qs_manager.sh 8 move"
        "ALT SHIFT, 9, exec, ~/.config/hypr/scripts/qs_manager.sh 9 move"
        "ALT SHIFT, 0, exec, ~/.config/hypr/scripts/qs_manager.sh 10 move"
        "ALT, 1, exec, ~/.config/hypr/scripts/qs_manager.sh 1"
        "ALT, 2, exec, ~/.config/hypr/scripts/qs_manager.sh 2"
        "ALT, 3, exec, ~/.config/hypr/scripts/qs_manager.sh 3"
        "ALT, 4, exec, ~/.config/hypr/scripts/qs_manager.sh 4"
        "ALT, 5, exec, ~/.config/hypr/scripts/qs_manager.sh 5"
        "ALT, 6, exec, ~/.config/hypr/scripts/qs_manager.sh 6"
        "ALT, 7, exec, ~/.config/hypr/scripts/qs_manager.sh 7"
        "ALT, 8, exec, ~/.config/hypr/scripts/qs_manager.sh 8"
        "ALT, 9, exec, ~/.config/hypr/scripts/qs_manager.sh 9"
        "ALT, 0, exec, ~/.config/hypr/scripts/qs_manager.sh 10"
        # Screenshot (aerospace mod+shift+s)
        "SUPER SHIFT, S, exec, rishot"
        # --- SUPER: QuickShell widgets ---
        "ALT, F4, exec, hyprctl dispatch killactive"
        "$mainMod, Return, exec, $terminal"
        "$mainMod, E, exec, nautilus"
        "$mainMod, B, exec, vivaldi"
        "$mainMod, M, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle monitors"
        "$mainMod, R, exec, bash ~/.config/hypr/scripts/reload.sh"
        "$mainMod, C, exec, ~/.config/hypr/scripts/qs_manager.sh toggle clipboard"
        "$mainMod, I, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle settings"
        "$mainMod, Q, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle music"
        "$mainMod SHIFT, B, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle battery"
        "$mainMod, W, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle wallpaper"
        "$mainMod, S, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle calendar"
        "$mainMod, N, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle network"
        "$mainMod SHIFT, T, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle focustime"
        "$mainMod, V, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle volume"
        "$mainMod, H, exec, bash ~/.config/hypr/scripts/qs_manager.sh toggle guide"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      exec-once = [
        "swww-daemon"
        "bash ~/.config/hypr/scripts/lid_monitor.sh"
        "bash ~/.config/hypr/scripts/lid_monitor.sh watch &"
        "bash ~/.config/hypr/scripts/apply_wallpaper.sh"
        "bash ~/.config/hypr/scripts/wallpaper_watch.sh"
        "bash ~/.config/hypr/scripts/sync_app_theme.sh"
        "hypridle"
        "playerctld"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swayosd-server"
        "~/.config/hypr/scripts/volume_listener.sh"
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
        "quickshell -p ~/.config/hypr/scripts/quickshell/Shell.qml"
        "python3 ~/.config/hypr/scripts/quickshell/focustime/focus_daemon.py &"
      ];
    };
  };

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

  # Live-editable scripts symlinked from the flake checkout
  home.file.".config/hypr/scripts".source =
    config.lib.file.mkOutOfStoreSymlink scriptsPath;

  # theme_mode and colors.conf are writable files updated by matugen/theme_toggle (not HM symlinks)

  home.file."Pictures/Wallpapers/.keep".text = "";

  home.activation.ensureHyprThemeMode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.config/hypr"
        if [ ! -f "$HOME/.config/hypr/theme_mode" ] || [ -L "$HOME/.config/hypr/theme_mode" ]; then
          rm -f "$HOME/.config/hypr/theme_mode"
          echo dark > "$HOME/.config/hypr/theme_mode"
        fi
        if [ ! -f "$HOME/.config/hypr/colors.conf" ] || [ -L "$HOME/.config/hypr/colors.conf" ]; then
          rm -f "$HOME/.config/hypr/colors.conf"
          cp ${colorsConf} "$HOME/.config/hypr/colors.conf"
        fi
        mkdir -p "$HOME/Pictures/Wallpapers"
        mkdir -p "$HOME/Pictures/Screenshots"
        SETTINGS="$HOME/.config/hypr/settings.json"
        if [ ! -f "$SETTINGS" ] || ! jq empty "$SETTINGS" 2>/dev/null; then
          cat > "$SETTINGS" <<EOF
    {
      "keybinds": [],
      "openGuideAtStartup": true,
      "topbarHelpIcon": true,
      "wallpaperDir": "$HOME/Pictures/Wallpapers",
      "language": "",
      "kbOptions": "",
      "workspaceCount": 8
    }
    EOF
        fi
  '';

  home.packages = [
    quickshellPkg
    rishotPkg
  ] ++ (with pkgs; [
    swww
    playerctl
    pamixer
    pavucontrol
    brightnessctl
    cliphist
    wl-clipboard
    hyprpicker
    libnotify
    swaynotificationcenter
    swayosd
    jq
    curl
    nautilus
    python3
    socat
    imagemagick
    bc
    cava
    mpvpaper
    ffmpeg
    iw
    bluez
    lm_sensors
    acpi
    power-profiles-daemon
    pulseaudio
    alsa-utils
    wl-screenrec
    fd
    ripgrep
    tree
    gtk3
    fortune
    ladspaPlugins
    ladspa-sdk
    inotify-tools
    bluez-tools
    qt6.qtmultimedia
    qt6.qt5compat
    qt6.qtwebsockets
    qt6.qtwebengine
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ]);

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = { name = "Adwaita-dark"; package = pkgs.adwaita-icon-theme; };
    iconTheme = { name = "Adwaita"; package = pkgs.adwaita-icon-theme; };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
