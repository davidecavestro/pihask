#!/bin/bash

set -eo pipefail

UNLOCK_DEVICE=${UNLOCK_DEVICE:-"/dev/input/event0"}
X_UNLOCK=${X_UNLOCK:-2036}
Y_UNLOCK=${Y_UNLOCK:-1979}
UNLOCK_WAIT_SECS=${UNLOCK_WAIT_SECS:-1.5}
# ----------------------------------------------------

simulate_touch() {
    local x=$1
    local y=$2

    # Init touch axis (Slot 0)
    evemu-event $UNLOCK_DEVICE --type EV_ABS --code 0x2f --value 0 --sync
    # Assign a track ID
    evemu-event $UNLOCK_DEVICE --type EV_ABS --code 0x39 --value 1234 --sync
    evemu-event $UNLOCK_DEVICE --type EV_ABS --code ABS_MT_POSITION_X --value $X_UNLOCK --sync
    evemu-event $UNLOCK_DEVICE --type EV_ABS --code ABS_MT_POSITION_Y --value $Y_UNLOCK --sync
    evemu-event $UNLOCK_DEVICE --type EV_KEY --code BTN_LEFT --value 1 --sync
    evemu-event $UNLOCK_DEVICE --type EV_SYN --code 0x00 --value 0 --sync
    sleep 0.5
    # --- Release ---
    # Remove the track ID
    evemu-event $UNLOCK_DEVICE --type EV_ABS --code 0x39 --value -1 --sync
    # Sync
    evemu-event $UNLOCK_DEVICE --type EV_SYN --code 0x00 --value 0 --sync
}


echo "$(date): Touch (1/2) sent to wakeup the Compositor."
simulate_touch $X_UNLOCK $Y_UNLOCK

sleep $UNLOCK_WAIT_SECS

echo "$(date): Tuch (2/2) sent to unlock the UI."
simulate_touch $X_UNLOCK $Y_UNLOCK

echo "Wakeup and unlock sequence completed."
