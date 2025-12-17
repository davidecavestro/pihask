#!/bin/bash

COG_PLATFORM_WL_VIEW_WIDTH=${COG_PLATFORM_WL_VIEW_WIDTH:-$(fbset -s | grep geometry| awk '{print $2}')}
COG_PLATFORM_WL_VIEW_HEIGHT=${COG_PLATFORM_WL_VIEW_HEIGHT:-$(fbset -s | grep geometry| awk '{print $3}')}
COG_SCALE=${COG_SCALE:-1}

/usr/bin/cog --scale=$COG_SCALE $COG_HOME_URL
