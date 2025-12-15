#!/bin/bash

set -eo pipefail

HDMI_OUTPUT=${HDMI_OUTPUT:-/sys/class/drm/card0-HDMI-A-1}

mosquitto_sub -h $MQTT_BROKER -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC | while read payload
do
    if [ "$payload" -ne "0" ]; then
	echo "Notification read"
        HDMI_STATUS=$(cat $HDMI_OUTPUT/enabled)
        if [ "$HDMI_STATUS" = "enabled" ]; then
            # no-op
            echo "Leaving screen as-is (enabled)"
        else
            echo "Invoking wakeup"
            /usr/local/bin/wakeup_multitouch.sh
        fi
    fi
done
