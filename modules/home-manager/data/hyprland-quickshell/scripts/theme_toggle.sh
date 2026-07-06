#!/usr/bin/env bash
# Toggle light/dark matugen theme and re-apply colors from the current wallpaper.

set -euo pipefail

HYPR_DIR="${HOME}/.config/hypr"
MODE_FILE="${HYPR_DIR}/theme_mode"
RELOAD_SCRIPT="${HOME}/.config/hypr/scripts/quickshell/wallpaper/matugen_reload.sh"
CURRENT_WALL="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell/wallpaper_picker/current_wallpaper.png"
FALLBACK_COLORS="${HYPR_DIR}/colors.conf"

current=$(cat "$MODE_FILE" 2>/dev/null || echo dark)
if [[ "$current" == "dark" ]]; then
  next=light
else
  next=dark
fi

echo "$next" > "$MODE_FILE"

wallpaper=""
if [[ -f "$CURRENT_WALL" ]]; then
  wallpaper="$CURRENT_WALL"
else
  wallpaper=$(swww query 2>/dev/null | head -n1 | sed 's/.*image: //' || true)
fi

if [[ -n "$wallpaper" && -f "$wallpaper" ]]; then
  matugen image "$wallpaper" --mode "$next"
  if [[ -x "$RELOAD_SCRIPT" ]] || [[ -f "$RELOAD_SCRIPT" ]]; then
    bash "$RELOAD_SCRIPT" || true
  fi
else
  # No wallpaper yet: matugen-update with a solid color isn't available; keep fallback colors for hypr borders.
  if [[ "$next" == "dark" ]]; then
    cat > "$FALLBACK_COLORS" <<'EOF'
$active_border = rgba(89b4faff)
$inactive_border = rgba(585b70aa)
EOF
  else
    cat > "$FALLBACK_COLORS" <<'EOF'
$active_border = rgba(1a73e8ee)
$inactive_border = rgba(9aa0a6aa)
EOF
  fi
  hyprctl keyword general:col.active_border "$(grep active_border "$FALLBACK_COLORS" | cut -d= -f2- | xargs)" 2>/dev/null || true
  hyprctl keyword general:col.inactive_border "$(grep inactive_border "$FALLBACK_COLORS" | cut -d= -f2- | xargs)" 2>/dev/null || true
fi

bash "${HOME}/.config/hypr/scripts/sync_app_theme.sh" 2>/dev/null || true
