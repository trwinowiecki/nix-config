#!/usr/bin/env bash
# Close all windows on the active workspace except the focused one.

set -euo pipefail

focused_addr=$(hyprctl activewindow -j | jq -r '.address // empty')
if [[ -z "$focused_addr" ]]; then
  exit 0
fi

active_ws=$(hyprctl activeworkspace -j | jq -r '.id')

hyprctl -j clients | jq -r --arg ws "$active_ws" --arg focus "$focused_addr" \
  '.[] | select(.workspace.id == ($ws | tonumber) and .address != $focus) | .address' |
  while read -r addr; do
    [[ -n "$addr" ]] && hyprctl dispatch closewindow "address:${addr}"
  done
