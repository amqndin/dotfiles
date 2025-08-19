if status is-interactive
    # Commands to run in interactive sessions can go here
end


set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

starship init fish | source
zoxide init fish --cmd cd | source
