#!/usr/bin/env bash
if pgrep -x "wlsunset" > /dev/null
then
    pkill wlsunset
else
    wlsunset
fi
