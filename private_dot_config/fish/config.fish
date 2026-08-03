if not status is-interactive
    return
end

set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#89B4FA,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#89B4FA,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
set -x PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1
# set -x CHROME_PATH (which chromium)

fish_vi_key_bindings
fish_config theme choose "Catppuccin Mocha"
set fish_cursor_insert block
set -U fish_greeting ""

# alias e="nvim"
alias nv="nvim"
alias e="neovide --fork"
alias gg="lazygit"
alias cavamic="cava -p ~/.config/cava/config_mic"
alias refish="source ~/.config/fish/config.fish"
alias ls="eza --icons --color=always --group-directories-first"

set -l session_name "main"

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

if not set -q TMUX
    set -l unattached_session (
        tmux list-sessions -F "#{session_name} #{session_attached}" 2>/dev/null \
        | string match -r '.* 0$' \
        | head -n 1 \
        | string split " " -f 1
    )

    if test -n "$unattached_session"
        exec tmux attach-session -t "$unattached_session"
    else
        set -l session_count (tmux list-sessions 2>/dev/null | count)
        
        if test "$session_count" -eq 0
            exec tmux new-session -s "main"
        else
            set -l session_id "sesh_$fish_pid"
            exec tmux new-session -s "$session_id" \; set-option destroy-unattached on
        end
    end
end

starship init fish | source
zoxide init fish --cmd cd | source
fzf --fish | source


# Added by Antigravity CLI installer
set -gx PATH "/home/amandin/.local/bin" $PATH
