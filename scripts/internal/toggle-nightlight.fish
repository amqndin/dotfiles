#!/usr/bin/env bash
if pgrep -x "wlsunset" > /dev/null
then
    pkill wlsunset
else
    wlsunset -T 4001
fi
