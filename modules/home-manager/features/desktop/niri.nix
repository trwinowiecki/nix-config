# Niri Home Manager Configuration
# Enable with: myHomeManager.desktop.niri.enable = true;
#
# Provides Niri configuration with Waybar, Wofi, Mako, and Swaylock.
# All themed via nix-colors.
{ config, pkgs, lib, ... }:
let
  colors = config.colorScheme.palette;
in {
  # Niri configuration via KDL config file
  xdg.configFile."niri/config.kdl".text = ''
    // Input configuration
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        touchpad {
            tap
            natural-scroll
            accel-speed 0.2
        }

        mouse {
            accel-speed 0.0
        }
    }

    // Output/monitor configuration
    output "eDP-1" {
        scale 1.0
    }

    // Layout configuration
    layout {
        gaps 10
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "#${colors.base0D}"
            inactive-color "#${colors.base03}"
        }

        border {
            off
        }
    }

    // Animations
    animations {
        slowdown 1.0
    }

    // Spawn processes at startup
    spawn-at-startup "waybar"
    spawn-at-startup "mako"

    // Prefer server-side decorations
    prefer-no-csd

    // Screenshot path
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Keybindings
    binds {
        // Application launchers
        Mod+Return { spawn "kitty"; }
        Mod+D { spawn "wofi" "--show" "drun"; }
        Mod+E { spawn "nautilus"; }
        Mod+B { spawn "firefox"; }

        // Window management
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }

        // Focus movement (vim-style)
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        // Focus movement (arrow keys)
        Mod+Left { focus-column-left; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Right { focus-column-right; }

        // Move windows
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        // Column width adjustments
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Window height adjustments
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Fullscreen and floating
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V { toggle-window-floating; }

        // Consume/expel windows (niri's unique feature)
        Mod+BracketLeft { consume-window-into-column; }
        Mod+BracketRight { expel-window-from-column; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // Move to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Workspace navigation
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up { move-column-to-workspace-up; }

        // Screenshots
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Lock screen
        Mod+Escape { spawn "swaylock"; }

        // Power menu could be added here
        // Mod+Shift+P { spawn "wlogout"; }
    }
  '';

  # Waybar for Niri
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "niri/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        cpu = {
          format = " {usage}%";
        };

        memory = {
          format = " {}%";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "Disconnected";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: #${colors.base00};
        color: #${colors.base05};
      }

      #workspaces button {
        padding: 0 5px;
        color: #${colors.base04};
        background-color: transparent;
      }

      #workspaces button.active {
        color: #${colors.base0D};
        background-color: #${colors.base02};
      }

      #workspaces button:hover {
        background-color: #${colors.base01};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: #${colors.base05};
      }

      #battery.charging {
        color: #${colors.base0B};
      }

      #battery.warning:not(.charging) {
        color: #${colors.base0A};
      }

      #battery.critical:not(.charging) {
        color: #${colors.base08};
      }
    '';
  };

  # Wofi launcher
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      show = "drun";
      prompt = "Search...";
      allow_images = true;
      image_size = 24;
    };
    style = ''
      window {
        background-color: #${colors.base00};
        border: 2px solid #${colors.base0D};
        border-radius: 8px;
      }

      #input {
        background-color: #${colors.base01};
        color: #${colors.base05};
        border: none;
        border-radius: 4px;
        margin: 10px;
        padding: 10px;
      }

      #outer-box {
        margin: 5px;
      }

      #text {
        color: #${colors.base05};
      }

      #entry {
        padding: 10px;
      }

      #entry:selected {
        background-color: #${colors.base02};
        border-radius: 4px;
      }
    '';
  };

  # Mako notification daemon
  services.mako = {
    enable = true;
    settings = {
      background-color = "#${colors.base00}";
      text-color = "#${colors.base05}";
      border-color = "#${colors.base0D}";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      padding = "10";
      margin = "10";
    };
  };

  # Swaylock screen locker
  programs.swaylock = {
    enable = true;
    settings = {
      color = "${colors.base00}";
      inside-color = "${colors.base01}";
      inside-clear-color = "${colors.base0A}";
      inside-ver-color = "${colors.base0D}";
      inside-wrong-color = "${colors.base08}";
      key-hl-color = "${colors.base0B}";
      ring-color = "${colors.base02}";
      ring-clear-color = "${colors.base0A}";
      ring-ver-color = "${colors.base0D}";
      ring-wrong-color = "${colors.base08}";
      text-color = "${colors.base05}";
      text-clear-color = "${colors.base00}";
      text-ver-color = "${colors.base00}";
      text-wrong-color = "${colors.base00}";
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  # Screenshot and clipboard tools
  home.packages = with pkgs; [
    slurp          # Region selection
    wl-clipboard   # Wayland clipboard
    pavucontrol    # Audio control
    nautilus       # File manager
  ];
}
