#!/usr/bin/env bash

MODE="$(cat "${HOME}/.config/hypr/theme_mode" 2>/dev/null || echo dark)"

# Reload Kitty instances
killall -USR1 .kitty-wrapped 2>/dev/null || true

# Reload CAVA
if pgrep -x "cava" > /dev/null; then
    cat ~/.config/cava/config_base ~/.config/cava/colors > ~/.config/cava/config 2>/dev/null
    killall -USR1 cava 2>/dev/null || true
fi

# Reload SwayNC CSS styling dynamically without killing the daemon
if command -v swaync-client &> /dev/null; then
    swaync-client -rs
fi

# Restarting swayosd.service is currently the ONLY way to reload its CSS.
if systemctl --user is-active --quiet swayosd.service; then
    systemctl --user restart swayosd.service &
fi

SYNC_THEME="${HOME}/.config/hypr/scripts/sync_app_theme.sh"
[ -f "$SYNC_THEME" ] && bash "$SYNC_THEME" || true

# Re-apply Hyprland border colors from matugen output
if command -v hyprctl &> /dev/null && [ -f "${HOME}/.config/hypr/colors.conf" ]; then
    hyprctl reload 2>/dev/null || true
fi

wait
