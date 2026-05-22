#!/usr/bin/env fish

function change_brightness
    argparse 'i/inc=' 'd/dec=' -- $argv
    or return 1

    if set -q _flag_inc
        dms ipc call brightness increment $_flag_inc ""
        ddcutil --model "LG FULL HD" setvcp 10 + $_flag_inc
    else if set -q _flag_dec
        dms ipc call brightness decrement $_flag_dec ""
        ddcutil --model "LG FULL HD" setvcp 10 - $_flag_dec
    else
        echo "Error: Need argument"
        return 1
    end
end

change_brightness $argv
