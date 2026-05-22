#!/usr/bin/env fish

set BKLIGHT backlight:intel_backlight
set DDC_MON ddc:i2c-3

function change_brightness
    argparse 'i/inc=' 'd/dec=' -- $argv
    or return 1

    if set -q _flag_inc
        dms ipc call brightness increment $_flag_inc $BKLIGHT
        dms ipc call brightness increment $_flag_inc $DDC_MON
    else if set -q _flag_dec
        dms ipc call brightness decrement $_flag_dec $BKLIGHT
        dms ipc call brightness decrement $_flag_dec $DDC_MON
    else
        echo "Error: Need argument"
        return 1
    end
end

if not status is-interactive
    change_brightness $argv
end
