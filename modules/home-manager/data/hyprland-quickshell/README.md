# Hyprland + QuickShell Desktop

Hyprland window manager with the [ilyamiro](https://github.com/ilyamiro/nixos-configuration) QuickShell widget stack, integrated into this Nix flake.

## Table of Contents

1. [Directory layout](#directory-layout)
2. [How files are deployed](#how-files-are-deployed)
3. [Keybindings](#keybindings)
4. [Widgets](#widgets)
5. [Theming (matugen)](#theming-matugen)
6. [Wallpapers](#wallpapers)
7. [Weather API](#weather-api)
8. [Changing config](#changing-config)

---

## Directory layout

```
modules/home-manager/data/hyprland-quickshell/
├── colors.conf              # Fallback Hyprland border colors (before matugen runs)
├── scripts/                 # Deployed to ~/.config/hypr/scripts/
│   ├── qs_manager.sh        # Widget toggle / workspace switch IPC
│   ├── lock.sh, screenshot.sh, reload.sh, workspaces.sh, ...
│   ├── close_others.sh      # Close all windows except focused (ALT+SHIFT+W)
│   ├── theme_toggle.sh      # Light/dark matugen toggle (top bar button)
│   └── quickshell/          # QuickShell QML + widget subfolders
│       ├── Shell.qml          # Root: loads Main + TopBar + Floating
│       ├── Main.qml           # Widget overlay (popups)
│       ├── TopBar.qml         # Top bar
│       ├── Floating.qml       # Right-edge quick actions sidebar
│       ├── WindowRegistry.js  # Widget name → QML component map
│       ├── Config.qml         # Settings persistence (~/.config/hypr/settings.json)
│       ├── watchers/          # Background data fetchers for the bar
│       ├── applauncher/, clipboard/, battery/, calendar/, ...
│       └── calendar/
│           ├── weather.sh
│           └── .env           # Your OpenWeather credentials (gitignored)
└── README.md                  # This file

modules/home-manager/data/matugen-config/
├── config.toml                # Matugen template outputs
└── templates/                 # quickshell.json, kitty, rofi, hyprland colors

modules/home-manager/features/desktop/hyprland.nix   # Hyprland + packages + deploy
modules/nixos/features/desktop/hyprland.nix         # GDM, polkit, Qt6 system deps
```

Runtime paths on disk:

| Path | Purpose |
|------|---------|
| `~/.config/hypr/scripts/` | Symlink to flake `scripts/` (live-editable) |
| `~/.config/hypr/colors.conf` | Matugen-generated border colors |
| `~/.config/hypr/theme_mode` | `dark` or `light` |
| `~/.config/hypr/settings.json` | QuickShell settings panel state |
| `/tmp/qs_colors.json` | Matugen colors for QuickShell widgets |
| `~/Pictures/Wallpapers/` | Local wallpaper source folder |

---

## How files are deployed

Home Manager ([hyprland.nix](../../features/desktop/hyprland.nix)):

- **Scripts**: `mkOutOfStoreSymlink` → `~/dotfiles/nix-config/modules/home-manager/data/hyprland-quickshell/scripts`
- **colors.conf**: static fallback from the flake until matugen runs
- **theme_mode**: defaults to `dark`
- **Matugen**: templates copied to `~/.config/matugen/templates/` via the matugen module

Enable in `hosts/laptop/home.nix`:

```nix
myHomeManager.desktop.hyprland.enable = true;
myHomeManager.matugen.enable = true;
```

NixOS side (`hosts/laptop/configuration.nix`):

```nix
myNixOS.desktop.hyprland.enable = true;
```

Rebuild: `./update-flake.sh`

---

## Keybindings

**ALT** = window manager (aerospace-style). **SUPER** = QuickShell widgets.

### Window manager (ALT)

| Key | Action |
|-----|--------|
| `ALT+h/j/k/l` | Focus left/down/up/right |
| `ALT+arrows` | Focus (same) |
| `ALT+SHIFT+h/j/k/l` | Move window |
| `ALT+minus` / `ALT+equal` | Smart resize (split ratio ±0.05) |
| `ALT+KP_Subtract` / `ALT+KP_Add` | Same, numpad − / + |
| `ALT+R` | Enter resize submap (`h/j/k/l`, `minus`/`equal`/`KP_Subtract`/`KP_Add`, `f` fullscreen, `esc` exit) |
| `ALT+slash` | Toggle split direction |
| `ALT+comma` | Toggle tabbed group |
| `ALT+F` | Fullscreen |
| `ALT+SHIFT+F` | Toggle floating |
| `ALT+W` | Close active window |
| `ALT+SHIFT+W` | Close other windows on workspace |
| `ALT+Tab` | Previous workspace |
| `ALT+SHIFT+Tab` | Move current workspace to next monitor (wraps) |
| `ALT+SHIFT+CTRL+Tab` | Move current workspace to previous monitor |
| `ALT+B/C/T/D/G` | Workspace 1–5 (Browser/Cursor/Terminal/misc) |
| `ALT+SHIFT+B/C/T/D/G` | Move window to workspace 1–5 |
| `ALT+1..0` | Workspace 1–10 |
| `ALT+SHIFT+1..0` | Move to workspace 1–10 |

### QuickShell widgets (SUPER)

| Key | Widget |
|-----|--------|
| `SUPER+Space` | App launcher |
| `SUPER+C` | Clipboard |
| `SUPER+I` | Settings |
| `SUPER+W` | Wallpaper picker |
| `SUPER+S` | Calendar |
| `SUPER+N` | Network |
| `SUPER+V` | Volume |
| `SUPER+B` | Battery (SHIFT+B) |
| `SUPER+Q` | Music |
| `SUPER+M` | Monitors |
| `SUPER+H` | Guide / help |
| `SUPER+SHIFT+T` | FocusTime |
| `SUPER+R` | Reload QuickShell |
| `SUPER+SHIFT+S` | Screenshot (region/window via [rishot](https://github.com/Gakuseei/rishot)) |
| `Print` | Screenshot (region/window) |
| `SHIFT+Print` | Screenshot (region/window) |
| `SUPER+Print` | Screenshot (full monitor) |
| `SUPER+SHIFT+Print` | Screenshot (full monitor) |
| `SUPER+L` | Lock |

Edit binds in [hyprland.nix](../../features/desktop/hyprland.nix).

---

## Widgets

All popups are managed by `qs_manager.sh` writing to IPC files; `Main.qml` reads them and morphs a single overlay window.

| Widget | Registry key | Toggle |
|--------|--------------|--------|
| App launcher | `applauncher` | `SUPER+Space` |
| Clipboard | `clipboard` | `SUPER+C` |
| Settings | `settings` | `SUPER+I` or bar gear |
| Wallpaper | `wallpaper` | `SUPER+W` |
| Calendar | `calendar` | `SUPER+S` |
| Network | `network` | `SUPER+N` |
| Volume | `volume` | `SUPER+V` |
| Battery | `battery` | `SUPER+SHIFT+B` |
| Music | `music` | `SUPER+Q` |
| Monitors | `monitors` | `SUPER+M` |
| Guide | `guide` | `SUPER+H` or bar `?` |
| FocusTime | `focustime` | `SUPER+SHIFT+T` |

Add a widget: create QML under `scripts/quickshell/`, register in `WindowRegistry.js`, add a bind + `qs_manager.sh toggle <name>`.

---

## Theming (matugen)

1. Wallpaper colors extracted by `matugen image <path> --mode dark|light`
2. Templates write to `/tmp/qs_colors.json`, `/tmp/kitty-matugen-colors.conf`, `~/.config/hypr/colors.conf`, etc.
3. `MatugenColors.qml` polls `/tmp/qs_colors.json` every second for QuickShell UI
4. **Default**: dark mode (`~/.config/hypr/theme_mode`)
5. **Toggle**: sun/moon button in the top bar, or run `~/.config/hypr/scripts/theme_toggle.sh`
6. **Manual update**: `matugen-update [wallpaper_path]`

After first login, run once:

```bash
matugen-update ~/Pictures/Wallpapers/your-wallpaper.jpg
```

---

## Wallpapers

- **Folder**: `~/Pictures/Wallpapers/` (override with `WALLPAPER_DIR` env var)
- **Open picker**: `SUPER+W`
- **Apply**: click a thumbnail in the picker (runs `swww img` + matugen)

Adding a file to the folder alone does **not** change the wallpaper — open the picker and select it.

Supported: jpg, png, webp, gif, mp4/mkv/mov/webm (video via mpvpaper).

---

## Weather API

Create `scripts/quickshell/calendar/.env` (gitignored), or use **SUPER+I → Weather** and click Save. Copy from `.env.example` as a starting point:

```bash
OPENWEATHER_KEY='your_api_key'
OPENWEATHER_CITY_ID='5016108'  # e.g. Detroit — find the ID in the city URL on openweathermap.org
OPENWEATHER_UNIT='imperial'    # or metric
```

Without a valid key + city ID, the bar shows placeholder weather (`0.0°`, cloud icon).

Get a free key: https://openweathermap.org/api

---

## Changing config

| What | Where |
|------|-------|
| Hyprland binds, autostart, packages | `modules/home-manager/features/desktop/hyprland.nix` |
| QuickShell QML / scripts | `modules/home-manager/data/hyprland-quickshell/scripts/` |
| Matugen templates | `modules/home-manager/data/matugen-config/` |
| Enable/disable desktop | `hosts/laptop/home.nix` + `configuration.nix` |
| Rebuild | `./update-flake.sh` |

After editing QML/scripts in the symlinked tree, reload with `SUPER+R` or `~/.config/hypr/scripts/reload.sh`.
