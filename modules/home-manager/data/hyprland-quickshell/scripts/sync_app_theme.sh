#!/usr/bin/env bash
# Apply light/dark GTK + Cursor/VS Code theme from ~/.config/hypr/theme_mode

set -euo pipefail

MODE="$(cat "${HOME}/.config/hypr/theme_mode" 2>/dev/null || echo dark)"

if command -v gsettings &>/dev/null; then
    if [[ "$MODE" == "light" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    fi
fi

if ! command -v jq &>/dev/null; then
    exit 0
fi

for settings in \
    "${HOME}/.config/Cursor/User/settings.json" \
    "${HOME}/.config/Code/User/settings.json"; do
    [[ -f "$settings" ]] || continue
    if [[ "$MODE" == "light" ]]; then
        jq '. + {
            "window.autoDetectColorScheme": true,
            "workbench.colorTheme": "Default Light Modern",
            "workbench.preferredLightColorTheme": "Default Light Modern",
            "workbench.preferredDarkColorTheme": "Default Dark Modern"
        }' "$settings" > "${settings}.tmp" && mv "${settings}.tmp" "$settings"
    else
        jq '. + {
            "window.autoDetectColorScheme": true,
            "workbench.colorTheme": "Default Dark Modern",
            "workbench.preferredLightColorTheme": "Default Light Modern",
            "workbench.preferredDarkColorTheme": "Default Dark Modern"
        }' "$settings" > "${settings}.tmp" && mv "${settings}.tmp" "$settings"
    fi
done
