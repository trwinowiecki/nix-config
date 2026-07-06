#!/usr/bin/env bash
# Apply desktop wallpaper to all monitors that are not already showing an image.

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/caching.sh"
qs_ensure_cache "wallpaper_picker"

get_wallpaper_dir() {
    if [[ -n "${WALLPAPER_DIR:-}" ]]; then
        echo "$WALLPAPER_DIR"
        return
    fi
    local settings="${HOME}/.config/hypr/settings.json"
    if [[ -f "$settings" ]] && command -v jq &>/dev/null; then
        local dir
        dir=$(jq -r '.wallpaperDir // empty' "$settings" 2>/dev/null || true)
        if [[ -n "$dir" && "$dir" != "null" ]]; then
            echo "$dir"
            return
        fi
    fi
    echo "${HOME}/Pictures/Wallpapers"
}

WALL_DIR="$(get_wallpaper_dir)"
CACHE_IMG="${QS_CACHE_WALLPAPER_PICKER}/current_wallpaper.png"
MODE_FILE="${HOME}/.config/hypr/theme_mode"
RELOAD_SCRIPT="${HOME}/.config/hypr/scripts/quickshell/wallpaper/matugen_reload.sh"

command -v swww >/dev/null 2>&1 || exit 0

pick_image() {
    if [[ -f "$CACHE_IMG" ]]; then
        echo "$CACHE_IMG"
        return
    fi
    find "$WALL_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        | sort | head -n1
}

IMG="$(pick_image)"
[[ -n "$IMG" && -f "$IMG" ]] || exit 0

needs_apply=false
if ! swww query &>/dev/null; then
    needs_apply=true
else
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        if [[ "$line" == *"color:"* ]]; then
            needs_apply=true
            break
        fi
    done < <(swww query 2>/dev/null | grep -E '^[^:]+:' || true)
fi

if ! $needs_apply; then
    exit 0
fi

swww img "$IMG" --resize crop --transition-type fade --transition-duration 1
cp -f "$IMG" "$CACHE_IMG" 2>/dev/null || true

if command -v matugen &>/dev/null; then
    matugen image "$IMG" --mode "$(cat "$MODE_FILE" 2>/dev/null || echo dark)" || true
    [[ -f "$RELOAD_SCRIPT" ]] && bash "$RELOAD_SCRIPT" || true
fi
