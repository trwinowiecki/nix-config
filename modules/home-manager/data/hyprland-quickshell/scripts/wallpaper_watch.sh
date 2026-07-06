#!/usr/bin/env bash
# Re-apply wallpaper when a monitor is hot-plugged (swww leaves new outputs black).

set -euo pipefail

SIG="${HYPRLAND_INSTANCE_SIGNATURE:-}"
[[ -n "$SIG" ]] || exit 0

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
SOCKET="/tmp/hypr/${SIG}/.socket2.sock"
[[ -S "$SOCKET" ]] || exit 0

command -v socat &>/dev/null || exit 0

socat -u "UNIX-CONNECT:${SOCKET}" - 2>/dev/null | while read -r line; do
    case "$line" in
        monitoradded*)
            bash "${SCRIPT_DIR}/apply_wallpaper.sh"
            ;;
    esac
done
