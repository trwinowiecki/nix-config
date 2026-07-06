#!/usr/bin/env bash
# Disable the built-in laptop panel when the lid is closed.

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

detect_laptop_panel() {
    if [[ -n "${LAPTOP_PANEL:-}" ]]; then
        echo "$LAPTOP_PANEL"
        return
    fi
    if command -v hyprctl &>/dev/null && command -v jq &>/dev/null; then
        local name
        name=$(hyprctl monitors -j 2>/dev/null | jq -r '
            .[] | select(.name | test("^eDP")) | .name' | head -n1)
        if [[ -n "$name" && "$name" != "null" ]]; then
            echo "$name"
            return
        fi
    fi
    echo "eDP-1"
}

lid_is_closed() {
    local f state
    for f in /proc/acpi/button/lid/*/state; do
        [[ -f "$f" ]] || continue
        read -r state _ < "$f" || true
        [[ "${state,,}" == "closed" ]] && return 0
    done
    return 1
}

apply_lid_state() {
    local panel
    panel="$(detect_laptop_panel)"
    [[ -n "$panel" ]] || return 0

    if lid_is_closed; then
        hyprctl keyword "monitor ${panel},disable" >/dev/null 2>&1 || true
    else
        hyprctl keyword "monitor ${panel},preferred,auto,1" >/dev/null 2>&1 || true
    fi
}

watch_lid() {
    apply_lid_state
    bash "${SCRIPT_DIR}/apply_wallpaper.sh" || true

    local sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
    [[ -n "$sig" && -S "/tmp/hypr/${sig}/.socket2.sock" ]] || return 0
    command -v socat &>/dev/null || return 0

    socat -u "UNIX-CONNECT:/tmp/hypr/${sig}/.socket2.sock" - 2>/dev/null | while read -r line; do
        case "$line" in
            switch:*:Lid*)
                apply_lid_state
                bash "${SCRIPT_DIR}/apply_wallpaper.sh" || true
                ;;
        esac
    done
}

case "${1:-}" in
    watch) watch_lid ;;
    *) apply_lid_state ;;
esac
