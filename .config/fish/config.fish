not status is-interactive && return

fish_vi_key_bindings
fish_config theme choose "Catppuccin Mocha"
set fish_cursor_insert block
set -U fish_greeting ""

alias nv="nvim"
alias ff="fastfetch"
alias cat="bat"
alias grep="rg"
alias cava-mic="cava -p ~/.config/cava/config_mic"
alias refish="source ~/.config/fish/config.fish"
alias cp="cp -i"
alias mv="mv -i"
alias npm="pnpm"
alias ls="eza --icons --color=always --group-directories-first"

set -l session_name "main"

if not set -q TMUX
    # 1. Look for a session that is NOT currently attached to any window
    set -l zombie_session (tmux list-sessions -F "#{session_name} #{session_attached}" 2>/dev/null | string match -r '.* 0$' | head -n 1 | cut -d' ' -f1)

    if test -n "$zombie_session"
        # 2. If a session exists but isn't being used, take it
        exec tmux attach-session -t "$zombie_session"
    else
        # 3. If all sessions are in use, or none exist, create a new one
        set -l session_count (tmux list-sessions 2>/dev/null | count)
        
        if test "$session_count" -eq 0
            # Brand new start
            exec tmux new-session -s "main"
        else
            # Create a unique window session that dies when the window closes
            set -l session_id "fish_$fish_pid"
            exec tmux new-session -s "$session_id" \; set-option destroy-unattached on
        end
    end
end

function man
    command man $argv | bat -p -l man
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function cdn
    mkdir -p $argv[1]; and cd $argv[1]
end

# set -gx ELECTRON_OZONE_PLATFORM_HINT "auto"
# set -gx DISPLAY ":1"
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx QT_QPA_PLATFORMTHEME "kde"
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"
set -gx BROWSER "zen-browser"
set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#89B4FA,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#89B4FA,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

starship init fish | source
zoxide init fish --cmd cd | source
fzf --fish | source
