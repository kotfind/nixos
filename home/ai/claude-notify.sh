#!/usr/bin/env bash

set -euo pipefail

text="${1:-}"

if [ -z "$text" ]; then
    echo "usage: $0 [TEXT]" 2>&1
    exit 1
fi

if [ "$WINDOWID" = "$(xdotool getactivewindow)" ]; then
    exit 0
fi

user_action="$(notify-send \
    --app-name 'claude-code' \
    --action "default=Focus claude windows" \
    'Claude Code' \
    "$text"
)"

if [ "$user_action" = "default" ]; then
    xdotool windowactivate "$WINDOWID"
fi
