#/bin/bash

set -eo pipefail

HDMI_OUTPUT=${HDMI_OUTPUT:-/sys/class/drm/card0-HDMI-A-1}
echo "off" | tee $HDMI_OUTPUT/status
