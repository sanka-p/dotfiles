#!/usr/bin/env bash
# Switch the active monitor preset.
#
# Presets themselves live in ~/.config/hypr/monitors.lua; this only records which
# one is active. Keep `presets` below in sync with the `order` list in that file.
#
#   toggle-monitor-config.sh              cycle to the next preset
#   toggle-monitor-config.sh EXT_RIGHT    select a preset by name

set -euo pipefail

presets=(HOME EXT_RIGHT EXT_LEFT MIRROR)

state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/hypr"
state_file="${state_dir}/monitor-preset"
desired="${1:-}"

current="${presets[0]}"
if [[ -r "$state_file" ]]; then
  read -r current < "$state_file" || true
fi

index_of() {
  local name=$1 i
  for i in "${!presets[@]}"; do
    if [[ "${presets[$i]}" == "$name" ]]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

if [[ -n "$desired" ]]; then
  if ! index_of "$desired" > /dev/null; then
    echo "Unknown preset: $desired" >&2
    exit 2
  fi
  target=$desired
else
  if ! current_index=$(index_of "$current"); then
    current_index=0
  fi
  target="${presets[$(((current_index + 1) % ${#presets[@]}))]}"
fi

mkdir -p "$state_dir"
printf '%s\n' "$target" > "$state_file"

hyprctl reload
echo "Monitor preset: $target"
