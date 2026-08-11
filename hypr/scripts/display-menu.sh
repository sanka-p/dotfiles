#!/usr/bin/env bash

# Display mode menu using fuzzel
# Pick a monitor preset (extend right/left, duplicate, laptop only) or move the
# active workspace to the other monitor. Presets applied via toggle-monitor-config.sh.
#
#   display-menu.sh             open the menu
#   display-menu.sh --hotplug   open only if not right after a preset switch
#                               (guards against reopening when a preset change
#                               re-fires the monitor.added event)

set -euo pipefail

APP_NAME="Display"
NOTIFY_URGENCY="normal"
TIMEOUT=3000

state_dir="${XDG_STATE_HOME:-${HOME}/.local/state}/hypr"
state_file="${state_dir}/monitor-preset"
guard_file="${state_dir}/display-menu-guard"
toggle="${HOME}/.config/hypr/scripts/toggle-monitor-config.sh"

notify() {
    local summary="$1"
    local body="${2:-}"
    local urgency="${3:-$NOTIFY_URGENCY}"

    if command -v notify-send &>/dev/null; then
        notify-send -a "$APP_NAME" -u "$urgency" -t "$TIMEOUT" "$summary" "$body"
    fi
}

if [[ "${1:-}" == "--hotplug" ]]; then
    if [[ -f "$guard_file" ]]; then
        now=$(date +%s)
        last=$(stat -c %Y "$guard_file" 2>/dev/null || echo 0)
        (( now - last < 5 )) && exit 0
    fi
    pgrep -x fuzzel >/dev/null && exit 0
fi

main() {
    local current="HOME"
    [[ -r "$state_file" ]] && read -r current < "$state_file"

    mark() { [[ "$current" == "$1" ]] && printf '󰄬 ' || printf '  '; }

    local -a entries=(
        "$(mark EXT_RIGHT)󰍺  Extend right"
        "$(mark EXT_LEFT)󰍺  Extend left"
        "$(mark MIRROR)󰍹  Duplicate"
        "$(mark HOME)󰌢  Laptop only"
    )

    local monitor_count
    monitor_count=$(hyprctl -j monitors | grep -c '"id"')
    if (( monitor_count >= 2 )); then
        entries+=("  󰓡  Move workspace to other monitor")
    fi

    local selected
    selected=$(printf '%s\n' "${entries[@]}" | fuzzel --dmenu --prompt "Display: ") || exit 0
    [[ -z "$selected" ]] && exit 0

    apply() {
        mkdir -p "$state_dir"
        touch "$guard_file"
        if "$toggle" "$1" >/dev/null; then
            notify "$2"
        else
            notify "Failed to switch display mode" "" "critical"
            exit 1
        fi
    }

    case "$selected" in
        *"Extend right") apply EXT_RIGHT "Extending to the right" ;;
        *"Extend left")  apply EXT_LEFT "Extending to the left" ;;
        *"Duplicate")    apply MIRROR "Duplicating display" ;;
        *"Laptop only")  apply HOME "Laptop display only" ;;
        *"Move workspace to other monitor")
            if hyprctl dispatch 'hl.dsp.workspace.move({ monitor = "+1" })' >/dev/null 2>&1; then
                notify "Workspace moved"
            else
                notify "Failed to move workspace" "" "critical"
                exit 1
            fi
            ;;
    esac
}

main "$@"
