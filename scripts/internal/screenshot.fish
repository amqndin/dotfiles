#!/usr/bin/fish

set screenshot_dir ~/Pictures/Screenshots

if niri msg action screenshot -p false
    inotifywait -q -e close_write $screenshot_dir
    swappy -f (ls -td $screenshot_dir/* | head -n 1)
end
