#!/usr/bin/env bash
# Generate wallpaper thumbnails for the picker UI.

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
PREP_LOCK="$QS_RUN_DIR/wallpaper_prep.lock"
MANIFEST="$THUMB_DIR/.manifest"

export MAGICK_THREAD_LIMIT=1
mkdir -p "$THUMB_DIR"

if [[ -f "$PREP_LOCK" ]] && kill -0 "$(cat "$PREP_LOCK")" 2>/dev/null; then
    exit 0
fi
echo $$ > "$PREP_LOCK"
trap 'rm -f "$PREP_LOCK"' EXIT

THUMB_SOURCE_FILE="$THUMB_DIR/.source_dir"
if [[ -f "$THUMB_SOURCE_FILE" ]]; then
    read -r CACHED_SRC < "$THUMB_SOURCE_FILE" || true
    if [[ "$CACHED_SRC" != "$SRC_DIR" ]]; then
        find "$THUMB_DIR" -maxdepth 1 -type f ! -name '.source_dir' ! -name '.manifest' -delete
        echo "$SRC_DIR" > "$THUMB_SOURCE_FILE"
        : > "$MANIFEST"
    fi
else
    echo "$SRC_DIR" > "$THUMB_SOURCE_FILE"
    : > "$MANIFEST"
fi

[[ -f "$MANIFEST" ]] || find "$THUMB_DIR" -maxdepth 1 -type f ! -name '.source_dir' ! -name '.manifest' \
    -printf '%f\n' | sort > "$MANIFEST"

SRC_LIST="$(mktemp)"
find "$SRC_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
       -o -iname '*.gif' -o -iname '*.mp4' -o -iname '*.mkv' \
       -o -iname '*.mov' -o -iname '*.webm' \) \
    -printf '%f\n' | sort > "$SRC_LIST"

while IFS= read -r filename; do
    img="$SRC_DIR/$filename"
    [[ -f "$img" ]] || continue

    extension="${filename##*.}"
    if [[ "${extension,,}" == "webp" ]]; then
        new_img="${img%.*}.jpg"
        if command -v magick &>/dev/null; then
            magick "$img" "$new_img" && rm -f "$img"
            img="$new_img"
            filename="$(basename "$img")"
            extension="jpg"
        fi
    fi

    if [[ "${extension,,}" =~ ^(mp4|mkv|mov|webm)$ ]]; then
        thumb="$THUMB_DIR/000_$filename"
        [[ -f "$THUMB_DIR/$filename" ]] && rm -f "$THUMB_DIR/$filename"
        if [[ ! -f "$thumb" ]] && command -v ffmpeg &>/dev/null; then
            ffmpeg -y -ss 00:00:05 -i "$img" -vframes 1 \
                -threads 1 -f image2 -q:v 2 "$thumb" >/dev/null 2>&1 || true
            echo "000_$filename" >> "$MANIFEST"
        fi
    else
        thumb="$THUMB_DIR/$filename"
        if [[ ! -f "$thumb" ]] && command -v magick &>/dev/null; then
            magick "$img" -resize x420 -quality 70 "$thumb"
            echo "$filename" >> "$MANIFEST"
        fi
    fi
done < <(comm -23 "$SRC_LIST" <(sed 's/^000_//' "$MANIFEST" | sort))

rm -f "$SRC_LIST"
