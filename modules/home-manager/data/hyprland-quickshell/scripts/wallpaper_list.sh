#!/usr/bin/env bash
# List local wallpapers for the picker (filename|absolute_path) and write wallpapers.json.

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

SRC_DIR="$(get_wallpaper_dir)"
THUMB_DIR="$QS_CACHE_WALLPAPER_PICKER/thumbs"
LIST_JSON="$QS_CACHE_WALLPAPER_PICKER/wallpapers.json"

list_src() {
    find "$SRC_DIR" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
           -o -iname '*.gif' -o -iname '*.mp4' -o -iname '*.mkv' \
           -o -iname '*.mov' -o -iname '*.webm' \) \
        -printf '%f\n' 2>/dev/null | sort -u
}

JSON_ITEMS=()
while IFS= read -r base; do
    [[ -z "$base" ]] && continue
    path=""
    name=""
    if [[ -f "$THUMB_DIR/$base" ]]; then
        name="$base"
        path="$THUMB_DIR/$base"
    elif [[ -f "$THUMB_DIR/000_$base" ]]; then
        name="000_$base"
        path="$THUMB_DIR/000_$base"
    elif [[ -f "$SRC_DIR/$base" ]]; then
        name="$base"
        path="$SRC_DIR/$base"
    fi
    [[ -n "$path" ]] || continue
    printf '%s|%s\n' "$name" "$path"
    if command -v jq &>/dev/null; then
        JSON_ITEMS+=("$(jq -nc --arg fn "$name" --arg fu "file://${path}" '{fileName:$fn,fileUrl:$fu}')")
    fi
done < <(list_src)

if command -v jq &>/dev/null && ((${#JSON_ITEMS[@]} > 0)); then
    printf '%s\n' "${JSON_ITEMS[@]}" | jq -s '.' > "$LIST_JSON"
elif command -v jq &>/dev/null; then
    echo '[]' > "$LIST_JSON"
fi
