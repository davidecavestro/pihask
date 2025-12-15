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

echo "Wait for Weston..."
TIMEOUT=20
COUNT=0
INTERVAL=0.5

while [ ! -e "$WAYLAND_SOCKET" ] && [ $COUNT -lt $((TIMEOUT * 2)) ]; do
    sleep $INTERVAL
    COUNT=$((COUNT + 1))
done

if [ -e "$WAYLAND_SOCKET" ]; then
    COG_PLATFORM_WL_VIEW_WIDTH=${COG_PLATFORM_WL_VIEW_WIDTH:-$(fbset -s | grep geometry| awk '{print $2}')}
    COG_PLATFORM_WL_VIEW_HEIGHT=${COG_PLATFORM_WL_VIEW_HEIGHT:-$(fbset -s | grep geometry| awk '{print $3}')}
    COG_SCALE=${COG_SCALE:-1}
    echo "Weston ready: starting Cog..."
    /usr/bin/cog --scale=$COG_SCALE $COG_HOME_URL &
    COG_PID=$!
else
    echo "Error: Weston didn't start (Timeout)."
    kill $WESTON_PID 2>/dev/null
    rmdir "$XDG_RUNTIME_DIR" 2>/dev/null
    exit 1
fi

wait $WESTON_PID

kill $COG_PID 2>/dev/null
rmdir "$XDG_RUNTIME_DIR" 2>/dev/null

exit 0
