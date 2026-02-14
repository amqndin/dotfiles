#!/usr/bin/env fish

set -l internal "Built-in Audio Analog Stereo"
set -l wired "AB13X Headset Adapter Analog Stereo"
set -l bluetooth "soundcore P30i"

function get_id
    set -l term $argv[1]
    
    if test "$term" = "soundcore P30i"
        set -l filter (wpctl status | grep -A 20 "Filters:" | grep "bluez_output" | grep -oE '[0-9]{2,3}' | head -n 1)
        if test -n "$filter"
            echo $filter
            return 0
        end
    end

    set -l fallback (wpctl status | sed 's/.//' | grep -i "$term" | grep -oE '[0-9]+' | head -n 1)
    
    if test -n "$fallback"
        echo $fallback
        return 0
    end
    
    return 1
end

set -l current (wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -oE 'id [0-9]+' | grep -oE '[0-9]+' | head -n 1)

set -l speaker (get_id "$internal")
set -l headset (get_id "$wired")
set -l buds (get_id "$bluetooth")

if test "$current" = "$speaker"
    if test -n "$headset"
        wpctl set-default $headset
        notify-send "Audio Switched" "Wired Headphones"
    else if test -n "$buds"
        wpctl set-default $buds
        notify-send "Audio Switched" "Soundcore BT"
    end
else if test "$current" = "$headset"
    if test -n "$buds"
        wpctl set-default $buds
        notify-send "Audio Switched" "Soundcore BT"
    else
        wpctl set-default $speaker
        notify-send "Audio Switched" "Internal Speakers"
    end
else
    wpctl set-default $speaker
    notify-send "Audio Switched" "Internal Speakers"
end
