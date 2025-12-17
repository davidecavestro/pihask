#!/bin/bash

set -eo pipefail

export XDG_RUNTIME_DIR=/tmp/weston-runtime-dir/
export WAYLAND_DISPLAY=wayland-1
WAYLAND_SOCKET="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 0700 "$XDG_RUNTIME_DIR"
fi

echo "on" > $HDMI_OUTPUT/status
/usr/bin/weston --config=/etc/xdg/weston/weston.ini &
WESTON_PID=$!

wait $WESTON_PID
