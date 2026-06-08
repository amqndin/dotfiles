#!/usr/bin/env fish

set BKLIGHT backlight:intel_backlight
set DDC_MON (dms brightness list --ddc 2>/dev/null | string match -r '^ddc:\S+' | head -1)

if test -z "$DDC_MON"
    echo "Error: No DDC monitor found"
    exit 1
end

function change_brightness
    argparse 'i/inc=' 'd/dec=' -- $argv
    or return 1

    if set -q _flag_inc
        dms ipc call brightness increment $_flag_inc $DDC_MON
    else if set -q _flag_dec
        dms ipc call brightness decrement $_flag_dec $DDC_MON
    else
        echo "Error: Need argument"
        return 1
    end
end

if not status is-interactive
    change_brightness $argv
end
