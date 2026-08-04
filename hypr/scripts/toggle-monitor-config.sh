#!/usr/bin/env bash
set -euo pipefail

conf="${HOME}/.config/hypr/monitors.conf"
preset="${1:-}"

if [[ ! -f "$conf" ]]; then
  echo "Missing monitors.conf at $conf" >&2
  exit 1
fi

awk -v desired="$preset" '
{
  lines[NR] = $0
  if (match($0, /^# \[([^]]+)\]/, m)) {
    headerCount++
    headerName[headerCount] = m[1]
  }
  headerForLine[NR] = headerCount
  if (headerForLine[NR] > 0 && $0 ~ /^monitor=/) {
    activeHeader[headerForLine[NR]] = 1
  }
}
END {
  if (headerCount == 0) {
    for (i = 1; i <= NR; i++) print lines[i]
    exit 0
  }

  target = 0
  if (desired != "") {
    for (i = 1; i <= headerCount; i++) {
      if (headerName[i] == desired) {
        target = i
        break
      }
    }
    if (target == 0) {
      print "Unknown preset: " desired > "/dev/stderr"
      exit 2
    }
  } else {
    active = 0
    for (i = 1; i <= headerCount; i++) {
      if (activeHeader[i]) {
        active = i
        break
      }
    }
    if (active == 0) active = 1
    target = (active % headerCount) + 1
  }

  for (i = 1; i <= NR; i++) {
    line = lines[i]
    h = headerForLine[i]
    if (h > 0) {
      if (h == target) {
        sub(/^#monitor=/, "monitor=", line)
      } else {
        sub(/^monitor=/, "#monitor=", line)
      }
    }
    print line
  }
}
' "$conf" > "${conf}.tmp"

mv "${conf}.tmp" "$conf"
hyprctl reload
