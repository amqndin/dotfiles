#!/usr/bin/env fish

set -l internal_sink_id (wpctl status | string match -r -- '(\d+)\..*Built-in Audio Analog.*' | head -n 1)
set -l internal_sink_id (string sub -l 2 -- $internal_sink_id)
set -l headphone_sink_id (wpctl status | string match -r -- '(\d+)\..*Headset Adapter Analog.*' | head -n 1)
set -l headphone_sink_id (string sub -l 2 -- $headphone_sink_id)

if not set -q internal_sink_id
    notify-send -u critical "Audio Error" "Internal speakers not found."
    exit 1
end

if not set -q headphone_sink_id
    notify-send -u critical "Audio Error" "Headphones not found. Is it plugged in?"
    exit 1
end

set -l current_default_id (wpctl status | string match -r -- '\*\s+(\d+)\.' | head -n 1)
set -l current_default_id (string sub --start 5 -- $current_default_id)
set -l current_default_id (string sub -l 2 -- $current_default_id)
echo internal_sink_id $internal_sink_id
echo headphone_sink_id $headphone_sink_id
echo current_default_id $current_default_id

if test "$current_default_id" = "$internal_sink_id"
    wpctl set-default $headphone_sink_id
    notify-send -i "Audio Switched" "Headphones selected."
else
    wpctl set-default $internal_sink_id
    notify-send -i "Audio Switched" "Speakers selected."
end
